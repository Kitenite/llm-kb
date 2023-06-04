import eventlet
from helpers.texts import clean_text

eventlet.monkey_patch()

from storage.storage_context import StorageContextSingleton
import sys
from flask import Flask, request, jsonify
from datasource.ingest import DataSourceHandler
from storage.mongo import MongoDbClientSingleton
from datasource.file_system import File, FileType
from flask_cors import CORS
from flask_socketio import SocketIO
from werkzeug.utils import secure_filename
from llama_index.indices.composability import ComposableGraph
from llama_index import GPTListIndex, GPTVectorStoreIndex


# More setup information here: https://flask.palletsprojects.com/en/2.2.x/tutorial/factory/
def create_app():
    # Enable multiple threads

    # create and configure the app
    app = Flask(__name__)

    # Enable CORS for local development
    CORS(app)
    socketio = SocketIO(
        app, cors_allowed_origins="*", async_mode="eventlet", engineio_logger=True
    )
    socketio.init_app(app)

    @app.route("/post_query", methods=["POST"])
    def post_query():
        """
        Request body should be a JSON object with the following format:
        {
            "query": "What is a summary of this document?",
            "ids": ["id0", "id1"]
        }
        """
        data = request.get_json(force=True)
        if data is None or "query" not in data or "ids" not in data:
            return "Invalid request", 400
        if len(data["ids"]) == 0:
            return "No data selected", 200

        # Get the indices from storage_context the query it
        print(data, file=sys.stderr)
        index_ids = []
        summaries = []
        for id in data["ids"]:
            item_dict = MongoDbClientSingleton.get_file_system_item(id)
            index_ids.append(item_dict["index_id"])
            summaries.append(item_dict["summary"])

        indices = StorageContextSingleton.get_indices(index_ids)

        graph = ComposableGraph.from_indices(
            root_index_cls=GPTVectorStoreIndex,
            children_indices=indices,
            index_summaries=summaries,
            storage_context=StorageContextSingleton.get_context(),
        )
        query_engine = graph.as_query_engine()
        response = clean_text(str(query_engine.query(data["query"])))
        print(response, file=sys.stderr)
        return response

    @app.route("/get_files", methods=["GET"])
    def get_files():
        print("Retrieving all files", file=sys.stderr)
        all_documents = MongoDbClientSingleton.get_all_file_system_items()
        output = []
        for document in all_documents:
            # MongoDB includes _id field which is not serializable, so we need to remove it
            document["id"] = str(document["_id"])
            file_obj = File.from_dict_factory(document)
            output.append(file_obj.to_dict())
        print(f"Returning {len(output)} documents", file=sys.stderr)
        return jsonify(output), 200

    @app.route("/upload_file", methods=["POST"])
    def upload_file():
        if "file" not in request.files:
            return "No file provided", 400

        file = request.files["file"]
        file.filename = secure_filename(file.filename)

        try:
            # Get the GridFS instance for the CORPUS database
            fs = MongoDbClientSingleton.get_document_fs()

            # Save the file to MongoDB and get its id
            file_id = fs.put(file)
            return jsonify({"file_id": str(file_id)}), 200
        except Exception as e:
            return f"Failed to store file: {str(e)}", 400

    @app.route("/create_file", methods=["POST"])
    def create_file():
        print("Creating file system item", file=sys.stderr)
        data = request.get_json()
        # Convert the data to a File object
        item = File.from_dict_factory(data)

        print("Inserting file system item", file=sys.stderr)

        def process_item(item):
            if item.type == FileType.DIRECTORY:
                item.processed = True
                MongoDbClientSingleton.update_item(item)
                socketio.emit("file_system_update")
                return

            index = DataSourceHandler.process_file(item)
            query_engine = index.as_query_engine()

            print("Generating summary", file=sys.stderr)
            summary = clean_text(
                str(query_engine.query("What is a summary of this document?"))
            )
            print(f"Summary: {summary}", file=sys.stderr)

            print("Generating title", file=sys.stderr)
            title = clean_text(
                str(
                    query_engine.query(
                        f"Give this document a title based on its summary: {summary}"
                    )
                )
            )
            print(f"Title: {title}", file=sys.stderr)

            # Update the item with the index
            item.processed = True
            item.index_id = index.index_id
            item.summary = summary
            item.name = title

            MongoDbClientSingleton.update_item(item)
            socketio.emit("file_system_update")

        socketio.start_background_task(process_item, item)

        # Insert item
        MongoDbClientSingleton.update_item(item)
        socketio.emit("file_system_update")

        return (
            f"Processed and inserted file system item",
            200,
        )

    @app.route("/update_file", methods=["POST"])
    def update_file():
        print("Updating file system item", file=sys.stderr)
        data = request.get_json()
        # Convert the data to a File object
        item = File.from_dict_factory(data)

        # Update the file in MongoDB
        result = MongoDbClientSingleton.update_item(item)

        if result.upserted_id is not None:
            print(
                f"Inserted file system item with id: [{result.upserted_id}]",
                file=sys.stderr,
            )
            socketio.emit("file_system_update")
            return f"Inserted file system item with id: [{result.upserted_id}]", 200
        elif result.modified_count > 0:
            socketio.emit("file_system_update")
            return f"Updated file system item with id: [{result.upserted_id}]", 200
        else:
            return "An error occurred during the update.", 500

    @app.route("/delete_file/<id>", methods=["DELETE"])
    def delete_file(id):
        print(f"Deleting file system item with id: {id}", file=sys.stderr)
        file_system_collection = MongoDbClientSingleton.get_file_system_collection()
        result = file_system_collection.delete_one({"_id": id})
        if result.deleted_count == 1:
            print(f"Deleted file system item with id: {id}", file=sys.stderr)
            socketio.emit("file_system_update")
            return f"Deleted file system item with id: {id}", 200
        else:
            return "No file item found with this id.", 404

    @socketio.on("connect")
    def connect():
        print("Client connected", file=sys.stderr)

    @socketio.on("disconnect")
    def disconnect():
        print("Client disconnected", file=sys.stderr)

    return app, socketio


if __name__ == "__main__":
    app, socketio = create_app()
    socketio.run(app, host="0.0.0.0", debug=True)

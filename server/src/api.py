import eventlet

eventlet.monkey_patch()

import sys
from flask import Flask, request, jsonify
from datasource.ingest import DataSourceHandler
from storage.mongo import MongoDbClientSingleton
from datasource.file_system import File
from flask_cors import CORS
from flask_socketio import SocketIO
from werkzeug.utils import secure_filename


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

    @app.route("/query", methods=["POST"])
    def post_query():
        """
        Request body should be a JSON object with the following format:
        {
            "query": "What is a summary of this document?"
        }
        """
        query_text = request.get_json(force=True)
        if query_text is None:
            return "No query text provided", 400
        return "Baby don't hurt me"

    @app.route("/get_files", methods=["GET"])
    def get_files():
        print("Retrieving all files", file=sys.stderr)
        file_system_collection = MongoDbClientSingleton.get_file_system_collection()
        all_documents = file_system_collection.find()
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
            index = DataSourceHandler.process_file(item)

            # Update the item with the index
            print(index, file=sys.stderr)
            item.processed = True
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

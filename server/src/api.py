import sys
from flask import Flask, request, jsonify
from datasource.ingest import DataSourceHandler
from storage.mongo import MongoDbClientSingleton
from datasource.file_system import File
from flask_cors import CORS
from flask_socketio import SocketIO
from werkzeug.utils import secure_filename
import threading


# More setup information here: https://flask.palletsprojects.com/en/2.2.x/tutorial/factory/
def create_app():
    # create and configure the app
    app = Flask(__name__)

    # Enable CORS for local development
    CORS(app)
    socketio = SocketIO(
        app, cors_allowed_origins="*", async_mode="eventlet", engineio_logger=True
    )
    socketio.init_app(app)

    # @app.route("/query", methods=["POST"])
    # def query_index():
    #     """
    #     Request body should be a JSON object with the following format:
    #     {
    #         "query": "What is a summary of this document?"
    #     }
    #     """
    #     query_text = request.get_json(force=True)
    #     if query_text is None:
    #         return "No query text provided", 400
    #     return "Baby don't hurt me"

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

        # Use DataSourceHandler to process the file
        def process_item(item):
            # Use DataSourceHandler to process the file
            DataSourceHandler.process_file(item)

            # After processing, save item in mongodb with processed=True

            # Emit the event back on the main thread when processing is finished
            with app.app_context():
                socketio.emit("file_system_update", {})

        # Call the process_item function in a new thread
        threading.Thread(target=process_item, args=(item,)).start()

        file_system_collection = MongoDbClientSingleton.get_file_system_collection()
        item_dict = item.to_dict()

        # Required MongoDB '_id' field processing
        item_dict["_id"] = item_dict.pop("id")  # use item's 'id' as MongoDB '_id'
        result = file_system_collection.insert_one(item_dict)
        print(
            f"Processed and inserted file system item with id: [{result.inserted_id}]",
            file=sys.stderr,
        )
        socketio.emit("file_system_update", item_dict)

        return (
            f"Processed and inserted file system item with id: [{result.inserted_id}]",
            200,
        )

    @app.route("/update_file", methods=["POST"])
    def update_file():
        print("Updating file system item", file=sys.stderr)
        data = request.get_json()
        # Convert the data to a File object
        item = File.from_dict_factory(data)

        # Get file from MongoDB
        file_system_collection = MongoDbClientSingleton.get_file_system_collection()
        item_dict = item.to_dict()

        # Required MongoDB '_id' field processing
        item_dict["_id"] = item_dict.pop("id")  # use item's 'id' as MongoDB '_id'
        result = file_system_collection.replace_one(
            {"_id": item_dict["_id"]}, item_dict, upsert=True
        )

        if result.upserted_id is not None:
            print(
                f"Inserted file system item with id: [{result.upserted_id}]",
                file=sys.stderr,
            )
            socketio.emit("file_system_update", item_dict)
            return f"Inserted file system item with id: [{result.upserted_id}]", 200
        elif result.modified_count > 0:
            print(
                f"Updated file system item with id: [{item_dict['_id']}]",
                file=sys.stderr,
            )
            socketio.emit("file_system_update", item_dict)
            return f"Updated file system item with id: [{item_dict['_id']}]", 200
        else:
            return "An error occurred during the update.", 500

    @app.route("/delete_file/<id>", methods=["DELETE"])
    def delete_file(id):
        print(f"Deleting file system item with id: {id}", file=sys.stderr)
        file_system_collection = MongoDbClientSingleton.get_file_system_collection()
        result = file_system_collection.delete_one({"_id": id})
        if result.deleted_count == 1:
            print(f"Deleted file system item with id: {id}", file=sys.stderr)
            socketio.emit("file_system_update", {"_id": id, "operation": "delete"})
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
    socketio.run(app, host="0.0.0.0")

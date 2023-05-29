import os, sys, json
from flask import Flask, request, jsonify
from storage.mongo import MongoDbClientSingleton
import datasource.datasource_handler as datasource
import datasource.file_system_item as file_system_item
from flask_cors import CORS
from flask_socketio import SocketIO, send, emit
from bson.json_util import dumps


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

    # @app.route("/ingest_file", methods=["POST"])
    # def ingest_file():
    #     if "file" not in request.files:
    #         return "No file provided", 400
    #     file = request.files.get("file")
    #     print(request.form.get("file_system_item"), file=sys.stderr)
    #     item = file_system_item.FileSystemItem.from_dict(
    #         json.loads(request.form.get("file_system_item"))
    #     )
    #     res = datasource.DataSourceHandler.ingest_file(file, item)
    #     if res.success:
    #         return res.message, 200
    #     else:
    #         return f"Failed to handle data type {res.message}", 400

    # @app.route("/ingest", methods=["POST"])
    # def ingest_data_source():
    #     """
    #     Request body should be a JSON object with the following format:
    #     {
    #         "dataType": "FILE_UPLOAD",
    #         "data": {...}
    #     }
    #     """
    #     json_body = request.get_json(force=True)
    #     if json_body is None:
    #         return "No body provided", 400

    #     data_type = datasource.DataSourceType(json_body.get("dataType"))
    #     if data_type == datasource.DataSourceType.GOOGLE_DOCS:
    #         (result, reason) = datasource.DataSourceHandler.ingest_google_docs(
    #             json_body.data
    #         )
    #     elif data_type == datasource.DataSourceType.LINK:
    #         (result, reason) = datasource.DataSourceHandler.ingest_url(json_body.data)
    #     else:
    #         return "Unknown data type", 400

    #     if result:
    #         return "Success", 200
    #     else:
    #         return f"Failed to handle data type {reason}", 400

    @app.route("/get_files", methods=["GET"])
    def get_files():
        print("Retrieving all files", file=sys.stderr)
        file_system_collection = MongoDbClientSingleton.get_file_system_collection()
        all_documents = file_system_collection.find()
        output = []
        for document in all_documents:
            # MongoDB includes _id field which is not serializable, so we need to remove it
            document["_id"] = str(document["_id"])
            output.append(document)
        print(f"Returning {len(output)} documents", file=sys.stderr)
        return jsonify(output), 200

    @app.route("/create_file", methods=["POST"])
    def create_file():
        print("Creating file system item", file=sys.stderr)
        data = request.get_json()
        item = file_system_item.FileSystemItem.from_dict(data)
        file_system_collection = MongoDbClientSingleton.get_file_system_collection()
        result = file_system_collection.insert_one(item.to_dict())
        f"Inserted file system item with id: [{result.inserted_id}]"
        socketio.emit("file_system_update", item.to_dict())

        return f"Inserted file system item with id: [{result.inserted_id}]", 200

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

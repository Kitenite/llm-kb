import os, sys, json
from flask import Flask, request
from src.storage.storage_context import StorageContextSingleton
import src.datasource.datasource_handler as datasource
import src.datasource.file_system_item as file_system_item
from flask_cors import CORS


# More setup information here: https://flask.palletsprojects.com/en/2.2.x/tutorial/factory/
def create_app(test_config=None):
    # create and configure the app
    app = Flask(__name__, instance_relative_config=True)

    # Enable CORS for local development
    CORS(app)

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

    @app.route("/create_file", methods=["POST"])
    def upload_file_system_item():
        data = request.get_json()
        item = file_system_item.FileSystemItem.from_dict(data)

        print(item, file=sys.stderr)
        # Do something with the FileSystemItem object here
        return "Success", 200

    return app

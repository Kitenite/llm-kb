import os
from flask import request, Flask
import datasource

# More setup information here: https://flask.palletsprojects.com/en/2.2.x/tutorial/factory/
def create_app(test_config=None):
    # create and configure the app
    app = Flask(__name__, instance_relative_config=True)

    @app.route("/query", methods=["POST"])
    def query_index():
        """
        Request body should be a JSON object with the following format:
        {
            "query": "What is a summary of this document?"
        }
        """
        query_text=request.get_json(force=True) 
        if query_text is None:
            return "No query text provided", 400
        return "Baby don't hurt me"


    @app.route("/ingest", methods=["POST"])
    def ingest_data():
        """
        Request body should be a JSON object with the following format:
        {
            "dataType": "FILE",
            "data": {...}
        }
        """
        
        json_body = request.get_json(force=True) 
        if json_body is None:
            return "No body provided", 400
        
        data_type = datasource.DataSourceType(json_body.get("dataType"))
        if data_type == datasource.DataSourceType.FILE:
            (result, reason) = datasource.DataSourceHandler.ingest_document(json_body.data)
        elif data_type == datasource.DataSourceType.GOOGLE_DOCS:
            (result, reason) = datasource.DataSourceHandler.ingest_google_docs(json_body.data)
        else:
            return "Unknown data type", 400
        
        if result:
            return "Success", 200
        else:
            return f"Failed to handle data type {reason}", 400
    return app


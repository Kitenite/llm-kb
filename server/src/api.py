import os
from flask import request, Flask
import datasource

def create_app(test_config=None):
    # create and configure the app
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_mapping(
        # SECRET_KEY='dev',
        # DATABASE=os.path.join(app.instance_path, 'flaskr.sqlite'),
    )

    if test_config is None:
        # load the instance config, if it exists, when not testing
        app.config.from_pyfile('config.py', silent=True)
    else:
        # load the test config if passed in
        app.config.from_mapping(test_config)

    # ensure the instance folder exists
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    # a simple page that says hello
    @app.route('/hello')
    def hello():
        return 'Hello, World!'

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
        return 


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
        # Switch data types
        if data_type == datasource.DataSourceType.FILE:
            datasource.DataSourceHandler.ingest_document(json_body)
        elif data_type == datasource.DataSourceType.GOOGLE_DOCS:
            datasource.DataSourceHandler.ingest_google_docs(json_body)

    return app


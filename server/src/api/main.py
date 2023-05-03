import redis
from flask import request, Flask
from llama_index import SimpleDirectoryReader, GPTSimpleVectorIndex
from enum import Enum
from datasource.handler import DataSourceHandler

app = Flask(__name__)
cache = redis.Redis(host='redis', port=6379)

documents = SimpleDirectoryReader('./data').load_data()
index = GPTSimpleVectorIndex.from_documents(documents)

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
    
    request_query = query_text.get("query")
    response = index.query(request_query)
    return str(response), 200


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
    
    data_type = DataType(json_body.get("dataType"))
    # Switch data types
    if data_type == DataType.FILE:
        DataSourceHandler.ingest_document(json_body)
    elif data_type == DataType.GOOGLE_DOCS:
        DataSourceHandler.ingest_google_docs(json_body)

class DataType(Enum):
    """
    Enumerates the different data types that can be stored in the index.
    """
    FILE = "FILE"
    GOOGLE_DOCS = "GOOGLE_DOCS"

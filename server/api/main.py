import redis
from flask import request, Flask
from llama_index import SimpleDirectoryReader, GPTSimpleVectorIndex

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

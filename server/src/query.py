from llama_index import SimpleDirectoryReader, GPTSimpleVectorIndex

class QueryHandler:
    """
    Handles ingestion of data from different data sources.
    """
    @staticmethod
    def query(json_body):
        """
        Query from a list of files
        """
        
        documents = SimpleDirectoryReader('./data').load_data()
        index = GPTSimpleVectorIndex.from_documents(documents)
        request_query = json_body.get("query")
        response = index.query(request_query)
        return str(response), 200
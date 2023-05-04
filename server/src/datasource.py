from enum import Enum
from llama_index import download_loader
import json

class FileRequestObject:
    """
    Represents a file request object.
    """
    def __init__(self, path, data):
        self.path = path
        self.data = data

class GoogleDocsRequestObject:
    """
    Represents a file request object.
    """
    def __init__(self, path, url):
        self.path = path
        self.url = url

class UrlRequestObject:
    """
    Represents a file request object.
    """
    def __init__(self, path, url):
        self.path = path
        self.url = url

class DataIngestionResponse:
    """
    Represents a response from the data ingestion process.
    """
    def __init__(self, success, message):
        self.success = success
        self.message = message

class DataSourceHandler:
    """
    Handles ingestion of data from different data sources.
    """
    @staticmethod
    def ingest_file(json_body) -> DataIngestionResponse:
        """
        Ingests data from a file upload
        """
        request_object = json.loads(json_body, object_hook=lambda d: FileRequestObject(**d))
        print(request_object.path)
        print(request_object.data)
        return DataIngestionResponse(True, "Success")

    @staticmethod
    def ingest_google_docs(json_body):
        """
        Ingests data from Google Docs.
        """
        pass

    @staticmethod
    def ingest_url(json_body):
        """
        Ingests data from a URL.
        """
        ReadabilityWebPageReader = download_loader("ReadabilityWebPageReader")
        # or set proxy server for playwright: loader = ReadabilityWebPageReader(proxy="http://your-proxy-server:port")
        # For some specific web pages, you may need to set "wait_until" to "networkidle". loader = ReadabilityWebPageReader(wait_until="networkidle")
        loader = ReadabilityWebPageReader()

        documents = loader.load_data(url=json_body.get("url"))


class DataSourceType(Enum):
    """
    Enumerates the different data types that can be stored in the index.
    """
    FILE_UPLOAD = "FILE_UPLOAD"
    GOOGLE_DOCS = "GOOGLE_DOCS"
from enum import Enum
from llama_index import download_loader
import os
import sys

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
    def ingest_file(file, virtual_path) -> DataIngestionResponse:
        """
        Ingests data from a file upload
        """
        
        local_path = os.path.join(os.getcwd(), os.getenv('LOCAL_STORAGE_DIR'), file.filename)
        file.save(local_path)
        # TODO: Send data to handler
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
from enum import Enum

class DataSourceHandler:
    """
    Handles ingestion of data from different data sources.
    """
    @staticmethod
    def ingest_file(json_body):
        """
        Ingests data from a file upload
        """
        pass

    @staticmethod
    def ingest_google_docs(json_body):
        """
        Ingests data from Google Docs.
        """
        pass

class DataSourceType(Enum):
    """
    Enumerates the different data types that can be stored in the index.
    """
    FILE = "FILE"
    GOOGLE_DOCS = "GOOGLE_DOCS"
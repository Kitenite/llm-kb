from enum import Enum
import os
from llama_index import download_loader, GPTVectorStoreIndex
from datasource.file_system_item import FileSystemItem
from storage.storage_context import StorageContextSingleton


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

        local_path = os.path.join(
            os.getcwd(), os.getenv("LOCAL_STORAGE_DIR"), file.filename
        )
        file.save(local_path)
        # TODO: Send data to handler
        return DataIngestionResponse(True, "Success")

    @staticmethod
    def ingest_url(url, virtual_path) -> DataIngestionResponse:
        """
        Ingests data from a URL.
        """
        # Decide to build tree or just one index

        # Get document from link
        ReadabilityWebPageReader = download_loader("ReadabilityWebPageReader")
        loader = ReadabilityWebPageReader(wait_until="networkidle")
        documents = loader.load_data(
            url=url,
        )

        # Create a FileSystemItem

        # Store FileSystemItem

        # Store Nodes along with metadata

        storage_context = StorageContextSingleton.get_instance()
        storage_context.docstore.add_documents(documents)
        index = GPTVectorStoreIndex.from_documents(documents)


class DataSourceType(Enum):
    """
    Enumerates the different data types that can be stored in the index.
    """

    FILE_UPLOAD = "FILE_UPLOAD"
    LINK = "LINK"
    GOOGLE_DOCS = "GOOGLE_DOCS"

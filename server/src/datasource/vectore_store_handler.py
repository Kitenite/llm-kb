from llama_index.vector_stores.types import ExactMatchFilter, MetadataFilters
from llama_index import GPTVectorStoreIndex, SimpleDirectoryReader
from llama_index.vector_stores import ChromaVectorStore
from IPython.display import Markdown, display
from llama_index import StorageContext
import chromadb


class VectorStoreHandler:
    """
    Handles vectore store ingestion of data
    """

    def __init__(self) -> None:
        self.chroma_client = chromadb.Client()
        self.chroma_collection = self.chroma_client.create_collection("collection")
        self.vector_store = ChromaVectorStore(chroma_collection=self.chroma_collection)
        self.storage_context = StorageContext.from_defaults(
            vector_store=self.vector_store
        )

    def save_vector(self, documents) -> str:
        """
        Saves a vector to the vector store
        """
        vector_store = ChromaVectorStore(chroma_collection=self.chroma_collection)
        storage_context = StorageContext.from_defaults(vector_store=vector_store)
        index = GPTVectorStoreIndex.from_documents(
            documents, storage_context=storage_context
        )

    def query_store(filters) -> str:
        """
        Saves a vector to the vector store
        """
        filters = MetadataFilters(
            filters=[ExactMatchFilter(key="theme", value="Mafia")]
        )

        retriever = index.as_retriever(filters=filters)
        retriever.retrieve("What is inception about?")

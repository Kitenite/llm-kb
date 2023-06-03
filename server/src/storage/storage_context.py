from llama_index import StorageContext
from llama_index.storage.index_store import MongoIndexStore
from llama_index.storage.docstore import MongoDocumentStore
from llama_index.vector_stores import WeaviateVectorStore
from llama_index import (
    load_indices_from_storage,
)

import weaviate
from storage.mongo import build_mongodb_uri
import os


class StorageContextSingleton:
    _instance = None

    @classmethod
    def get_instance(cls):
        if not cls._instance:
            # Create Weaviate client
            weaviate_port = os.getenv("CONTAINER_WEAVIATE_PORT")
            weaviate_client = weaviate.Client(url=f"http://weaviate:{weaviate_port}")

            # Create storage context
            docstore = MongoDocumentStore.from_uri(uri=build_mongodb_uri())
            index_store = MongoIndexStore.from_uri(uri=build_mongodb_uri())
            vector_store = WeaviateVectorStore(weaviate_client=weaviate_client)

            cls._instance = StorageContext.from_defaults(
                docstore=docstore,
                vector_store=vector_store,
                index_store=index_store,
            )
        return cls._instance

    @classmethod
    def get_index(self, index_id: str):
        print(index_id)
        index_store = self.get_instance().index_store
        return index_store.get_index_struct(index_id)

    @classmethod
    def get_indices(self, index_ids: list):
        indices = load_indices_from_storage(self.get_instance(), index_ids=index_ids)
        return indices

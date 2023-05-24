from llama_index import StorageContext
from llama_index.storage.index_store import MongoIndexStore
from llama_index.storage.docstore import MongoDocumentStore
from llama_index.vector_stores import WeaviateVectorStore

import weaviate
import os
from enum import Enum
from pymongo import MongoClient


def build_mongodb_uri(database):
    username = os.getenv("MONGO_INITDB_ROOT_USERNAME")
    password = os.getenv("MONGO_INITDB_ROOT_PASSWORD")
    host = "mongodb"
    port = os.getenv("CONTAINER_MONGO_PORT")
    # Build the MongoDB URI
    uri = f"mongodb://{username}:{password}@{host}:{port}/{database}"

    return uri


class StorageContextSingleton:
    _instance = None

    @classmethod
    def get_instance(cls):
        if not cls._instance:
            # Create Weaviate client
            weaviate_port = os.getenv("CONTAINER_WEAVIATE_PORT")
            weaviate_client = weaviate.Client(url=f"http://weaviate:{weaviate_port}")

            # Create storage context
            docstore = MongoDocumentStore.from_uri(
                uri=build_mongodb_uri(MongoDatabases.DOCUMENTS)
            )
            index_store = MongoIndexStore.from_uri(
                uri=build_mongodb_uri(MongoDatabases.INDICES)
            )
            vector_store = WeaviateVectorStore(weaviate_client=weaviate_client)

            cls._instance = StorageContext.from_defaults(
                docstore=docstore,
                vector_store=vector_store,
                index_store=index_store,
            )
        return cls._instance


class MongoDBClientSingleton:
    _instance = None

    @classmethod
    def get_instance(cls):
        if not cls._instance:
            cls._instance = MongoClient(build_mongodb_uri(MongoDatabases.CORPUS))
        return cls._instance


class MongoDatabases(Enum):
    """
    Enumerates the different data types that can be stored in the index.
    """

    INDICES = "indices"
    DOCUMENTS = "documents"
    CORPUS = "corpus"

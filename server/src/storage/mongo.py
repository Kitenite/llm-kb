from enum import Enum
from pymongo import MongoClient
from gridfs import GridFS
import os
from bson.objectid import ObjectId


class MongoDatabases(Enum):
    """
    Different types of MongoDB databases.
    """

    INDICES = "indices"
    DOCUMENTS = "documents"
    CORPUS = "corpus"


class MongoCollections(Enum):
    """
    Different types of MongoDB collections.
    """

    FILE_SYSTEM = "file_system"


def build_mongodb_uri():
    username = os.getenv("MONGO_INITDB_ROOT_USERNAME")
    password = os.getenv("MONGO_INITDB_ROOT_PASSWORD")
    host = "mongodb"
    port = os.getenv("CONTAINER_MONGO_PORT")
    # Build the MongoDB URI
    uri = f"mongodb://{username}:{password}@{host}:{port}"

    return uri


class MongoDbClientSingleton:
    _instance = None

    @classmethod
    def get_instance(cls):
        if not cls._instance:
            cls._instance = MongoClient(build_mongodb_uri())
        return cls._instance

    def get_database(self, database: MongoDatabases):
        return self.get_instance()[database.value]

    @classmethod
    def get_file_system_collection(cls):
        return cls.get_instance()[MongoDatabases.CORPUS.value][
            MongoCollections.FILE_SYSTEM.value
        ]

    @classmethod
    def get_gridfs_instance(cls, database: MongoDatabases):
        return GridFS(cls.get_instance()[database.value])

    @classmethod
    def get_document_fs(cls):
        return cls.get_gridfs_instance(MongoDatabases.DOCUMENTS)

    @classmethod
    def get_document(cls, file_id: str):
        fs = cls.get_document_fs()
        return fs.get(ObjectId(file_id))
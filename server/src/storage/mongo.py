from enum import Enum
from pymongo import MongoClient
from gridfs import GridFS
import os
from bson.objectid import ObjectId

from datasource.file_system import File


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
    uri = f"mongodb://{username}:{password}@{host}:{port}"
    return uri


class MongoDbClientSingleton:
    _instance = None

    @classmethod
    def get_instance(self):
        if not self._instance:
            self._instance = MongoClient(build_mongodb_uri())
        return self._instance

    @classmethod
    def get_database(self, database: MongoDatabases):
        return self.get_instance()[database.value]

    @classmethod
    def get_file_system_collection(self):
        return self.get_instance()[MongoDatabases.CORPUS.value][
            MongoCollections.FILE_SYSTEM.value
        ]

    @classmethod
    def get_all_file_system_items(self):
        return self.get_file_system_collection().find()

    @classmethod
    def get_file_system_items(self, ids: list):
        object_ids = [ObjectId(id) for id in ids]
        collection = self.get_file_system_collection()
        return collection.find({"_id": {"$in": object_ids}})

    @classmethod
    def get_file_system_item(self, id: str):
        object_id = ObjectId(id)
        collection = self.get_file_system_collection()
        return collection.find_one({"_id": object_id})

    @classmethod
    def get_gridfs_instance(self, database: MongoDatabases):
        return GridFS(self.get_instance()[database.value])

    @classmethod
    def get_document_fs(self):
        return self.get_gridfs_instance(MongoDatabases.DOCUMENTS)

    @classmethod
    def get_document(self, file_id: str):
        fs = self.get_document_fs()
        return fs.get(ObjectId(file_id))

    @classmethod
    def update_item(self, item: File):
        file_system_collection = self.get_file_system_collection()
        item_dict = item.to_dict()

        # Use item's 'id' as MongoDB '_id'
        item_dict["_id"] = item_dict.pop("id")

        return file_system_collection.replace_one(
            {"_id": item_dict["_id"]}, item_dict, upsert=True
        )

from llama_index import StorageContext
from llama_index import load_indices_from_storage
import os


class StorageContextSingleton:
    @classmethod
    def get_context(cls):
        persist_dir = os.getenv("CONTEXT_STORAGE_DIR")
        return StorageContext.from_defaults(persist_dir=persist_dir)

    @classmethod
    def get_indices(self, index_ids: list):
        indices = load_indices_from_storage(self.get_context(), index_ids=index_ids)
        return indices

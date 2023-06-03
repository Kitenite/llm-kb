from datasource.file_system import File, Directory, FileType, PdfFile, LinkFile
from llama_index import SimpleWebPageReader, GPTVectorStoreIndex
import sys

from storage.storage_context import StorageContextSingleton


class DataSourceHandler:
    @staticmethod
    def process_pdf(pdf: PdfFile):
        print(f"Processing PDF file with details: {pdf.to_dict()}", file=sys.stderr)

    @staticmethod
    def process_link(link: LinkFile):
        print(f"Processing Link file with details: {link.to_dict()}", file=sys.stderr)

        documents = SimpleWebPageReader(html_to_text=True).load_data([link.url])
        index = GPTVectorStoreIndex.from_documents(
            documents, storage_context=StorageContextSingleton.get_instance()
        )
        StorageContextSingleton.get_instance().persist()
        print("Created index", file=sys.stderr)
        return index

    @staticmethod
    def process_directory(directory: Directory):
        print(
            f"Processing Directory with details: {directory.to_dict()}", file=sys.stderr
        )

    @staticmethod
    def process_generic(file: File):
        print(
            f"Processing Generic file with details: {file.to_dict()}", file=sys.stderr
        )

    @staticmethod
    def process_file(file: File):
        if file.type == FileType.PDF:
            return DataSourceHandler.process_pdf(file)
        elif file.type == FileType.LINK:
            return DataSourceHandler.process_link(file)
        elif file.type == FileType.DIRECTORY:
            return DataSourceHandler.process_directory(file)
        else:  # For FileType.GENERIC and any other cases
            return DataSourceHandler.process_generic(file)

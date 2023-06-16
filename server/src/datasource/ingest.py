from datasource.file_system import (
    File,
    Directory,
    FileType,
    PdfFile,
    LinkFile,
    GithubFile,
)
from llama_index import GPTVectorStoreIndex
import sys, os
from llama_hub.github_repo import GithubClient, GithubRepositoryReader
from storage.storage_context import StorageContextSingleton
from llama_index import TrafilaturaWebReader
from urllib.parse import urlparse


class DataSourceHandler:
    @staticmethod
    def create_index_from_docs(documents):
        storage_context = StorageContextSingleton.get_context()
        index = GPTVectorStoreIndex.from_documents(
            documents, storage_context=storage_context
        )
        storage_context.persist()
        print("Created index", file=sys.stderr)
        return index

    @staticmethod
    def process_pdf(pdf: PdfFile):
        print(f"Processing PDF file with details: {pdf.to_dict()}", file=sys.stderr)

    @staticmethod
    def process_link(file: LinkFile):
        print(f"Processing Link file with details: {file.to_dict()}", file=sys.stderr)
        loader = TrafilaturaWebReader()
        documents = loader.load_data([file.url])
        print(documents, file=sys.stderr)
        return DataSourceHandler.create_index_from_docs(documents)

    @staticmethod
    def process_directory(directory: Directory):
        print(
            f"Processing Directory with details: {directory.to_dict()}", file=sys.stderr
        )

    @staticmethod
    def process_github(file: GithubFile):
        print(f"Processing Github file with details: {file.to_dict()}", file=sys.stderr)

        parsed_url = urlparse(file.url)
        path_parts = parsed_url.path.split("/")

        # The owner and repo names should be the first and second parts of the path
        owner = path_parts[1]
        repo = path_parts[2]

        print("Owner:", owner)
        print("Repo:", repo)

        github_client = GithubClient(os.getenv("GITHUB_TOKEN"))
        loader = GithubRepositoryReader(
            github_client,
            owner=owner,
            repo=repo,
            filter_file_extensions=(
                [
                    ".py",
                    ".ts",
                    ".js",
                    ".html",
                    ".css",
                    ".md",
                    ".txt",
                    ".json",
                    ".yml",
                    ".yaml",
                    ".xml",
                    ".csv",
                    ".java",
                    ".cpp",
                    ".c",
                    ".h",
                    ".sh",
                    ".go",
                    ".php",
                    ".rb",
                    ".rs",
                    ".swift",
                    ".kt",
                    ".sql",
                    ".dockerfile",
                    ".dart",
                ],
                GithubRepositoryReader.FilterType.INCLUDE,
            ),
            verbose=True,
            concurrent_requests=10,
        )

        documents = loader.load_data(branch="main")
        return DataSourceHandler.create_index_from_docs(documents)

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
        elif file.type == FileType.GITHUB:
            return DataSourceHandler.process_github(file)
        else:  # For FileType.GENERIC and any other cases
            return DataSourceHandler.process_generic(file)

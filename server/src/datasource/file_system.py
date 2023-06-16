from enum import Enum
from typing import List
from datetime import datetime
from typing import Optional


class FileType(Enum):
    PDF = "pdf"
    LINK = "link"
    DIRECTORY = "directory"
    GITHUB = "github"
    GENERIC = "generic"


class File:
    def __init__(
        self,
        id: str,
        name: str,
        type: FileType,
        parent_id: str,
        path: str,
        created_at: datetime,
        updated_at: datetime,
        tags: List[str],
        processed: bool,
        summary: Optional[str] = None,
        index_id: Optional[str] = None,
    ):
        self.id = id
        self.name = name
        self.type = type
        self.parent_id = parent_id
        self.path = path
        self.created_at = created_at
        self.updated_at = updated_at
        self.tags = tags
        self.processed = processed
        self.summary = summary
        self.index_id = index_id

    @staticmethod
    def from_dict_factory(data: dict):
        file_type = FileType(data.get("type"))
        if file_type == FileType.DIRECTORY:
            return Directory.from_dict(data)
        elif file_type == FileType.PDF:
            return PdfFile.from_dict(data)
        elif file_type == FileType.LINK:
            return LinkFile.from_dict(data)
        elif file_type == FileType.GITHUB:
            return GithubFile.from_dict(data)
        else:
            return File.from_dict(data)

    def to_dict(self) -> dict:
        return {
            "id": self.id,
            "name": self.name,
            "type": self.type.value,
            "parent_id": self.parent_id,
            "path": self.path,
            "created_at": self.created_at.isoformat(),
            "updated_at": self.updated_at.isoformat(),
            "tags": self.tags,
            "processed": self.processed,
            "index_id": self.index_id,
            "summary": self.summary,
        }

    @classmethod
    def from_dict(cls, data: dict):
        return cls(
            id=data["id"],
            name=data["name"],
            type=FileType(data["type"]),
            parent_id=data["parent_id"],
            path=data["path"],
            created_at=datetime.fromisoformat(data["created_at"]),
            updated_at=datetime.fromisoformat(data["updated_at"]),
            tags=data["tags"],
            processed=data["processed"],
            index_id=data.get("index_id"),
            summary=data.get("summary"),
        )


class PdfFile(File):
    def __init__(self, fs_id: Optional[str] = None, **kwargs):
        super().__init__(type=FileType.PDF, **kwargs)
        self.fs_id = fs_id

    def to_dict(self) -> dict:
        result = super().to_dict()
        result["fs_id"] = self.fs_id
        return result

    @classmethod
    def from_dict(cls, data: dict):
        return cls(
            fs_id=data.get("fs_id"),  # .get() is used here in case fs_id is not present
            id=data["id"],
            name=data["name"],
            parent_id=data["parent_id"],
            path=data["path"],
            created_at=datetime.fromisoformat(data["created_at"]),
            updated_at=datetime.fromisoformat(data["updated_at"]),
            tags=data["tags"],
            processed=data["processed"],
            index_id=data.get("index_id"),
            summary=data.get("summary"),
        )


class LinkFile(File):
    def __init__(self, url: str, **kwargs):
        super().__init__(type=FileType.LINK, **kwargs)
        self.url = url

    def to_dict(self) -> dict:
        result = super().to_dict()
        result["url"] = self.url
        return result

    @classmethod
    def from_dict(cls, data: dict):
        return cls(
            url=data["url"],
            id=data["id"],
            name=data["name"],
            parent_id=data["parent_id"],
            path=data["path"],
            created_at=datetime.fromisoformat(data["created_at"]),
            updated_at=datetime.fromisoformat(data["updated_at"]),
            tags=data["tags"],
            processed=data["processed"],
            index_id=data.get("index_id"),
            summary=data.get("summary"),
        )


class GithubFile(File):
    def __init__(self, url: str, **kwargs):
        super().__init__(type=FileType.GITHUB, **kwargs)
        self.url = url

    def to_dict(self) -> dict:
        result = super().to_dict()
        result["url"] = self.url
        return result

    @classmethod
    def from_dict(cls, data: dict):
        return cls(
            url=data["url"],
            id=data["id"],
            name=data["name"],
            parent_id=data["parent_id"],
            path=data["path"],
            created_at=datetime.fromisoformat(data["created_at"]),
            updated_at=datetime.fromisoformat(data["updated_at"]),
            tags=data["tags"],
            processed=data["processed"],
            index_id=data.get("index_id"),
            summary=data.get("summary"),
        )


class Directory(File):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)

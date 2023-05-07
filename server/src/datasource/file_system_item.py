from enum import Enum
from typing import List
from datetime import datetime


class FileSystemItemType(Enum):
    DIRECTORY = "directory"
    FILE = "file"


class FileSystemItem:
    def __init__(
        self,
        id: str,
        name: str,
        type: FileSystemItemType,
        parent_id: str,
        path: str,
        created_at: datetime,
        updated_at: datetime,
        tags: List[str],
    ):
        self.id = id
        self.name = name
        self.type = type
        self.parent_id = parent_id
        self.path = path
        self.created_at = created_at
        self.updated_at = updated_at
        self.tags = tags

    @property
    def is_directory(self) -> bool:
        return self.type == FileSystemItemType.DIRECTORY

    @property
    def is_file(self) -> bool:
        return self.type == FileSystemItemType.FILE

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
        }

    @classmethod
    def from_dict(cls, data: dict):
        return cls(
            id=data["id"],
            name=data["name"],
            type=FileSystemItemType(data["type"]),
            parent_id=data["parent_id"],
            path=data["path"],
            created_at=datetime.fromisoformat(data["created_at"]),
            updated_at=datetime.fromisoformat(data["updated_at"]),
            tags=data["tags"],
        )

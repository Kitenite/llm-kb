import json
from dataclasses import dataclass
from typing import Optional
from datetime import datetime


@dataclass
class FileSystemItem:
    id: str
    name: str
    type: str
    parent_id: Optional[str] = None
    path: str = "/"
    size: Optional[int] = None
    content: Optional[str] = None
    created_at: datetime = datetime.utcnow()
    updated_at: datetime = datetime.utcnow()

    @property
    def is_directory(self) -> bool:
        return self.type == "directory"

    @property
    def is_file(self) -> bool:
        return self.type == "file"

    @staticmethod
    def from_json(json_str: str) -> "FileSystemItem":
        json_dict = json.loads(json_str)
        return FileSystemItem(
            id=json_dict["_id"],
            name=json_dict["name"],
            type=json_dict["type"],
            parent_id=json_dict.get("parent_id"),
            path=json_dict["path"],
            size=json_dict.get("size"),
            content=json_dict.get("content"),
            created_at=datetime.fromisoformat(json_dict["created_at"]),
            updated_at=datetime.fromisoformat(json_dict["updated_at"]),
        )

    def to_json(self) -> str:
        json_dict = {
            "_id": self.id,
            "name": self.name,
            "type": self.type,
            "parent_id": self.parent_id,
            "path": self.path,
            "size": self.size,
            "content": self.content,
            "created_at": self.created_at.isoformat(),
            "updated_at": self.updated_at.isoformat(),
        }
        return json.dumps(json_dict)

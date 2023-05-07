import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'file_system_item.g.dart';

enum FileSystemItemType {
  directory,
  file,
}

@JsonSerializable(explicitToJson: true)
class FileSystemItem {
  final String id;
  final String name;
  final FileSystemItemType type;
  final String parentId;
  final String path;
  final int size;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  FileSystemItem({
    required this.id,
    required this.name,
    required this.type,
    required this.parentId,
    required this.path,
    required this.size,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isDirectory => type == FileSystemItemType.directory;
  bool get isFile => type == FileSystemItemType.file;

  factory FileSystemItem.fromJson(Map<String, dynamic> json) =>
      _$FileSystemItemFromJson(json);

  Map<String, dynamic> toJson() => _$FileSystemItemToJson(this);
}

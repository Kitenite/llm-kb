import 'package:json_annotation/json_annotation.dart';

part 'file_system_item.g.dart';

enum FileSystemItemType {
  directory,
  file,
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class FileSystemItem {
  final String id;
  final String name;
  final FileSystemItemType type;
  final String parentId;
  final String path;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;

  FileSystemItem({
    required this.id,
    required this.name,
    required this.type,
    required this.parentId,
    required this.path,
    required this.createdAt,
    required this.updatedAt,
    required this.tags,
  });

  bool get isDirectory => type == FileSystemItemType.directory;
  bool get isFile => type == FileSystemItemType.file;

  factory FileSystemItem.fromJson(Map<String, dynamic> json) =>
      _$FileSystemItemFromJson(json);

  Map<String, dynamic> toJson() => _$FileSystemItemToJson(this);
}

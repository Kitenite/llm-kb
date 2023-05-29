import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

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

  static FileSystemItem createFromAnotherFileSystemItem(
      FileSystemItem anotherItem,
      {required String name,
      required FileSystemItemType type,
      required List<String> tags}) {
    String id = const Uuid().v4();
    String parentId =
        anotherItem.isFile ? anotherItem.parentId : anotherItem.id;
    String path = anotherItem.isFile
        ? "${anotherItem.path.substring(0, anotherItem.path.lastIndexOf("/"))}/$id"
        : "${anotherItem.path}/$id";

    return FileSystemItem(
      id: id,
      name: name,
      type: type,
      parentId: parentId,
      path: path,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      tags: tags,
    );
  }

  static FileSystemItem getRootItem() {
    return FileSystemItem(
      id: '-1',
      name: 'Root',
      type: FileSystemItemType.directory,
      parentId: '',
      path: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      tags: [],
    );
  }

  static FileSystemItem createDefaultDir() {
    String id = const Uuid().v4();
    return FileSystemItem(
      id: id,
      name: 'your_first_dir',
      type: FileSystemItemType.directory,
      parentId: '0',
      path: '/$id',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      tags: ['default'],
    );
  }

  factory FileSystemItem.fromJson(Map<String, dynamic> json) =>
      _$FileSystemItemFromJson(json);

  Map<String, dynamic> toJson() => _$FileSystemItemToJson(this);
}

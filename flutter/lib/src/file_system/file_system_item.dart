import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'file_system_item.g.dart';

enum FileSystemItemType {
  directory,
  pdf,
  link,
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
  final String? url;
  final String? fsId; // the id of the document in the file system
  final bool processed; // new field

  FileSystemItem({
    required this.id,
    required this.name,
    required this.type,
    required this.parentId,
    required this.path,
    required this.createdAt,
    required this.updatedAt,
    required this.tags,
    this.url,
    this.fsId,
    this.processed = false,
  });

  bool get isDirectory => type == FileSystemItemType.directory;
  bool get isPdf => type == FileSystemItemType.pdf;
  bool get isLink => type == FileSystemItemType.link;

  static FileSystemItem createFromAnotherFileSystemItem(
    FileSystemItem anotherItem, {
    required String name,
    required FileSystemItemType type,
    required List<String> tags,
    String? url,
    String? fsId,
  }) {
    String id = const Uuid().v4();
    String parentId =
        !anotherItem.isDirectory ? anotherItem.parentId : anotherItem.id;
    String path = !anotherItem.isDirectory
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
      url: url,
      fsId: fsId, // added fsId parameter
      processed: false, // initialize the new field
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
      tags: ['root'],
      processed: true,
    );
  }

  factory FileSystemItem.fromJson(Map<String, dynamic> json) =>
      _$FileSystemItemFromJson(json);

  Map<String, dynamic> toJson() => _$FileSystemItemToJson(this);
}

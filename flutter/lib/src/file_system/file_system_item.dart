import 'package:flutter/material.dart';
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
  final bool processed;
  final String? url;
  final String? fsId; // the id of the document in the file system
  final String? indexId;

  FileSystemItem({
    required this.id,
    required this.name,
    required this.type,
    required this.parentId,
    required this.path,
    required this.createdAt,
    required this.updatedAt,
    required this.tags,
    this.processed = false,
    this.url,
    this.fsId,
    this.indexId,
  });

  bool get isDirectory => type == FileSystemItemType.directory;
  bool get isPdf => type == FileSystemItemType.pdf;
  bool get isLink => type == FileSystemItemType.link;
  bool get isRoot => (type == FileSystemItemType.directory && id == '-1');

  static FileSystemItem createFromAnotherFileSystemItem(
    FileSystemItem anotherItem, {
    required String name,
    required FileSystemItemType type,
    required List<String> tags,
    String? url,
    String? fsId,
    String? indexId,
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
      processed: false,
      url: url,
      fsId: fsId,
      indexId: indexId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileSystemItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory FileSystemItem.fromJson(Map<String, dynamic> json) =>
      _$FileSystemItemFromJson(json);

  Map<String, dynamic> toJson() => _$FileSystemItemToJson(this);

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

  static Icon getIconForFileSystemItem(FileSystemItem item,
      {bool isOutlined = false}) {
    IconData iconData;
    switch (item.type) {
      case FileSystemItemType.directory:
        iconData = isOutlined ? Icons.folder_outlined : Icons.folder;
        break;
      case FileSystemItemType.pdf:
        iconData =
            isOutlined ? Icons.picture_as_pdf_outlined : Icons.picture_as_pdf;
        break;
      case FileSystemItemType.link:
        iconData = isOutlined ? Icons.link : Icons.link;
        break;
      default:
        iconData = isOutlined
            ? Icons.insert_drive_file_outlined
            : Icons.insert_drive_file;
        break;
    }
    return Icon(iconData);
  }
}

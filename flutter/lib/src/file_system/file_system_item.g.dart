// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_system_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileSystemItem _$FileSystemItemFromJson(Map<String, dynamic> json) =>
    FileSystemItem(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$FileSystemItemTypeEnumMap, json['type']),
      parentId: json['parentId'] as String,
      path: json['path'] as String,
      size: json['size'] as int,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$FileSystemItemToJson(FileSystemItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$FileSystemItemTypeEnumMap[instance.type]!,
      'parentId': instance.parentId,
      'path': instance.path,
      'size': instance.size,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$FileSystemItemTypeEnumMap = {
  FileSystemItemType.directory: 'directory',
  FileSystemItemType.file: 'file',
};

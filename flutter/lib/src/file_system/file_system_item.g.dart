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
      parentId: json['parent_id'] as String,
      path: json['path'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      processed: json['processed'] as bool? ?? false,
      url: json['url'] as String?,
      fsId: json['fs_id'] as String?,
      indexId: json['index_id'] as String?,
      summary: json['summary'] as String?,
    );

Map<String, dynamic> _$FileSystemItemToJson(FileSystemItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$FileSystemItemTypeEnumMap[instance.type]!,
      'parent_id': instance.parentId,
      'path': instance.path,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'tags': instance.tags,
      'processed': instance.processed,
      'url': instance.url,
      'fs_id': instance.fsId,
      'index_id': instance.indexId,
      'summary': instance.summary,
    };

const _$FileSystemItemTypeEnumMap = {
  FileSystemItemType.directory: 'directory',
  FileSystemItemType.pdf: 'pdf',
  FileSystemItemType.link: 'link',
  FileSystemItemType.github: 'github',
};

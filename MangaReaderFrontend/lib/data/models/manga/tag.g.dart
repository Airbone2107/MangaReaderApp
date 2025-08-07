// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Tag _$TagFromJson(Map<String, dynamic> json) => _Tag(
  id: json['id'] as String,
  type: json['type'] as String,
  attributes: TagAttributes.fromJson(
    json['attributes'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$TagToJson(_Tag instance) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'attributes': instance.attributes.toJson(),
};

_TagAttributes _$TagAttributesFromJson(Map<String, dynamic> json) =>
    _TagAttributes(
      name: Map<String, String>.from(json['name'] as Map),
      description: Map<String, String>.from(json['description'] as Map),
      group: json['group'] as String,
      version: (json['version'] as num).toInt(),
    );

Map<String, dynamic> _$TagAttributesToJson(_TagAttributes instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'group': instance.group,
      'version': instance.version,
    };

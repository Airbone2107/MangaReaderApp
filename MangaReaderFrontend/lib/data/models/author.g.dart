// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Author _$AuthorFromJson(Map<String, dynamic> json) => _Author(
  id: json['id'] as String,
  type: json['type'] as String,
  attributes: AuthorAttributes.fromJson(
    json['attributes'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$AuthorToJson(_Author instance) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'attributes': instance.attributes.toJson(),
};

_AuthorAttributes _$AuthorAttributesFromJson(Map<String, dynamic> json) =>
    _AuthorAttributes(
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$AuthorAttributesToJson(_AuthorAttributes instance) =>
    <String, dynamic>{'name': instance.name, 'imageUrl': instance.imageUrl};

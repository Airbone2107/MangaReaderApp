// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Manga _$MangaFromJson(Map<String, dynamic> json) => _Manga(
  id: json['id'] as String,
  type: json['type'] as String,
  attributes: MangaAttributes.fromJson(
    json['attributes'] as Map<String, dynamic>,
  ),
  relationships: (json['relationships'] as List<dynamic>)
      .map((e) => Relationship.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MangaToJson(_Manga instance) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'attributes': instance.attributes.toJson(),
  'relationships': instance.relationships.map((e) => e.toJson()).toList(),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cover.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Cover _$CoverFromJson(Map<String, dynamic> json) => _Cover(
  id: json['id'] as String,
  type: json['type'] as String,
  attributes: CoverAttributes.fromJson(
    json['attributes'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$CoverToJson(_Cover instance) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'attributes': instance.attributes.toJson(),
};

_CoverAttributes _$CoverAttributesFromJson(Map<String, dynamic> json) =>
    _CoverAttributes(
      fileName: json['fileName'] as String,
      description: json['description'] as String?,
      volume: json['volume'] as String?,
      locale: json['locale'] as String?,
      version: (json['version'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CoverAttributesToJson(_CoverAttributes instance) =>
    <String, dynamic>{
      'fileName': instance.fileName,
      'description': instance.description,
      'volume': instance.volume,
      'locale': instance.locale,
      'version': instance.version,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

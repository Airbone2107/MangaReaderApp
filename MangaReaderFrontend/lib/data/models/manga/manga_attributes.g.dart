// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manga_attributes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MangaAttributes _$MangaAttributesFromJson(Map<String, dynamic> json) =>
    _MangaAttributes(
      title: Map<String, String>.from(json['title'] as Map),
      altTitles: (json['altTitles'] as List<dynamic>)
          .map((e) => Map<String, String>.from(e as Map))
          .toList(),
      description: Map<String, String>.from(json['description'] as Map),
      isLocked: json['isLocked'] as bool,
      links: (json['links'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      originalLanguage: json['originalLanguage'] as String,
      lastVolume: json['lastVolume'] as String?,
      lastChapter: json['lastChapter'] as String?,
      publicationDemographic: json['publicationDemographic'] as String?,
      status: json['status'] as String?,
      year: (json['year'] as num?)?.toInt(),
      contentRating: json['contentRating'] as String?,
      chapterNumbersResetOnNewVolume:
          json['chapterNumbersResetOnNewVolume'] as bool,
      availableTranslatedLanguages:
          (json['availableTranslatedLanguages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      latestUploadedChapter: json['latestUploadedChapter'] as String?,
      tags: (json['tags'] as List<dynamic>)
          .map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
      state: json['state'] as String,
      version: (json['version'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$MangaAttributesToJson(_MangaAttributes instance) =>
    <String, dynamic>{
      'title': instance.title,
      'altTitles': instance.altTitles,
      'description': instance.description,
      'isLocked': instance.isLocked,
      'links': ?instance.links,
      'originalLanguage': instance.originalLanguage,
      'lastVolume': ?instance.lastVolume,
      'lastChapter': ?instance.lastChapter,
      'publicationDemographic': ?instance.publicationDemographic,
      'status': ?instance.status,
      'year': ?instance.year,
      'contentRating': ?instance.contentRating,
      'chapterNumbersResetOnNewVolume': instance.chapterNumbersResetOnNewVolume,
      'availableTranslatedLanguages': ?instance.availableTranslatedLanguages,
      'latestUploadedChapter': ?instance.latestUploadedChapter,
      'tags': instance.tags.map((e) => e.toJson()).toList(),
      'state': instance.state,
      'version': instance.version,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

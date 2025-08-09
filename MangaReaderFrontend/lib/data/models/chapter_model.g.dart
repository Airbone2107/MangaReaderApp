// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Chapter _$ChapterFromJson(Map<String, dynamic> json) => _Chapter(
  mangaId: json['mangaId'] as String,
  chapterId: json['chapterId'] as String,
  chapterName: json['chapterName'] as String,
  chapterList: json['chapterList'] as List<dynamic>,
);

Map<String, dynamic> _$ChapterToJson(_Chapter instance) => <String, dynamic>{
  'mangaId': instance.mangaId,
  'chapterId': instance.chapterId,
  'chapterName': instance.chapterName,
  'chapterList': instance.chapterList,
};

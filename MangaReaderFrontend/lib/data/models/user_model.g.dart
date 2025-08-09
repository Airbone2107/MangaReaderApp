// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['_id'] as String,
  googleId: json['googleId'] as String?,
  email: json['email'] as String,
  displayName: json['displayName'] as String,
  photoURL: json['photoURL'] as String?,
  authProvider: json['authProvider'] as String,
  isVerified: json['isVerified'] as bool,
  following: (json['followingManga'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  readingProgress: (json['readingManga'] as List<dynamic>)
      .map((e) => ReadingProgress.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  '_id': instance.id,
  'googleId': instance.googleId,
  'email': instance.email,
  'displayName': instance.displayName,
  'photoURL': instance.photoURL,
  'authProvider': instance.authProvider,
  'isVerified': instance.isVerified,
  'followingManga': instance.following,
  'readingManga': instance.readingProgress.map((e) => e.toJson()).toList(),
  'createdAt': instance.createdAt.toIso8601String(),
};

_ReadingProgress _$ReadingProgressFromJson(Map<String, dynamic> json) =>
    _ReadingProgress(
      mangaId: json['mangaId'] as String,
      lastChapter: json['lastChapter'] as String,
      lastReadAt: DateTime.parse(json['lastReadAt'] as String),
      id: json['_id'] as String?,
    );

Map<String, dynamic> _$ReadingProgressToJson(_ReadingProgress instance) =>
    <String, dynamic>{
      'mangaId': instance.mangaId,
      'lastChapter': instance.lastChapter,
      'lastReadAt': instance.lastReadAt.toIso8601String(),
      '_id': instance.id,
    };

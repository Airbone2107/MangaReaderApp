import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Mô hình dữ liệu người dùng.
@freezed
abstract class User with _$User {
  const factory User({
    @JsonKey(name: '_id') required String id,
    String? googleId,
    required String email,
    required String displayName,
    String? photoURL,
    required String authProvider,
    required bool isVerified,
    @JsonKey(name: 'followingManga') required List<String> following,
    @JsonKey(name: 'readingManga')
    required List<ReadingProgress> readingProgress,
    required DateTime createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

/// Tiến độ đọc của người dùng đối với một manga.
@freezed
abstract class ReadingProgress with _$ReadingProgress {
  const factory ReadingProgress({
    required String mangaId,
    required ChapterInfo lastReadChapter,
    required DateTime lastReadAt,
    @JsonKey(name: '_id') String? id,
  }) = _ReadingProgress;

  factory ReadingProgress.fromJson(Map<String, dynamic> json) =>
      _$ReadingProgressFromJson(json);
}

/// Thông tin chi tiết của một chapter được lưu trong lịch sử.
@freezed
abstract class ChapterInfo with _$ChapterInfo {
  const factory ChapterInfo({
    required String id,
    String? chapter,
    String? title,
    required String translatedLanguage,
  }) = _ChapterInfo;

  factory ChapterInfo.fromJson(Map<String, dynamic> json) =>
      _$ChapterInfoFromJson(json);
}



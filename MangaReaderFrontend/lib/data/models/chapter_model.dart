import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter_model.freezed.dart';
part 'chapter_model.g.dart';

/// Mô tả thông tin chương đang đọc và danh sách các chương liên quan.
@freezed
abstract class Chapter with _$Chapter {
  const factory Chapter({
    required String mangaId,
    required String chapterId,
    required String chapterName,
    /// Danh sách raw chapter trả về từ API (cấu trúc không đồng nhất).
    required List<dynamic> chapterList,
  }) = _Chapter;

  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);
}

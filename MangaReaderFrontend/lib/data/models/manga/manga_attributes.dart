import 'package:freezed_annotation/freezed_annotation.dart';
import 'tag.dart';

part 'manga_attributes.freezed.dart';
part 'manga_attributes.g.dart';

/// Thuộc tính chi tiết của một Manga.
@freezed
abstract class MangaAttributes with _$MangaAttributes {
  @JsonSerializable(
    explicitToJson: true,
    includeIfNull: false,
  )
  const factory MangaAttributes({
    required Map<String, String> title,
    required List<dynamic> altTitles,
    required Map<String, String> description,
    required bool isLocked,
    Map<String, String>? links,
    required String originalLanguage,
    String? lastVolume,
    String? lastChapter,
    String? publicationDemographic,
    String? status,
    int? year,
    String? contentRating,
    required bool chapterNumbersResetOnNewVolume,
    List<String>? availableTranslatedLanguages,
    String? latestUploadedChapter,
    required List<Tag> tags,
    required String state,
    required int version,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MangaAttributes;

  factory MangaAttributes.fromJson(Map<String, dynamic> json) =>
      _$MangaAttributesFromJson(json);
}

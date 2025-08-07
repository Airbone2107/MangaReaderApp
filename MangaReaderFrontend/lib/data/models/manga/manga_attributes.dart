import 'package:freezed_annotation/freezed_annotation.dart';
import 'tag.dart';

part 'manga_attributes.freezed.dart';
part 'manga_attributes.g.dart';

@freezed
abstract class MangaAttributes with _$MangaAttributes {
  @JsonSerializable(
    explicitToJson: true,
    includeIfNull: false, // Thêm dòng này
  )
  const factory MangaAttributes({
    required Map<String, String> title,
    required List<Map<String, String>> altTitles,
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

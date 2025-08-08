import 'package:freezed_annotation/freezed_annotation.dart';
import 'relationship.dart';
import 'manga_attributes.dart';

part 'manga.freezed.dart';
part 'manga.g.dart';

/// Mô hình dữ liệu Manga cơ bản từ MangaDex.
@freezed
abstract class Manga with _$Manga {
  const factory Manga({
    required String id,
    required String type,
    required MangaAttributes attributes,
    required List<Relationship> relationships,
  }) = _Manga;

  factory Manga.fromJson(Map<String, dynamic> json) => _$MangaFromJson(json);
}

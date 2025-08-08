import 'package:freezed_annotation/freezed_annotation.dart';

part 'cover.freezed.dart';
part 'cover.g.dart';

/// Mô tả dữ liệu bìa (cover) của manga.
@freezed
abstract class Cover with _$Cover {
  const factory Cover({
    required String id,
    required String type,
    required CoverAttributes attributes,
  }) = _Cover;

  factory Cover.fromJson(Map<String, dynamic> json) => _$CoverFromJson(json);
}

/// Thuộc tính chi tiết của bìa manga.
@freezed
abstract class CoverAttributes with _$CoverAttributes {
  const factory CoverAttributes({
    required String fileName,
    String? description,
    String? volume,
    String? locale,
    required int version,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CoverAttributes;

  factory CoverAttributes.fromJson(Map<String, dynamic> json) =>
      _$CoverAttributesFromJson(json);
}

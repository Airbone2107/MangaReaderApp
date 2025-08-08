import 'package:freezed_annotation/freezed_annotation.dart';

part 'tag.freezed.dart';
part 'tag.g.dart';

/// Thông tin một tag và nhóm của nó.
@freezed
abstract class Tag with _$Tag {
  const factory Tag({
    required String id,
    required String type,
    required TagAttributes attributes,
  }) = _Tag;

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
}

/// Thuộc tính chi tiết của một tag.
@freezed
abstract class TagAttributes with _$TagAttributes {
  const factory TagAttributes({
    required Map<String, String> name,
    required Map<String, String> description,
    required String group,
    required int version,
  }) = _TagAttributes;

  factory TagAttributes.fromJson(Map<String, dynamic> json) =>
      _$TagAttributesFromJson(json);
}

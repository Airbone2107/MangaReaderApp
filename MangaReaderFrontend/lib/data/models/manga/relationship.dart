import 'package:freezed_annotation/freezed_annotation.dart';

part 'relationship.freezed.dart';
part 'relationship.g.dart';

/// Quan hệ giữa manga và các thực thể liên quan (author, cover_art, ...).
@freezed
abstract class Relationship with _$Relationship {
  const factory Relationship({
    required String id,
    required String type,
    String? related,
    Map<String, dynamic>? attributes,
  }) = _Relationship;

  factory Relationship.fromJson(Map<String, dynamic> json) =>
      _$RelationshipFromJson(json);
}

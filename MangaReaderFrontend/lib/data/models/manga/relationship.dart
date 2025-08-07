import 'package:freezed_annotation/freezed_annotation.dart';

part 'relationship.freezed.dart';
part 'relationship.g.dart';

@freezed
abstract class Relationship with _$Relationship {
  const factory Relationship({
    required String id,
    required String type,
    Map<String, dynamic>? attributes,
  }) = _Relationship;

  factory Relationship.fromJson(Map<String, dynamic> json) =>
      _$RelationshipFromJson(json);
}
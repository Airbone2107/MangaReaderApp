import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_response.freezed.dart';
part 'list_response.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class ListResponse<T> with _$ListResponse<T> {
  const factory ListResponse({
    required String result,
    required String response,
    required List<T> data,
    required int limit,
    required int offset,
    required int total,
  }) = _ListResponse<T>;

  factory ListResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json) fromJsonT,
      ) =>
      _$ListResponseFromJson<T>(json, fromJsonT);
}
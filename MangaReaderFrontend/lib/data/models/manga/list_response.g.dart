// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ListResponse<T> _$ListResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _ListResponse<T>(
  result: json['result'] as String,
  response: json['response'] as String,
  data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
  limit: (json['limit'] as num).toInt(),
  offset: (json['offset'] as num).toInt(),
  total: (json['total'] as num).toInt(),
);

Map<String, dynamic> _$ListResponseToJson<T>(
  _ListResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'result': instance.result,
  'response': instance.response,
  'data': instance.data.map(toJsonT).toList(),
  'limit': instance.limit,
  'offset': instance.offset,
  'total': instance.total,
};

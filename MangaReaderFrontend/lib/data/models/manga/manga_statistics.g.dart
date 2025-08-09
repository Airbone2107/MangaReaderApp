// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manga_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MangaStatisticsResponse _$MangaStatisticsResponseFromJson(
  Map<String, dynamic> json,
) => _MangaStatisticsResponse(
  result: json['result'] as String,
  statistics: (json['statistics'] as Map<String, dynamic>).map(
    (k, e) =>
        MapEntry(k, MangaStatisticsData.fromJson(e as Map<String, dynamic>)),
  ),
);

Map<String, dynamic> _$MangaStatisticsResponseToJson(
  _MangaStatisticsResponse instance,
) => <String, dynamic>{
  'result': instance.result,
  'statistics': instance.statistics.map((k, e) => MapEntry(k, e.toJson())),
};

_MangaStatisticsData _$MangaStatisticsDataFromJson(Map<String, dynamic> json) =>
    _MangaStatisticsData(
      rating: Rating.fromJson(json['rating'] as Map<String, dynamic>),
      follows: (json['follows'] as num).toInt(),
    );

Map<String, dynamic> _$MangaStatisticsDataToJson(
  _MangaStatisticsData instance,
) => <String, dynamic>{
  'rating': instance.rating.toJson(),
  'follows': instance.follows,
};

_Rating _$RatingFromJson(Map<String, dynamic> json) => _Rating(
  average: (json['average'] as num?)?.toDouble(),
  bayesian: (json['bayesian'] as num).toDouble(),
);

Map<String, dynamic> _$RatingToJson(_Rating instance) => <String, dynamic>{
  'average': instance.average,
  'bayesian': instance.bayesian,
};

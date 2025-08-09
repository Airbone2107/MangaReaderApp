import 'package:freezed_annotation/freezed_annotation.dart';

part 'manga_statistics.freezed.dart';
part 'manga_statistics.g.dart';

@freezed
abstract class MangaStatisticsResponse with _$MangaStatisticsResponse {
  const factory MangaStatisticsResponse({
    required String result,
    required Map<String, MangaStatisticsData> statistics,
  }) = _MangaStatisticsResponse;

  factory MangaStatisticsResponse.fromJson(Map<String, dynamic> json) =>
      _$MangaStatisticsResponseFromJson(json);
}

@freezed
abstract class MangaStatisticsData with _$MangaStatisticsData {
  const factory MangaStatisticsData({
    required Rating rating,
    required int follows,
  }) = _MangaStatisticsData;

  factory MangaStatisticsData.fromJson(Map<String, dynamic> json) =>
      _$MangaStatisticsDataFromJson(json);
}

@freezed
abstract class Rating with _$Rating {
  const factory Rating({
    double? average,
    required double bayesian,
  }) = _Rating;

  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);
}



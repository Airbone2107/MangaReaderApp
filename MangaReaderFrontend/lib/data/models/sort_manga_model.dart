/// Thứ tự sắp xếp.
enum SortOrder { asc, desc }

/// Mô hình tham số tìm kiếm/lọc cho API MangaDex.
class MangaSearchQuery {
  String? title;
  List<String>? authors;
  List<String>? artists;
  int? year;
  List<String>? includedTags;
  String? includedTagsMode; // AND, OR
  List<String>? excludedTags;
  String? excludedTagsMode; // AND, OR
  List<String>? status;
  List<String>? originalLanguage;
  List<String>? excludedOriginalLanguage;
  List<String>? availableTranslatedLanguage;
  List<String>? publicationDemographic;
  List<String>? contentRating;
  String? createdAtSince; // YYYY-MM-DDTHH:MM:SS
  String? updatedAtSince; // YYYY-MM-DDTHH:MM:SS
  Map<String, SortOrder>? order;

  MangaSearchQuery({
    this.title,
    this.authors,
    this.artists,
    this.year,
    this.includedTags,
    this.includedTagsMode = 'AND',
    this.excludedTags,
    this.excludedTagsMode = 'OR',
    this.status,
    this.originalLanguage,
    this.excludedOriginalLanguage,
    this.availableTranslatedLanguage,
    this.publicationDemographic,
    this.contentRating,
    this.createdAtSince,
    this.updatedAtSince,
    this.order,
  });

  // Tạo một bản sao của object
  MangaSearchQuery copyWith({
    String? title,
    List<String>? authors,
    List<String>? artists,
    int? year,
    List<String>? includedTags,
    String? includedTagsMode,
    List<String>? excludedTags,
    String? excludedTagsMode,
    List<String>? status,
    List<String>? originalLanguage,
    List<String>? excludedOriginalLanguage,
    List<String>? availableTranslatedLanguage,
    List<String>? publicationDemographic,
    List<String>? contentRating,
    String? createdAtSince,
    String? updatedAtSince,
    Map<String, SortOrder>? order,
  }) {
    return MangaSearchQuery(
      title: title ?? this.title,
      authors: authors ?? this.authors,
      artists: artists ?? this.artists,
      year: year ?? this.year,
      includedTags: includedTags ?? this.includedTags,
      includedTagsMode: includedTagsMode ?? this.includedTagsMode,
      excludedTags: excludedTags ?? this.excludedTags,
      excludedTagsMode: excludedTagsMode ?? this.excludedTagsMode,
      status: status ?? this.status,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      excludedOriginalLanguage:
          excludedOriginalLanguage ?? this.excludedOriginalLanguage,
      availableTranslatedLanguage:
          availableTranslatedLanguage ?? this.availableTranslatedLanguage,
      publicationDemographic:
          publicationDemographic ?? this.publicationDemographic,
      contentRating: contentRating ?? this.contentRating,
      createdAtSince: createdAtSince ?? this.createdAtSince,
      updatedAtSince: updatedAtSince ?? this.updatedAtSince,
      order: order ?? this.order,
    );
  }

  /// Chuyển đổi đối tượng thành map tham số query.
  Map<String, dynamic> toParams() {
    final Map<String, dynamic> params = <String, dynamic>{};

    if (title != null && title!.isNotEmpty) params['title'] = title;
    if (authors != null && authors!.isNotEmpty) params['authors[]'] = authors;
    if (artists != null && artists!.isNotEmpty) params['artists[]'] = artists;
    if (year != null) params['year'] = year.toString();
    if (includedTags != null && includedTags!.isNotEmpty) {
      params['includedTags[]'] = includedTags;
      params['includedTagsMode'] = includedTagsMode;
    }
    if (excludedTags != null && excludedTags!.isNotEmpty) {
      params['excludedTags[]'] = excludedTags;
      params['excludedTagsMode'] = excludedTagsMode;
    }
    if (status != null && status!.isNotEmpty) params['status[]'] = status;
    if (originalLanguage != null && originalLanguage!.isNotEmpty) {
      params['originalLanguage[]'] = originalLanguage;
    }
    if (excludedOriginalLanguage != null &&
        excludedOriginalLanguage!.isNotEmpty) {
      params['excludedOriginalLanguage[]'] = excludedOriginalLanguage;
    }
    if (availableTranslatedLanguage != null &&
        availableTranslatedLanguage!.isNotEmpty) {
      params['availableTranslatedLanguage[]'] = availableTranslatedLanguage;
    }
    if (publicationDemographic != null && publicationDemographic!.isNotEmpty) {
      params['publicationDemographic[]'] = publicationDemographic;
    }
    if (contentRating != null && contentRating!.isNotEmpty) {
      params['contentRating[]'] = contentRating;
    }
    if (createdAtSince != null) params['createdAtSince'] = createdAtSince;
    if (updatedAtSince != null) params['updatedAtSince'] = updatedAtSince;

    if (order != null && order!.isNotEmpty) {
      order!.forEach((String key, SortOrder value) {
        params['order[$key]'] = value.name;
      });
    }

    return params;
  }
}

// Giữ tương thích ngược cho mã hiện có
typedef SortManga = MangaSearchQuery;

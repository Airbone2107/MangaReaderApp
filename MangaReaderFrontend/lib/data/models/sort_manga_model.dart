/// Thứ tự sắp xếp.
enum SortOrder { asc, desc }

/// Mô hình tham số tìm kiếm/sắp xếp cho API MangaDex.
class SortManga {
  String? title;
  String? authorOrArtist;
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
  List<String>? ids;
  List<String>? contentRating;
  String? createdAtSince; // YYYY-MM-DDTHH:MM:SS
  String? updatedAtSince; // YYYY-MM-DDTHH:MM:SS
  bool? hasAvailableChapters;
  String? group;
  Map<String, SortOrder>? order;

  SortManga({
    this.title,
    this.authorOrArtist,
    this.authors,
    this.artists,
    this.year,
    this.includedTags,
    this.includedTagsMode,
    this.excludedTags,
    this.excludedTagsMode,
    this.status,
    this.originalLanguage,
    this.excludedOriginalLanguage,
    this.availableTranslatedLanguage,
    this.publicationDemographic,
    this.ids,
    this.contentRating,
    this.createdAtSince,
    this.updatedAtSince,
    this.hasAvailableChapters,
    this.group,
    this.order,
  });

  /// Chuyển đổi đối tượng thành map tham số query.
  Map<String, dynamic> toParams() {
    final Map<String, dynamic> params = <String, dynamic>{};

    if (title != null && title!.isNotEmpty) {
      params['title'] = title;
    }
    if (authorOrArtist != null && authorOrArtist!.isNotEmpty) {
      params['authorOrArtist'] = authorOrArtist;
    }
    if (authors != null && authors!.isNotEmpty) {
      params['authors[]'] = authors;
    }
    if (artists != null && artists!.isNotEmpty) {
      params['artists[]'] = artists;
    }
    if (year != null) {
      params['year'] = year.toString();
    }
    if (includedTags != null && includedTags!.isNotEmpty) {
      params['includedTags[]'] = includedTags;
    }
    if (includedTagsMode != null) {
      params['includedTagsMode'] = includedTagsMode;
    }
    if (excludedTags != null && excludedTags!.isNotEmpty) {
      params['excludedTags[]'] = excludedTags;
    }
    if (excludedTagsMode != null) {
      params['excludedTagsMode'] = excludedTagsMode;
    }
    if (status != null && status!.isNotEmpty) {
      params['status[]'] = status;
    }
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
    if (ids != null && ids!.isNotEmpty) {
      params['ids[]'] = ids;
    }
    if (contentRating != null && contentRating!.isNotEmpty) {
      params['contentRating[]'] = contentRating;
    }
    if (createdAtSince != null) {
      params['createdAtSince'] = createdAtSince;
    }
    if (updatedAtSince != null) {
      params['updatedAtSince'] = updatedAtSince;
    }
    if (hasAvailableChapters != null) {
      params['hasAvailableChapters'] = hasAvailableChapters! ? '1' : '0';
    }
    if (group != null && group!.isNotEmpty) {
      params['group'] = group;
    }
    if (order != null && order!.isNotEmpty) {
      order!.forEach((String key, SortOrder value) {
        params['order[$key]'] = value.name;
      });
    }

    return params;
  }
}

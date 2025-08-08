// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manga_attributes.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MangaAttributes {

 Map<String, String> get title; List<dynamic> get altTitles; Map<String, String> get description; bool get isLocked; Map<String, String>? get links; String get originalLanguage; String? get lastVolume; String? get lastChapter; String? get publicationDemographic; String? get status; int? get year; String? get contentRating; bool get chapterNumbersResetOnNewVolume; List<String>? get availableTranslatedLanguages; String? get latestUploadedChapter; List<Tag> get tags; String get state; int get version; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of MangaAttributes
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MangaAttributesCopyWith<MangaAttributes> get copyWith => _$MangaAttributesCopyWithImpl<MangaAttributes>(this as MangaAttributes, _$identity);

  /// Serializes this MangaAttributes to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MangaAttributes&&const DeepCollectionEquality().equals(other.title, title)&&const DeepCollectionEquality().equals(other.altTitles, altTitles)&&const DeepCollectionEquality().equals(other.description, description)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&const DeepCollectionEquality().equals(other.links, links)&&(identical(other.originalLanguage, originalLanguage) || other.originalLanguage == originalLanguage)&&(identical(other.lastVolume, lastVolume) || other.lastVolume == lastVolume)&&(identical(other.lastChapter, lastChapter) || other.lastChapter == lastChapter)&&(identical(other.publicationDemographic, publicationDemographic) || other.publicationDemographic == publicationDemographic)&&(identical(other.status, status) || other.status == status)&&(identical(other.year, year) || other.year == year)&&(identical(other.contentRating, contentRating) || other.contentRating == contentRating)&&(identical(other.chapterNumbersResetOnNewVolume, chapterNumbersResetOnNewVolume) || other.chapterNumbersResetOnNewVolume == chapterNumbersResetOnNewVolume)&&const DeepCollectionEquality().equals(other.availableTranslatedLanguages, availableTranslatedLanguages)&&(identical(other.latestUploadedChapter, latestUploadedChapter) || other.latestUploadedChapter == latestUploadedChapter)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.state, state) || other.state == state)&&(identical(other.version, version) || other.version == version)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,const DeepCollectionEquality().hash(title),const DeepCollectionEquality().hash(altTitles),const DeepCollectionEquality().hash(description),isLocked,const DeepCollectionEquality().hash(links),originalLanguage,lastVolume,lastChapter,publicationDemographic,status,year,contentRating,chapterNumbersResetOnNewVolume,const DeepCollectionEquality().hash(availableTranslatedLanguages),latestUploadedChapter,const DeepCollectionEquality().hash(tags),state,version,createdAt,updatedAt]);

@override
String toString() {
  return 'MangaAttributes(title: $title, altTitles: $altTitles, description: $description, isLocked: $isLocked, links: $links, originalLanguage: $originalLanguage, lastVolume: $lastVolume, lastChapter: $lastChapter, publicationDemographic: $publicationDemographic, status: $status, year: $year, contentRating: $contentRating, chapterNumbersResetOnNewVolume: $chapterNumbersResetOnNewVolume, availableTranslatedLanguages: $availableTranslatedLanguages, latestUploadedChapter: $latestUploadedChapter, tags: $tags, state: $state, version: $version, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $MangaAttributesCopyWith<$Res>  {
  factory $MangaAttributesCopyWith(MangaAttributes value, $Res Function(MangaAttributes) _then) = _$MangaAttributesCopyWithImpl;
@useResult
$Res call({
 Map<String, String> title, List<dynamic> altTitles, Map<String, String> description, bool isLocked, Map<String, String>? links, String originalLanguage, String? lastVolume, String? lastChapter, String? publicationDemographic, String? status, int? year, String? contentRating, bool chapterNumbersResetOnNewVolume, List<String>? availableTranslatedLanguages, String? latestUploadedChapter, List<Tag> tags, String state, int version, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$MangaAttributesCopyWithImpl<$Res>
    implements $MangaAttributesCopyWith<$Res> {
  _$MangaAttributesCopyWithImpl(this._self, this._then);

  final MangaAttributes _self;
  final $Res Function(MangaAttributes) _then;

/// Create a copy of MangaAttributes
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? altTitles = null,Object? description = null,Object? isLocked = null,Object? links = freezed,Object? originalLanguage = null,Object? lastVolume = freezed,Object? lastChapter = freezed,Object? publicationDemographic = freezed,Object? status = freezed,Object? year = freezed,Object? contentRating = freezed,Object? chapterNumbersResetOnNewVolume = null,Object? availableTranslatedLanguages = freezed,Object? latestUploadedChapter = freezed,Object? tags = null,Object? state = null,Object? version = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as Map<String, String>,altTitles: null == altTitles ? _self.altTitles : altTitles // ignore: cast_nullable_to_non_nullable
as List<dynamic>,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as Map<String, String>,isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,links: freezed == links ? _self.links : links // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,originalLanguage: null == originalLanguage ? _self.originalLanguage : originalLanguage // ignore: cast_nullable_to_non_nullable
as String,lastVolume: freezed == lastVolume ? _self.lastVolume : lastVolume // ignore: cast_nullable_to_non_nullable
as String?,lastChapter: freezed == lastChapter ? _self.lastChapter : lastChapter // ignore: cast_nullable_to_non_nullable
as String?,publicationDemographic: freezed == publicationDemographic ? _self.publicationDemographic : publicationDemographic // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,contentRating: freezed == contentRating ? _self.contentRating : contentRating // ignore: cast_nullable_to_non_nullable
as String?,chapterNumbersResetOnNewVolume: null == chapterNumbersResetOnNewVolume ? _self.chapterNumbersResetOnNewVolume : chapterNumbersResetOnNewVolume // ignore: cast_nullable_to_non_nullable
as bool,availableTranslatedLanguages: freezed == availableTranslatedLanguages ? _self.availableTranslatedLanguages : availableTranslatedLanguages // ignore: cast_nullable_to_non_nullable
as List<String>?,latestUploadedChapter: freezed == latestUploadedChapter ? _self.latestUploadedChapter : latestUploadedChapter // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<Tag>,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [MangaAttributes].
extension MangaAttributesPatterns on MangaAttributes {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MangaAttributes value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MangaAttributes() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MangaAttributes value)  $default,){
final _that = this;
switch (_that) {
case _MangaAttributes():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MangaAttributes value)?  $default,){
final _that = this;
switch (_that) {
case _MangaAttributes() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, String> title,  List<dynamic> altTitles,  Map<String, String> description,  bool isLocked,  Map<String, String>? links,  String originalLanguage,  String? lastVolume,  String? lastChapter,  String? publicationDemographic,  String? status,  int? year,  String? contentRating,  bool chapterNumbersResetOnNewVolume,  List<String>? availableTranslatedLanguages,  String? latestUploadedChapter,  List<Tag> tags,  String state,  int version,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MangaAttributes() when $default != null:
return $default(_that.title,_that.altTitles,_that.description,_that.isLocked,_that.links,_that.originalLanguage,_that.lastVolume,_that.lastChapter,_that.publicationDemographic,_that.status,_that.year,_that.contentRating,_that.chapterNumbersResetOnNewVolume,_that.availableTranslatedLanguages,_that.latestUploadedChapter,_that.tags,_that.state,_that.version,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, String> title,  List<dynamic> altTitles,  Map<String, String> description,  bool isLocked,  Map<String, String>? links,  String originalLanguage,  String? lastVolume,  String? lastChapter,  String? publicationDemographic,  String? status,  int? year,  String? contentRating,  bool chapterNumbersResetOnNewVolume,  List<String>? availableTranslatedLanguages,  String? latestUploadedChapter,  List<Tag> tags,  String state,  int version,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _MangaAttributes():
return $default(_that.title,_that.altTitles,_that.description,_that.isLocked,_that.links,_that.originalLanguage,_that.lastVolume,_that.lastChapter,_that.publicationDemographic,_that.status,_that.year,_that.contentRating,_that.chapterNumbersResetOnNewVolume,_that.availableTranslatedLanguages,_that.latestUploadedChapter,_that.tags,_that.state,_that.version,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, String> title,  List<dynamic> altTitles,  Map<String, String> description,  bool isLocked,  Map<String, String>? links,  String originalLanguage,  String? lastVolume,  String? lastChapter,  String? publicationDemographic,  String? status,  int? year,  String? contentRating,  bool chapterNumbersResetOnNewVolume,  List<String>? availableTranslatedLanguages,  String? latestUploadedChapter,  List<Tag> tags,  String state,  int version,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _MangaAttributes() when $default != null:
return $default(_that.title,_that.altTitles,_that.description,_that.isLocked,_that.links,_that.originalLanguage,_that.lastVolume,_that.lastChapter,_that.publicationDemographic,_that.status,_that.year,_that.contentRating,_that.chapterNumbersResetOnNewVolume,_that.availableTranslatedLanguages,_that.latestUploadedChapter,_that.tags,_that.state,_that.version,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class _MangaAttributes implements MangaAttributes {
  const _MangaAttributes({required final  Map<String, String> title, required final  List<dynamic> altTitles, required final  Map<String, String> description, required this.isLocked, final  Map<String, String>? links, required this.originalLanguage, this.lastVolume, this.lastChapter, this.publicationDemographic, this.status, this.year, this.contentRating, required this.chapterNumbersResetOnNewVolume, final  List<String>? availableTranslatedLanguages, this.latestUploadedChapter, required final  List<Tag> tags, required this.state, required this.version, required this.createdAt, required this.updatedAt}): _title = title,_altTitles = altTitles,_description = description,_links = links,_availableTranslatedLanguages = availableTranslatedLanguages,_tags = tags;
  factory _MangaAttributes.fromJson(Map<String, dynamic> json) => _$MangaAttributesFromJson(json);

 final  Map<String, String> _title;
@override Map<String, String> get title {
  if (_title is EqualUnmodifiableMapView) return _title;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_title);
}

 final  List<dynamic> _altTitles;
@override List<dynamic> get altTitles {
  if (_altTitles is EqualUnmodifiableListView) return _altTitles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_altTitles);
}

 final  Map<String, String> _description;
@override Map<String, String> get description {
  if (_description is EqualUnmodifiableMapView) return _description;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_description);
}

@override final  bool isLocked;
 final  Map<String, String>? _links;
@override Map<String, String>? get links {
  final value = _links;
  if (value == null) return null;
  if (_links is EqualUnmodifiableMapView) return _links;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String originalLanguage;
@override final  String? lastVolume;
@override final  String? lastChapter;
@override final  String? publicationDemographic;
@override final  String? status;
@override final  int? year;
@override final  String? contentRating;
@override final  bool chapterNumbersResetOnNewVolume;
 final  List<String>? _availableTranslatedLanguages;
@override List<String>? get availableTranslatedLanguages {
  final value = _availableTranslatedLanguages;
  if (value == null) return null;
  if (_availableTranslatedLanguages is EqualUnmodifiableListView) return _availableTranslatedLanguages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? latestUploadedChapter;
 final  List<Tag> _tags;
@override List<Tag> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  String state;
@override final  int version;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of MangaAttributes
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MangaAttributesCopyWith<_MangaAttributes> get copyWith => __$MangaAttributesCopyWithImpl<_MangaAttributes>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MangaAttributesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MangaAttributes&&const DeepCollectionEquality().equals(other._title, _title)&&const DeepCollectionEquality().equals(other._altTitles, _altTitles)&&const DeepCollectionEquality().equals(other._description, _description)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&const DeepCollectionEquality().equals(other._links, _links)&&(identical(other.originalLanguage, originalLanguage) || other.originalLanguage == originalLanguage)&&(identical(other.lastVolume, lastVolume) || other.lastVolume == lastVolume)&&(identical(other.lastChapter, lastChapter) || other.lastChapter == lastChapter)&&(identical(other.publicationDemographic, publicationDemographic) || other.publicationDemographic == publicationDemographic)&&(identical(other.status, status) || other.status == status)&&(identical(other.year, year) || other.year == year)&&(identical(other.contentRating, contentRating) || other.contentRating == contentRating)&&(identical(other.chapterNumbersResetOnNewVolume, chapterNumbersResetOnNewVolume) || other.chapterNumbersResetOnNewVolume == chapterNumbersResetOnNewVolume)&&const DeepCollectionEquality().equals(other._availableTranslatedLanguages, _availableTranslatedLanguages)&&(identical(other.latestUploadedChapter, latestUploadedChapter) || other.latestUploadedChapter == latestUploadedChapter)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.state, state) || other.state == state)&&(identical(other.version, version) || other.version == version)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,const DeepCollectionEquality().hash(_title),const DeepCollectionEquality().hash(_altTitles),const DeepCollectionEquality().hash(_description),isLocked,const DeepCollectionEquality().hash(_links),originalLanguage,lastVolume,lastChapter,publicationDemographic,status,year,contentRating,chapterNumbersResetOnNewVolume,const DeepCollectionEquality().hash(_availableTranslatedLanguages),latestUploadedChapter,const DeepCollectionEquality().hash(_tags),state,version,createdAt,updatedAt]);

@override
String toString() {
  return 'MangaAttributes(title: $title, altTitles: $altTitles, description: $description, isLocked: $isLocked, links: $links, originalLanguage: $originalLanguage, lastVolume: $lastVolume, lastChapter: $lastChapter, publicationDemographic: $publicationDemographic, status: $status, year: $year, contentRating: $contentRating, chapterNumbersResetOnNewVolume: $chapterNumbersResetOnNewVolume, availableTranslatedLanguages: $availableTranslatedLanguages, latestUploadedChapter: $latestUploadedChapter, tags: $tags, state: $state, version: $version, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MangaAttributesCopyWith<$Res> implements $MangaAttributesCopyWith<$Res> {
  factory _$MangaAttributesCopyWith(_MangaAttributes value, $Res Function(_MangaAttributes) _then) = __$MangaAttributesCopyWithImpl;
@override @useResult
$Res call({
 Map<String, String> title, List<dynamic> altTitles, Map<String, String> description, bool isLocked, Map<String, String>? links, String originalLanguage, String? lastVolume, String? lastChapter, String? publicationDemographic, String? status, int? year, String? contentRating, bool chapterNumbersResetOnNewVolume, List<String>? availableTranslatedLanguages, String? latestUploadedChapter, List<Tag> tags, String state, int version, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$MangaAttributesCopyWithImpl<$Res>
    implements _$MangaAttributesCopyWith<$Res> {
  __$MangaAttributesCopyWithImpl(this._self, this._then);

  final _MangaAttributes _self;
  final $Res Function(_MangaAttributes) _then;

/// Create a copy of MangaAttributes
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? altTitles = null,Object? description = null,Object? isLocked = null,Object? links = freezed,Object? originalLanguage = null,Object? lastVolume = freezed,Object? lastChapter = freezed,Object? publicationDemographic = freezed,Object? status = freezed,Object? year = freezed,Object? contentRating = freezed,Object? chapterNumbersResetOnNewVolume = null,Object? availableTranslatedLanguages = freezed,Object? latestUploadedChapter = freezed,Object? tags = null,Object? state = null,Object? version = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_MangaAttributes(
title: null == title ? _self._title : title // ignore: cast_nullable_to_non_nullable
as Map<String, String>,altTitles: null == altTitles ? _self._altTitles : altTitles // ignore: cast_nullable_to_non_nullable
as List<dynamic>,description: null == description ? _self._description : description // ignore: cast_nullable_to_non_nullable
as Map<String, String>,isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,links: freezed == links ? _self._links : links // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,originalLanguage: null == originalLanguage ? _self.originalLanguage : originalLanguage // ignore: cast_nullable_to_non_nullable
as String,lastVolume: freezed == lastVolume ? _self.lastVolume : lastVolume // ignore: cast_nullable_to_non_nullable
as String?,lastChapter: freezed == lastChapter ? _self.lastChapter : lastChapter // ignore: cast_nullable_to_non_nullable
as String?,publicationDemographic: freezed == publicationDemographic ? _self.publicationDemographic : publicationDemographic // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,contentRating: freezed == contentRating ? _self.contentRating : contentRating // ignore: cast_nullable_to_non_nullable
as String?,chapterNumbersResetOnNewVolume: null == chapterNumbersResetOnNewVolume ? _self.chapterNumbersResetOnNewVolume : chapterNumbersResetOnNewVolume // ignore: cast_nullable_to_non_nullable
as bool,availableTranslatedLanguages: freezed == availableTranslatedLanguages ? _self._availableTranslatedLanguages : availableTranslatedLanguages // ignore: cast_nullable_to_non_nullable
as List<String>?,latestUploadedChapter: freezed == latestUploadedChapter ? _self.latestUploadedChapter : latestUploadedChapter // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<Tag>,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

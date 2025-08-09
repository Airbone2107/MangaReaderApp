// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chapter_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Chapter {

 String get mangaId; String get chapterId; String get chapterName;/// Danh sách raw chapter trả về từ API (cấu trúc không đồng nhất).
 List<dynamic> get chapterList;
/// Create a copy of Chapter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterCopyWith<Chapter> get copyWith => _$ChapterCopyWithImpl<Chapter>(this as Chapter, _$identity);

  /// Serializes this Chapter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Chapter&&(identical(other.mangaId, mangaId) || other.mangaId == mangaId)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.chapterName, chapterName) || other.chapterName == chapterName)&&const DeepCollectionEquality().equals(other.chapterList, chapterList));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mangaId,chapterId,chapterName,const DeepCollectionEquality().hash(chapterList));

@override
String toString() {
  return 'Chapter(mangaId: $mangaId, chapterId: $chapterId, chapterName: $chapterName, chapterList: $chapterList)';
}


}

/// @nodoc
abstract mixin class $ChapterCopyWith<$Res>  {
  factory $ChapterCopyWith(Chapter value, $Res Function(Chapter) _then) = _$ChapterCopyWithImpl;
@useResult
$Res call({
 String mangaId, String chapterId, String chapterName, List<dynamic> chapterList
});




}
/// @nodoc
class _$ChapterCopyWithImpl<$Res>
    implements $ChapterCopyWith<$Res> {
  _$ChapterCopyWithImpl(this._self, this._then);

  final Chapter _self;
  final $Res Function(Chapter) _then;

/// Create a copy of Chapter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mangaId = null,Object? chapterId = null,Object? chapterName = null,Object? chapterList = null,}) {
  return _then(_self.copyWith(
mangaId: null == mangaId ? _self.mangaId : mangaId // ignore: cast_nullable_to_non_nullable
as String,chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as String,chapterName: null == chapterName ? _self.chapterName : chapterName // ignore: cast_nullable_to_non_nullable
as String,chapterList: null == chapterList ? _self.chapterList : chapterList // ignore: cast_nullable_to_non_nullable
as List<dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [Chapter].
extension ChapterPatterns on Chapter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Chapter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Chapter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Chapter value)  $default,){
final _that = this;
switch (_that) {
case _Chapter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Chapter value)?  $default,){
final _that = this;
switch (_that) {
case _Chapter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String mangaId,  String chapterId,  String chapterName,  List<dynamic> chapterList)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Chapter() when $default != null:
return $default(_that.mangaId,_that.chapterId,_that.chapterName,_that.chapterList);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String mangaId,  String chapterId,  String chapterName,  List<dynamic> chapterList)  $default,) {final _that = this;
switch (_that) {
case _Chapter():
return $default(_that.mangaId,_that.chapterId,_that.chapterName,_that.chapterList);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String mangaId,  String chapterId,  String chapterName,  List<dynamic> chapterList)?  $default,) {final _that = this;
switch (_that) {
case _Chapter() when $default != null:
return $default(_that.mangaId,_that.chapterId,_that.chapterName,_that.chapterList);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Chapter implements Chapter {
  const _Chapter({required this.mangaId, required this.chapterId, required this.chapterName, required final  List<dynamic> chapterList}): _chapterList = chapterList;
  factory _Chapter.fromJson(Map<String, dynamic> json) => _$ChapterFromJson(json);

@override final  String mangaId;
@override final  String chapterId;
@override final  String chapterName;
/// Danh sách raw chapter trả về từ API (cấu trúc không đồng nhất).
 final  List<dynamic> _chapterList;
/// Danh sách raw chapter trả về từ API (cấu trúc không đồng nhất).
@override List<dynamic> get chapterList {
  if (_chapterList is EqualUnmodifiableListView) return _chapterList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chapterList);
}


/// Create a copy of Chapter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChapterCopyWith<_Chapter> get copyWith => __$ChapterCopyWithImpl<_Chapter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChapterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Chapter&&(identical(other.mangaId, mangaId) || other.mangaId == mangaId)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.chapterName, chapterName) || other.chapterName == chapterName)&&const DeepCollectionEquality().equals(other._chapterList, _chapterList));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mangaId,chapterId,chapterName,const DeepCollectionEquality().hash(_chapterList));

@override
String toString() {
  return 'Chapter(mangaId: $mangaId, chapterId: $chapterId, chapterName: $chapterName, chapterList: $chapterList)';
}


}

/// @nodoc
abstract mixin class _$ChapterCopyWith<$Res> implements $ChapterCopyWith<$Res> {
  factory _$ChapterCopyWith(_Chapter value, $Res Function(_Chapter) _then) = __$ChapterCopyWithImpl;
@override @useResult
$Res call({
 String mangaId, String chapterId, String chapterName, List<dynamic> chapterList
});




}
/// @nodoc
class __$ChapterCopyWithImpl<$Res>
    implements _$ChapterCopyWith<$Res> {
  __$ChapterCopyWithImpl(this._self, this._then);

  final _Chapter _self;
  final $Res Function(_Chapter) _then;

/// Create a copy of Chapter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mangaId = null,Object? chapterId = null,Object? chapterName = null,Object? chapterList = null,}) {
  return _then(_Chapter(
mangaId: null == mangaId ? _self.mangaId : mangaId // ignore: cast_nullable_to_non_nullable
as String,chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as String,chapterName: null == chapterName ? _self.chapterName : chapterName // ignore: cast_nullable_to_non_nullable
as String,chapterList: null == chapterList ? _self._chapterList : chapterList // ignore: cast_nullable_to_non_nullable
as List<dynamic>,
  ));
}


}

// dart format on

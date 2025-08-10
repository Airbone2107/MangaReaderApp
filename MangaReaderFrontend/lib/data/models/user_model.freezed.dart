// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

@JsonKey(name: '_id') String get id; String? get googleId; String get email; String get displayName; String? get photoURL; String get authProvider; bool get isVerified;@JsonKey(name: 'followingManga') List<String> get following;@JsonKey(name: 'readingManga') List<ReadingProgress> get readingProgress; DateTime get createdAt;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, id) || other.id == id)&&(identical(other.googleId, googleId) || other.googleId == googleId)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.photoURL, photoURL) || other.photoURL == photoURL)&&(identical(other.authProvider, authProvider) || other.authProvider == authProvider)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&const DeepCollectionEquality().equals(other.following, following)&&const DeepCollectionEquality().equals(other.readingProgress, readingProgress)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,googleId,email,displayName,photoURL,authProvider,isVerified,const DeepCollectionEquality().hash(following),const DeepCollectionEquality().hash(readingProgress),createdAt);

@override
String toString() {
  return 'User(id: $id, googleId: $googleId, email: $email, displayName: $displayName, photoURL: $photoURL, authProvider: $authProvider, isVerified: $isVerified, following: $following, readingProgress: $readingProgress, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String id, String? googleId, String email, String displayName, String? photoURL, String authProvider, bool isVerified,@JsonKey(name: 'followingManga') List<String> following,@JsonKey(name: 'readingManga') List<ReadingProgress> readingProgress, DateTime createdAt
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? googleId = freezed,Object? email = null,Object? displayName = null,Object? photoURL = freezed,Object? authProvider = null,Object? isVerified = null,Object? following = null,Object? readingProgress = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,googleId: freezed == googleId ? _self.googleId : googleId // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,photoURL: freezed == photoURL ? _self.photoURL : photoURL // ignore: cast_nullable_to_non_nullable
as String?,authProvider: null == authProvider ? _self.authProvider : authProvider // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,following: null == following ? _self.following : following // ignore: cast_nullable_to_non_nullable
as List<String>,readingProgress: null == readingProgress ? _self.readingProgress : readingProgress // ignore: cast_nullable_to_non_nullable
as List<ReadingProgress>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String? googleId,  String email,  String displayName,  String? photoURL,  String authProvider,  bool isVerified, @JsonKey(name: 'followingManga')  List<String> following, @JsonKey(name: 'readingManga')  List<ReadingProgress> readingProgress,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.googleId,_that.email,_that.displayName,_that.photoURL,_that.authProvider,_that.isVerified,_that.following,_that.readingProgress,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String? googleId,  String email,  String displayName,  String? photoURL,  String authProvider,  bool isVerified, @JsonKey(name: 'followingManga')  List<String> following, @JsonKey(name: 'readingManga')  List<ReadingProgress> readingProgress,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.googleId,_that.email,_that.displayName,_that.photoURL,_that.authProvider,_that.isVerified,_that.following,_that.readingProgress,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_id')  String id,  String? googleId,  String email,  String displayName,  String? photoURL,  String authProvider,  bool isVerified, @JsonKey(name: 'followingManga')  List<String> following, @JsonKey(name: 'readingManga')  List<ReadingProgress> readingProgress,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.googleId,_that.email,_that.displayName,_that.photoURL,_that.authProvider,_that.isVerified,_that.following,_that.readingProgress,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User implements User {
  const _User({@JsonKey(name: '_id') required this.id, this.googleId, required this.email, required this.displayName, this.photoURL, required this.authProvider, required this.isVerified, @JsonKey(name: 'followingManga') required final  List<String> following, @JsonKey(name: 'readingManga') required final  List<ReadingProgress> readingProgress, required this.createdAt}): _following = following,_readingProgress = readingProgress;
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override@JsonKey(name: '_id') final  String id;
@override final  String? googleId;
@override final  String email;
@override final  String displayName;
@override final  String? photoURL;
@override final  String authProvider;
@override final  bool isVerified;
 final  List<String> _following;
@override@JsonKey(name: 'followingManga') List<String> get following {
  if (_following is EqualUnmodifiableListView) return _following;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_following);
}

 final  List<ReadingProgress> _readingProgress;
@override@JsonKey(name: 'readingManga') List<ReadingProgress> get readingProgress {
  if (_readingProgress is EqualUnmodifiableListView) return _readingProgress;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_readingProgress);
}

@override final  DateTime createdAt;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.googleId, googleId) || other.googleId == googleId)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.photoURL, photoURL) || other.photoURL == photoURL)&&(identical(other.authProvider, authProvider) || other.authProvider == authProvider)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&const DeepCollectionEquality().equals(other._following, _following)&&const DeepCollectionEquality().equals(other._readingProgress, _readingProgress)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,googleId,email,displayName,photoURL,authProvider,isVerified,const DeepCollectionEquality().hash(_following),const DeepCollectionEquality().hash(_readingProgress),createdAt);

@override
String toString() {
  return 'User(id: $id, googleId: $googleId, email: $email, displayName: $displayName, photoURL: $photoURL, authProvider: $authProvider, isVerified: $isVerified, following: $following, readingProgress: $readingProgress, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String id, String? googleId, String email, String displayName, String? photoURL, String authProvider, bool isVerified,@JsonKey(name: 'followingManga') List<String> following,@JsonKey(name: 'readingManga') List<ReadingProgress> readingProgress, DateTime createdAt
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? googleId = freezed,Object? email = null,Object? displayName = null,Object? photoURL = freezed,Object? authProvider = null,Object? isVerified = null,Object? following = null,Object? readingProgress = null,Object? createdAt = null,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,googleId: freezed == googleId ? _self.googleId : googleId // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,photoURL: freezed == photoURL ? _self.photoURL : photoURL // ignore: cast_nullable_to_non_nullable
as String?,authProvider: null == authProvider ? _self.authProvider : authProvider // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,following: null == following ? _self._following : following // ignore: cast_nullable_to_non_nullable
as List<String>,readingProgress: null == readingProgress ? _self._readingProgress : readingProgress // ignore: cast_nullable_to_non_nullable
as List<ReadingProgress>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ReadingProgress {

 String get mangaId; ChapterInfo get lastReadChapter; DateTime get lastReadAt;@JsonKey(name: '_id') String? get id;
/// Create a copy of ReadingProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReadingProgressCopyWith<ReadingProgress> get copyWith => _$ReadingProgressCopyWithImpl<ReadingProgress>(this as ReadingProgress, _$identity);

  /// Serializes this ReadingProgress to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReadingProgress&&(identical(other.mangaId, mangaId) || other.mangaId == mangaId)&&(identical(other.lastReadChapter, lastReadChapter) || other.lastReadChapter == lastReadChapter)&&(identical(other.lastReadAt, lastReadAt) || other.lastReadAt == lastReadAt)&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mangaId,lastReadChapter,lastReadAt,id);

@override
String toString() {
  return 'ReadingProgress(mangaId: $mangaId, lastReadChapter: $lastReadChapter, lastReadAt: $lastReadAt, id: $id)';
}


}

/// @nodoc
abstract mixin class $ReadingProgressCopyWith<$Res>  {
  factory $ReadingProgressCopyWith(ReadingProgress value, $Res Function(ReadingProgress) _then) = _$ReadingProgressCopyWithImpl;
@useResult
$Res call({
 String mangaId, ChapterInfo lastReadChapter, DateTime lastReadAt,@JsonKey(name: '_id') String? id
});


$ChapterInfoCopyWith<$Res> get lastReadChapter;

}
/// @nodoc
class _$ReadingProgressCopyWithImpl<$Res>
    implements $ReadingProgressCopyWith<$Res> {
  _$ReadingProgressCopyWithImpl(this._self, this._then);

  final ReadingProgress _self;
  final $Res Function(ReadingProgress) _then;

/// Create a copy of ReadingProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mangaId = null,Object? lastReadChapter = null,Object? lastReadAt = null,Object? id = freezed,}) {
  return _then(_self.copyWith(
mangaId: null == mangaId ? _self.mangaId : mangaId // ignore: cast_nullable_to_non_nullable
as String,lastReadChapter: null == lastReadChapter ? _self.lastReadChapter : lastReadChapter // ignore: cast_nullable_to_non_nullable
as ChapterInfo,lastReadAt: null == lastReadAt ? _self.lastReadAt : lastReadAt // ignore: cast_nullable_to_non_nullable
as DateTime,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ReadingProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChapterInfoCopyWith<$Res> get lastReadChapter {
  
  return $ChapterInfoCopyWith<$Res>(_self.lastReadChapter, (value) {
    return _then(_self.copyWith(lastReadChapter: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReadingProgress].
extension ReadingProgressPatterns on ReadingProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReadingProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReadingProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReadingProgress value)  $default,){
final _that = this;
switch (_that) {
case _ReadingProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReadingProgress value)?  $default,){
final _that = this;
switch (_that) {
case _ReadingProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String mangaId,  ChapterInfo lastReadChapter,  DateTime lastReadAt, @JsonKey(name: '_id')  String? id)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReadingProgress() when $default != null:
return $default(_that.mangaId,_that.lastReadChapter,_that.lastReadAt,_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String mangaId,  ChapterInfo lastReadChapter,  DateTime lastReadAt, @JsonKey(name: '_id')  String? id)  $default,) {final _that = this;
switch (_that) {
case _ReadingProgress():
return $default(_that.mangaId,_that.lastReadChapter,_that.lastReadAt,_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String mangaId,  ChapterInfo lastReadChapter,  DateTime lastReadAt, @JsonKey(name: '_id')  String? id)?  $default,) {final _that = this;
switch (_that) {
case _ReadingProgress() when $default != null:
return $default(_that.mangaId,_that.lastReadChapter,_that.lastReadAt,_that.id);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReadingProgress implements ReadingProgress {
  const _ReadingProgress({required this.mangaId, required this.lastReadChapter, required this.lastReadAt, @JsonKey(name: '_id') this.id});
  factory _ReadingProgress.fromJson(Map<String, dynamic> json) => _$ReadingProgressFromJson(json);

@override final  String mangaId;
@override final  ChapterInfo lastReadChapter;
@override final  DateTime lastReadAt;
@override@JsonKey(name: '_id') final  String? id;

/// Create a copy of ReadingProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReadingProgressCopyWith<_ReadingProgress> get copyWith => __$ReadingProgressCopyWithImpl<_ReadingProgress>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReadingProgressToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReadingProgress&&(identical(other.mangaId, mangaId) || other.mangaId == mangaId)&&(identical(other.lastReadChapter, lastReadChapter) || other.lastReadChapter == lastReadChapter)&&(identical(other.lastReadAt, lastReadAt) || other.lastReadAt == lastReadAt)&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mangaId,lastReadChapter,lastReadAt,id);

@override
String toString() {
  return 'ReadingProgress(mangaId: $mangaId, lastReadChapter: $lastReadChapter, lastReadAt: $lastReadAt, id: $id)';
}


}

/// @nodoc
abstract mixin class _$ReadingProgressCopyWith<$Res> implements $ReadingProgressCopyWith<$Res> {
  factory _$ReadingProgressCopyWith(_ReadingProgress value, $Res Function(_ReadingProgress) _then) = __$ReadingProgressCopyWithImpl;
@override @useResult
$Res call({
 String mangaId, ChapterInfo lastReadChapter, DateTime lastReadAt,@JsonKey(name: '_id') String? id
});


@override $ChapterInfoCopyWith<$Res> get lastReadChapter;

}
/// @nodoc
class __$ReadingProgressCopyWithImpl<$Res>
    implements _$ReadingProgressCopyWith<$Res> {
  __$ReadingProgressCopyWithImpl(this._self, this._then);

  final _ReadingProgress _self;
  final $Res Function(_ReadingProgress) _then;

/// Create a copy of ReadingProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mangaId = null,Object? lastReadChapter = null,Object? lastReadAt = null,Object? id = freezed,}) {
  return _then(_ReadingProgress(
mangaId: null == mangaId ? _self.mangaId : mangaId // ignore: cast_nullable_to_non_nullable
as String,lastReadChapter: null == lastReadChapter ? _self.lastReadChapter : lastReadChapter // ignore: cast_nullable_to_non_nullable
as ChapterInfo,lastReadAt: null == lastReadAt ? _self.lastReadAt : lastReadAt // ignore: cast_nullable_to_non_nullable
as DateTime,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ReadingProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChapterInfoCopyWith<$Res> get lastReadChapter {
  
  return $ChapterInfoCopyWith<$Res>(_self.lastReadChapter, (value) {
    return _then(_self.copyWith(lastReadChapter: value));
  });
}
}


/// @nodoc
mixin _$ChapterInfo {

 String get id; String? get chapter; String? get title; String get translatedLanguage;
/// Create a copy of ChapterInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterInfoCopyWith<ChapterInfo> get copyWith => _$ChapterInfoCopyWithImpl<ChapterInfo>(this as ChapterInfo, _$identity);

  /// Serializes this ChapterInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChapterInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.chapter, chapter) || other.chapter == chapter)&&(identical(other.title, title) || other.title == title)&&(identical(other.translatedLanguage, translatedLanguage) || other.translatedLanguage == translatedLanguage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,chapter,title,translatedLanguage);

@override
String toString() {
  return 'ChapterInfo(id: $id, chapter: $chapter, title: $title, translatedLanguage: $translatedLanguage)';
}


}

/// @nodoc
abstract mixin class $ChapterInfoCopyWith<$Res>  {
  factory $ChapterInfoCopyWith(ChapterInfo value, $Res Function(ChapterInfo) _then) = _$ChapterInfoCopyWithImpl;
@useResult
$Res call({
 String id, String? chapter, String? title, String translatedLanguage
});




}
/// @nodoc
class _$ChapterInfoCopyWithImpl<$Res>
    implements $ChapterInfoCopyWith<$Res> {
  _$ChapterInfoCopyWithImpl(this._self, this._then);

  final ChapterInfo _self;
  final $Res Function(ChapterInfo) _then;

/// Create a copy of ChapterInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? chapter = freezed,Object? title = freezed,Object? translatedLanguage = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,chapter: freezed == chapter ? _self.chapter : chapter // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,translatedLanguage: null == translatedLanguage ? _self.translatedLanguage : translatedLanguage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChapterInfo].
extension ChapterInfoPatterns on ChapterInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChapterInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChapterInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChapterInfo value)  $default,){
final _that = this;
switch (_that) {
case _ChapterInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChapterInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ChapterInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? chapter,  String? title,  String translatedLanguage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChapterInfo() when $default != null:
return $default(_that.id,_that.chapter,_that.title,_that.translatedLanguage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? chapter,  String? title,  String translatedLanguage)  $default,) {final _that = this;
switch (_that) {
case _ChapterInfo():
return $default(_that.id,_that.chapter,_that.title,_that.translatedLanguage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? chapter,  String? title,  String translatedLanguage)?  $default,) {final _that = this;
switch (_that) {
case _ChapterInfo() when $default != null:
return $default(_that.id,_that.chapter,_that.title,_that.translatedLanguage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChapterInfo implements ChapterInfo {
  const _ChapterInfo({required this.id, this.chapter, this.title, required this.translatedLanguage});
  factory _ChapterInfo.fromJson(Map<String, dynamic> json) => _$ChapterInfoFromJson(json);

@override final  String id;
@override final  String? chapter;
@override final  String? title;
@override final  String translatedLanguage;

/// Create a copy of ChapterInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChapterInfoCopyWith<_ChapterInfo> get copyWith => __$ChapterInfoCopyWithImpl<_ChapterInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChapterInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChapterInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.chapter, chapter) || other.chapter == chapter)&&(identical(other.title, title) || other.title == title)&&(identical(other.translatedLanguage, translatedLanguage) || other.translatedLanguage == translatedLanguage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,chapter,title,translatedLanguage);

@override
String toString() {
  return 'ChapterInfo(id: $id, chapter: $chapter, title: $title, translatedLanguage: $translatedLanguage)';
}


}

/// @nodoc
abstract mixin class _$ChapterInfoCopyWith<$Res> implements $ChapterInfoCopyWith<$Res> {
  factory _$ChapterInfoCopyWith(_ChapterInfo value, $Res Function(_ChapterInfo) _then) = __$ChapterInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String? chapter, String? title, String translatedLanguage
});




}
/// @nodoc
class __$ChapterInfoCopyWithImpl<$Res>
    implements _$ChapterInfoCopyWith<$Res> {
  __$ChapterInfoCopyWithImpl(this._self, this._then);

  final _ChapterInfo _self;
  final $Res Function(_ChapterInfo) _then;

/// Create a copy of ChapterInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? chapter = freezed,Object? title = freezed,Object? translatedLanguage = null,}) {
  return _then(_ChapterInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,chapter: freezed == chapter ? _self.chapter : chapter // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,translatedLanguage: null == translatedLanguage ? _self.translatedLanguage : translatedLanguage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

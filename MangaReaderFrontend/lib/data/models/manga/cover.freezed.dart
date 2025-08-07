// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cover.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Cover {

 String get id; String get type; CoverAttributes get attributes;
/// Create a copy of Cover
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoverCopyWith<Cover> get copyWith => _$CoverCopyWithImpl<Cover>(this as Cover, _$identity);

  /// Serializes this Cover to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Cover&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.attributes, attributes) || other.attributes == attributes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,attributes);

@override
String toString() {
  return 'Cover(id: $id, type: $type, attributes: $attributes)';
}


}

/// @nodoc
abstract mixin class $CoverCopyWith<$Res>  {
  factory $CoverCopyWith(Cover value, $Res Function(Cover) _then) = _$CoverCopyWithImpl;
@useResult
$Res call({
 String id, String type, CoverAttributes attributes
});


$CoverAttributesCopyWith<$Res> get attributes;

}
/// @nodoc
class _$CoverCopyWithImpl<$Res>
    implements $CoverCopyWith<$Res> {
  _$CoverCopyWithImpl(this._self, this._then);

  final Cover _self;
  final $Res Function(Cover) _then;

/// Create a copy of Cover
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? attributes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,attributes: null == attributes ? _self.attributes : attributes // ignore: cast_nullable_to_non_nullable
as CoverAttributes,
  ));
}
/// Create a copy of Cover
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoverAttributesCopyWith<$Res> get attributes {
  
  return $CoverAttributesCopyWith<$Res>(_self.attributes, (value) {
    return _then(_self.copyWith(attributes: value));
  });
}
}


/// Adds pattern-matching-related methods to [Cover].
extension CoverPatterns on Cover {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Cover value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Cover() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Cover value)  $default,){
final _that = this;
switch (_that) {
case _Cover():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Cover value)?  $default,){
final _that = this;
switch (_that) {
case _Cover() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  CoverAttributes attributes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Cover() when $default != null:
return $default(_that.id,_that.type,_that.attributes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  CoverAttributes attributes)  $default,) {final _that = this;
switch (_that) {
case _Cover():
return $default(_that.id,_that.type,_that.attributes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  CoverAttributes attributes)?  $default,) {final _that = this;
switch (_that) {
case _Cover() when $default != null:
return $default(_that.id,_that.type,_that.attributes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Cover implements Cover {
  const _Cover({required this.id, required this.type, required this.attributes});
  factory _Cover.fromJson(Map<String, dynamic> json) => _$CoverFromJson(json);

@override final  String id;
@override final  String type;
@override final  CoverAttributes attributes;

/// Create a copy of Cover
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoverCopyWith<_Cover> get copyWith => __$CoverCopyWithImpl<_Cover>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoverToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Cover&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.attributes, attributes) || other.attributes == attributes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,attributes);

@override
String toString() {
  return 'Cover(id: $id, type: $type, attributes: $attributes)';
}


}

/// @nodoc
abstract mixin class _$CoverCopyWith<$Res> implements $CoverCopyWith<$Res> {
  factory _$CoverCopyWith(_Cover value, $Res Function(_Cover) _then) = __$CoverCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, CoverAttributes attributes
});


@override $CoverAttributesCopyWith<$Res> get attributes;

}
/// @nodoc
class __$CoverCopyWithImpl<$Res>
    implements _$CoverCopyWith<$Res> {
  __$CoverCopyWithImpl(this._self, this._then);

  final _Cover _self;
  final $Res Function(_Cover) _then;

/// Create a copy of Cover
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? attributes = null,}) {
  return _then(_Cover(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,attributes: null == attributes ? _self.attributes : attributes // ignore: cast_nullable_to_non_nullable
as CoverAttributes,
  ));
}

/// Create a copy of Cover
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoverAttributesCopyWith<$Res> get attributes {
  
  return $CoverAttributesCopyWith<$Res>(_self.attributes, (value) {
    return _then(_self.copyWith(attributes: value));
  });
}
}


/// @nodoc
mixin _$CoverAttributes {

 String get fileName; String? get description; String? get volume; String? get locale; int get version; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of CoverAttributes
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoverAttributesCopyWith<CoverAttributes> get copyWith => _$CoverAttributesCopyWithImpl<CoverAttributes>(this as CoverAttributes, _$identity);

  /// Serializes this CoverAttributes to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoverAttributes&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.description, description) || other.description == description)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.version, version) || other.version == version)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileName,description,volume,locale,version,createdAt,updatedAt);

@override
String toString() {
  return 'CoverAttributes(fileName: $fileName, description: $description, volume: $volume, locale: $locale, version: $version, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CoverAttributesCopyWith<$Res>  {
  factory $CoverAttributesCopyWith(CoverAttributes value, $Res Function(CoverAttributes) _then) = _$CoverAttributesCopyWithImpl;
@useResult
$Res call({
 String fileName, String? description, String? volume, String? locale, int version, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$CoverAttributesCopyWithImpl<$Res>
    implements $CoverAttributesCopyWith<$Res> {
  _$CoverAttributesCopyWithImpl(this._self, this._then);

  final CoverAttributes _self;
  final $Res Function(CoverAttributes) _then;

/// Create a copy of CoverAttributes
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileName = null,Object? description = freezed,Object? volume = freezed,Object? locale = freezed,Object? version = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,volume: freezed == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as String?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CoverAttributes].
extension CoverAttributesPatterns on CoverAttributes {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoverAttributes value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoverAttributes() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoverAttributes value)  $default,){
final _that = this;
switch (_that) {
case _CoverAttributes():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoverAttributes value)?  $default,){
final _that = this;
switch (_that) {
case _CoverAttributes() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileName,  String? description,  String? volume,  String? locale,  int version,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoverAttributes() when $default != null:
return $default(_that.fileName,_that.description,_that.volume,_that.locale,_that.version,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileName,  String? description,  String? volume,  String? locale,  int version,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CoverAttributes():
return $default(_that.fileName,_that.description,_that.volume,_that.locale,_that.version,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileName,  String? description,  String? volume,  String? locale,  int version,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CoverAttributes() when $default != null:
return $default(_that.fileName,_that.description,_that.volume,_that.locale,_that.version,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CoverAttributes implements CoverAttributes {
  const _CoverAttributes({required this.fileName, this.description, this.volume, this.locale, required this.version, required this.createdAt, required this.updatedAt});
  factory _CoverAttributes.fromJson(Map<String, dynamic> json) => _$CoverAttributesFromJson(json);

@override final  String fileName;
@override final  String? description;
@override final  String? volume;
@override final  String? locale;
@override final  int version;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of CoverAttributes
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoverAttributesCopyWith<_CoverAttributes> get copyWith => __$CoverAttributesCopyWithImpl<_CoverAttributes>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoverAttributesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoverAttributes&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.description, description) || other.description == description)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.version, version) || other.version == version)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileName,description,volume,locale,version,createdAt,updatedAt);

@override
String toString() {
  return 'CoverAttributes(fileName: $fileName, description: $description, volume: $volume, locale: $locale, version: $version, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CoverAttributesCopyWith<$Res> implements $CoverAttributesCopyWith<$Res> {
  factory _$CoverAttributesCopyWith(_CoverAttributes value, $Res Function(_CoverAttributes) _then) = __$CoverAttributesCopyWithImpl;
@override @useResult
$Res call({
 String fileName, String? description, String? volume, String? locale, int version, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$CoverAttributesCopyWithImpl<$Res>
    implements _$CoverAttributesCopyWith<$Res> {
  __$CoverAttributesCopyWithImpl(this._self, this._then);

  final _CoverAttributes _self;
  final $Res Function(_CoverAttributes) _then;

/// Create a copy of CoverAttributes
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileName = null,Object? description = freezed,Object? volume = freezed,Object? locale = freezed,Object? version = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_CoverAttributes(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,volume: freezed == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as String?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

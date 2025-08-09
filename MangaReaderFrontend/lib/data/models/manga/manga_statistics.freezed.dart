// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manga_statistics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MangaStatisticsResponse {

 String get result; Map<String, MangaStatisticsData> get statistics;
/// Create a copy of MangaStatisticsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MangaStatisticsResponseCopyWith<MangaStatisticsResponse> get copyWith => _$MangaStatisticsResponseCopyWithImpl<MangaStatisticsResponse>(this as MangaStatisticsResponse, _$identity);

  /// Serializes this MangaStatisticsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MangaStatisticsResponse&&(identical(other.result, result) || other.result == result)&&const DeepCollectionEquality().equals(other.statistics, statistics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,result,const DeepCollectionEquality().hash(statistics));

@override
String toString() {
  return 'MangaStatisticsResponse(result: $result, statistics: $statistics)';
}


}

/// @nodoc
abstract mixin class $MangaStatisticsResponseCopyWith<$Res>  {
  factory $MangaStatisticsResponseCopyWith(MangaStatisticsResponse value, $Res Function(MangaStatisticsResponse) _then) = _$MangaStatisticsResponseCopyWithImpl;
@useResult
$Res call({
 String result, Map<String, MangaStatisticsData> statistics
});




}
/// @nodoc
class _$MangaStatisticsResponseCopyWithImpl<$Res>
    implements $MangaStatisticsResponseCopyWith<$Res> {
  _$MangaStatisticsResponseCopyWithImpl(this._self, this._then);

  final MangaStatisticsResponse _self;
  final $Res Function(MangaStatisticsResponse) _then;

/// Create a copy of MangaStatisticsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? result = null,Object? statistics = null,}) {
  return _then(_self.copyWith(
result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as String,statistics: null == statistics ? _self.statistics : statistics // ignore: cast_nullable_to_non_nullable
as Map<String, MangaStatisticsData>,
  ));
}

}


/// Adds pattern-matching-related methods to [MangaStatisticsResponse].
extension MangaStatisticsResponsePatterns on MangaStatisticsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MangaStatisticsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MangaStatisticsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MangaStatisticsResponse value)  $default,){
final _that = this;
switch (_that) {
case _MangaStatisticsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MangaStatisticsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MangaStatisticsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String result,  Map<String, MangaStatisticsData> statistics)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MangaStatisticsResponse() when $default != null:
return $default(_that.result,_that.statistics);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String result,  Map<String, MangaStatisticsData> statistics)  $default,) {final _that = this;
switch (_that) {
case _MangaStatisticsResponse():
return $default(_that.result,_that.statistics);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String result,  Map<String, MangaStatisticsData> statistics)?  $default,) {final _that = this;
switch (_that) {
case _MangaStatisticsResponse() when $default != null:
return $default(_that.result,_that.statistics);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MangaStatisticsResponse implements MangaStatisticsResponse {
  const _MangaStatisticsResponse({required this.result, required final  Map<String, MangaStatisticsData> statistics}): _statistics = statistics;
  factory _MangaStatisticsResponse.fromJson(Map<String, dynamic> json) => _$MangaStatisticsResponseFromJson(json);

@override final  String result;
 final  Map<String, MangaStatisticsData> _statistics;
@override Map<String, MangaStatisticsData> get statistics {
  if (_statistics is EqualUnmodifiableMapView) return _statistics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_statistics);
}


/// Create a copy of MangaStatisticsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MangaStatisticsResponseCopyWith<_MangaStatisticsResponse> get copyWith => __$MangaStatisticsResponseCopyWithImpl<_MangaStatisticsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MangaStatisticsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MangaStatisticsResponse&&(identical(other.result, result) || other.result == result)&&const DeepCollectionEquality().equals(other._statistics, _statistics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,result,const DeepCollectionEquality().hash(_statistics));

@override
String toString() {
  return 'MangaStatisticsResponse(result: $result, statistics: $statistics)';
}


}

/// @nodoc
abstract mixin class _$MangaStatisticsResponseCopyWith<$Res> implements $MangaStatisticsResponseCopyWith<$Res> {
  factory _$MangaStatisticsResponseCopyWith(_MangaStatisticsResponse value, $Res Function(_MangaStatisticsResponse) _then) = __$MangaStatisticsResponseCopyWithImpl;
@override @useResult
$Res call({
 String result, Map<String, MangaStatisticsData> statistics
});




}
/// @nodoc
class __$MangaStatisticsResponseCopyWithImpl<$Res>
    implements _$MangaStatisticsResponseCopyWith<$Res> {
  __$MangaStatisticsResponseCopyWithImpl(this._self, this._then);

  final _MangaStatisticsResponse _self;
  final $Res Function(_MangaStatisticsResponse) _then;

/// Create a copy of MangaStatisticsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? result = null,Object? statistics = null,}) {
  return _then(_MangaStatisticsResponse(
result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as String,statistics: null == statistics ? _self._statistics : statistics // ignore: cast_nullable_to_non_nullable
as Map<String, MangaStatisticsData>,
  ));
}


}


/// @nodoc
mixin _$MangaStatisticsData {

 Rating get rating; int get follows;
/// Create a copy of MangaStatisticsData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MangaStatisticsDataCopyWith<MangaStatisticsData> get copyWith => _$MangaStatisticsDataCopyWithImpl<MangaStatisticsData>(this as MangaStatisticsData, _$identity);

  /// Serializes this MangaStatisticsData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MangaStatisticsData&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.follows, follows) || other.follows == follows));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rating,follows);

@override
String toString() {
  return 'MangaStatisticsData(rating: $rating, follows: $follows)';
}


}

/// @nodoc
abstract mixin class $MangaStatisticsDataCopyWith<$Res>  {
  factory $MangaStatisticsDataCopyWith(MangaStatisticsData value, $Res Function(MangaStatisticsData) _then) = _$MangaStatisticsDataCopyWithImpl;
@useResult
$Res call({
 Rating rating, int follows
});


$RatingCopyWith<$Res> get rating;

}
/// @nodoc
class _$MangaStatisticsDataCopyWithImpl<$Res>
    implements $MangaStatisticsDataCopyWith<$Res> {
  _$MangaStatisticsDataCopyWithImpl(this._self, this._then);

  final MangaStatisticsData _self;
  final $Res Function(MangaStatisticsData) _then;

/// Create a copy of MangaStatisticsData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rating = null,Object? follows = null,}) {
  return _then(_self.copyWith(
rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as Rating,follows: null == follows ? _self.follows : follows // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of MangaStatisticsData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RatingCopyWith<$Res> get rating {
  
  return $RatingCopyWith<$Res>(_self.rating, (value) {
    return _then(_self.copyWith(rating: value));
  });
}
}


/// Adds pattern-matching-related methods to [MangaStatisticsData].
extension MangaStatisticsDataPatterns on MangaStatisticsData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MangaStatisticsData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MangaStatisticsData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MangaStatisticsData value)  $default,){
final _that = this;
switch (_that) {
case _MangaStatisticsData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MangaStatisticsData value)?  $default,){
final _that = this;
switch (_that) {
case _MangaStatisticsData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Rating rating,  int follows)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MangaStatisticsData() when $default != null:
return $default(_that.rating,_that.follows);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Rating rating,  int follows)  $default,) {final _that = this;
switch (_that) {
case _MangaStatisticsData():
return $default(_that.rating,_that.follows);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Rating rating,  int follows)?  $default,) {final _that = this;
switch (_that) {
case _MangaStatisticsData() when $default != null:
return $default(_that.rating,_that.follows);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MangaStatisticsData implements MangaStatisticsData {
  const _MangaStatisticsData({required this.rating, required this.follows});
  factory _MangaStatisticsData.fromJson(Map<String, dynamic> json) => _$MangaStatisticsDataFromJson(json);

@override final  Rating rating;
@override final  int follows;

/// Create a copy of MangaStatisticsData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MangaStatisticsDataCopyWith<_MangaStatisticsData> get copyWith => __$MangaStatisticsDataCopyWithImpl<_MangaStatisticsData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MangaStatisticsDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MangaStatisticsData&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.follows, follows) || other.follows == follows));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rating,follows);

@override
String toString() {
  return 'MangaStatisticsData(rating: $rating, follows: $follows)';
}


}

/// @nodoc
abstract mixin class _$MangaStatisticsDataCopyWith<$Res> implements $MangaStatisticsDataCopyWith<$Res> {
  factory _$MangaStatisticsDataCopyWith(_MangaStatisticsData value, $Res Function(_MangaStatisticsData) _then) = __$MangaStatisticsDataCopyWithImpl;
@override @useResult
$Res call({
 Rating rating, int follows
});


@override $RatingCopyWith<$Res> get rating;

}
/// @nodoc
class __$MangaStatisticsDataCopyWithImpl<$Res>
    implements _$MangaStatisticsDataCopyWith<$Res> {
  __$MangaStatisticsDataCopyWithImpl(this._self, this._then);

  final _MangaStatisticsData _self;
  final $Res Function(_MangaStatisticsData) _then;

/// Create a copy of MangaStatisticsData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rating = null,Object? follows = null,}) {
  return _then(_MangaStatisticsData(
rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as Rating,follows: null == follows ? _self.follows : follows // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of MangaStatisticsData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RatingCopyWith<$Res> get rating {
  
  return $RatingCopyWith<$Res>(_self.rating, (value) {
    return _then(_self.copyWith(rating: value));
  });
}
}


/// @nodoc
mixin _$Rating {

 double? get average; double get bayesian;
/// Create a copy of Rating
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RatingCopyWith<Rating> get copyWith => _$RatingCopyWithImpl<Rating>(this as Rating, _$identity);

  /// Serializes this Rating to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Rating&&(identical(other.average, average) || other.average == average)&&(identical(other.bayesian, bayesian) || other.bayesian == bayesian));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,average,bayesian);

@override
String toString() {
  return 'Rating(average: $average, bayesian: $bayesian)';
}


}

/// @nodoc
abstract mixin class $RatingCopyWith<$Res>  {
  factory $RatingCopyWith(Rating value, $Res Function(Rating) _then) = _$RatingCopyWithImpl;
@useResult
$Res call({
 double? average, double bayesian
});




}
/// @nodoc
class _$RatingCopyWithImpl<$Res>
    implements $RatingCopyWith<$Res> {
  _$RatingCopyWithImpl(this._self, this._then);

  final Rating _self;
  final $Res Function(Rating) _then;

/// Create a copy of Rating
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? average = freezed,Object? bayesian = null,}) {
  return _then(_self.copyWith(
average: freezed == average ? _self.average : average // ignore: cast_nullable_to_non_nullable
as double?,bayesian: null == bayesian ? _self.bayesian : bayesian // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [Rating].
extension RatingPatterns on Rating {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Rating value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Rating() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Rating value)  $default,){
final _that = this;
switch (_that) {
case _Rating():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Rating value)?  $default,){
final _that = this;
switch (_that) {
case _Rating() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? average,  double bayesian)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Rating() when $default != null:
return $default(_that.average,_that.bayesian);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? average,  double bayesian)  $default,) {final _that = this;
switch (_that) {
case _Rating():
return $default(_that.average,_that.bayesian);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? average,  double bayesian)?  $default,) {final _that = this;
switch (_that) {
case _Rating() when $default != null:
return $default(_that.average,_that.bayesian);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Rating implements Rating {
  const _Rating({this.average, required this.bayesian});
  factory _Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);

@override final  double? average;
@override final  double bayesian;

/// Create a copy of Rating
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RatingCopyWith<_Rating> get copyWith => __$RatingCopyWithImpl<_Rating>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RatingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Rating&&(identical(other.average, average) || other.average == average)&&(identical(other.bayesian, bayesian) || other.bayesian == bayesian));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,average,bayesian);

@override
String toString() {
  return 'Rating(average: $average, bayesian: $bayesian)';
}


}

/// @nodoc
abstract mixin class _$RatingCopyWith<$Res> implements $RatingCopyWith<$Res> {
  factory _$RatingCopyWith(_Rating value, $Res Function(_Rating) _then) = __$RatingCopyWithImpl;
@override @useResult
$Res call({
 double? average, double bayesian
});




}
/// @nodoc
class __$RatingCopyWithImpl<$Res>
    implements _$RatingCopyWith<$Res> {
  __$RatingCopyWithImpl(this._self, this._then);

  final _Rating _self;
  final $Res Function(_Rating) _then;

/// Create a copy of Rating
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? average = freezed,Object? bayesian = null,}) {
  return _then(_Rating(
average: freezed == average ? _self.average : average // ignore: cast_nullable_to_non_nullable
as double?,bayesian: null == bayesian ? _self.bayesian : bayesian // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on

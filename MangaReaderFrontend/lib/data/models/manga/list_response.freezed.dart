// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ListResponse<T> {

 String get result; String get response; List<T> get data; int get limit; int get offset; int get total;
/// Create a copy of ListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListResponseCopyWith<T, ListResponse<T>> get copyWith => _$ListResponseCopyWithImpl<T, ListResponse<T>>(this as ListResponse<T>, _$identity);

  /// Serializes this ListResponse to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT);


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListResponse<T>&&(identical(other.result, result) || other.result == result)&&(identical(other.response, response) || other.response == response)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,result,response,const DeepCollectionEquality().hash(data),limit,offset,total);

@override
String toString() {
  return 'ListResponse<$T>(result: $result, response: $response, data: $data, limit: $limit, offset: $offset, total: $total)';
}


}

/// @nodoc
abstract mixin class $ListResponseCopyWith<T,$Res>  {
  factory $ListResponseCopyWith(ListResponse<T> value, $Res Function(ListResponse<T>) _then) = _$ListResponseCopyWithImpl;
@useResult
$Res call({
 String result, String response, List<T> data, int limit, int offset, int total
});




}
/// @nodoc
class _$ListResponseCopyWithImpl<T,$Res>
    implements $ListResponseCopyWith<T, $Res> {
  _$ListResponseCopyWithImpl(this._self, this._then);

  final ListResponse<T> _self;
  final $Res Function(ListResponse<T>) _then;

/// Create a copy of ListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? result = null,Object? response = null,Object? data = null,Object? limit = null,Object? offset = null,Object? total = null,}) {
  return _then(_self.copyWith(
result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as String,response: null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<T>,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ListResponse].
extension ListResponsePatterns<T> on ListResponse<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListResponse<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListResponse<T> value)  $default,){
final _that = this;
switch (_that) {
case _ListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListResponse<T> value)?  $default,){
final _that = this;
switch (_that) {
case _ListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String result,  String response,  List<T> data,  int limit,  int offset,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListResponse() when $default != null:
return $default(_that.result,_that.response,_that.data,_that.limit,_that.offset,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String result,  String response,  List<T> data,  int limit,  int offset,  int total)  $default,) {final _that = this;
switch (_that) {
case _ListResponse():
return $default(_that.result,_that.response,_that.data,_that.limit,_that.offset,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String result,  String response,  List<T> data,  int limit,  int offset,  int total)?  $default,) {final _that = this;
switch (_that) {
case _ListResponse() when $default != null:
return $default(_that.result,_that.response,_that.data,_that.limit,_that.offset,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)

class _ListResponse<T> implements ListResponse<T> {
  const _ListResponse({required this.result, required this.response, required final  List<T> data, required this.limit, required this.offset, required this.total}): _data = data;
  factory _ListResponse.fromJson(Map<String, dynamic> json,T Function(Object?) fromJsonT) => _$ListResponseFromJson(json,fromJsonT);

@override final  String result;
@override final  String response;
 final  List<T> _data;
@override List<T> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override final  int limit;
@override final  int offset;
@override final  int total;

/// Create a copy of ListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListResponseCopyWith<T, _ListResponse<T>> get copyWith => __$ListResponseCopyWithImpl<T, _ListResponse<T>>(this, _$identity);

@override
Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
  return _$ListResponseToJson<T>(this, toJsonT);
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListResponse<T>&&(identical(other.result, result) || other.result == result)&&(identical(other.response, response) || other.response == response)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,result,response,const DeepCollectionEquality().hash(_data),limit,offset,total);

@override
String toString() {
  return 'ListResponse<$T>(result: $result, response: $response, data: $data, limit: $limit, offset: $offset, total: $total)';
}


}

/// @nodoc
abstract mixin class _$ListResponseCopyWith<T,$Res> implements $ListResponseCopyWith<T, $Res> {
  factory _$ListResponseCopyWith(_ListResponse<T> value, $Res Function(_ListResponse<T>) _then) = __$ListResponseCopyWithImpl;
@override @useResult
$Res call({
 String result, String response, List<T> data, int limit, int offset, int total
});




}
/// @nodoc
class __$ListResponseCopyWithImpl<T,$Res>
    implements _$ListResponseCopyWith<T, $Res> {
  __$ListResponseCopyWithImpl(this._self, this._then);

  final _ListResponse<T> _self;
  final $Res Function(_ListResponse<T>) _then;

/// Create a copy of ListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? result = null,Object? response = null,Object? data = null,Object? limit = null,Object? offset = null,Object? total = null,}) {
  return _then(_ListResponse<T>(
result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as String,response: null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<T>,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

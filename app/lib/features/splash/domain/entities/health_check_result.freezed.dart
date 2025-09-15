// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_check_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HealthCheckResult {

 bool get ok; String? get message;
/// Create a copy of HealthCheckResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthCheckResultCopyWith<HealthCheckResult> get copyWith => _$HealthCheckResultCopyWithImpl<HealthCheckResult>(this as HealthCheckResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthCheckResult&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,ok,message);

@override
String toString() {
  return 'HealthCheckResult(ok: $ok, message: $message)';
}


}

/// @nodoc
abstract mixin class $HealthCheckResultCopyWith<$Res>  {
  factory $HealthCheckResultCopyWith(HealthCheckResult value, $Res Function(HealthCheckResult) _then) = _$HealthCheckResultCopyWithImpl;
@useResult
$Res call({
 bool ok, String? message
});




}
/// @nodoc
class _$HealthCheckResultCopyWithImpl<$Res>
    implements $HealthCheckResultCopyWith<$Res> {
  _$HealthCheckResultCopyWithImpl(this._self, this._then);

  final HealthCheckResult _self;
  final $Res Function(HealthCheckResult) _then;

/// Create a copy of HealthCheckResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? message = freezed,}) {
  return _then(_self.copyWith(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthCheckResult].
extension HealthCheckResultPatterns on HealthCheckResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthCheckResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthCheckResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthCheckResult value)  $default,){
final _that = this;
switch (_that) {
case _HealthCheckResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthCheckResult value)?  $default,){
final _that = this;
switch (_that) {
case _HealthCheckResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthCheckResult() when $default != null:
return $default(_that.ok,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  String? message)  $default,) {final _that = this;
switch (_that) {
case _HealthCheckResult():
return $default(_that.ok,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _HealthCheckResult() when $default != null:
return $default(_that.ok,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _HealthCheckResult implements HealthCheckResult {
  const _HealthCheckResult({required this.ok, this.message});
  

@override final  bool ok;
@override final  String? message;

/// Create a copy of HealthCheckResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthCheckResultCopyWith<_HealthCheckResult> get copyWith => __$HealthCheckResultCopyWithImpl<_HealthCheckResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthCheckResult&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,ok,message);

@override
String toString() {
  return 'HealthCheckResult(ok: $ok, message: $message)';
}


}

/// @nodoc
abstract mixin class _$HealthCheckResultCopyWith<$Res> implements $HealthCheckResultCopyWith<$Res> {
  factory _$HealthCheckResultCopyWith(_HealthCheckResult value, $Res Function(_HealthCheckResult) _then) = __$HealthCheckResultCopyWithImpl;
@override @useResult
$Res call({
 bool ok, String? message
});




}
/// @nodoc
class __$HealthCheckResultCopyWithImpl<$Res>
    implements _$HealthCheckResultCopyWith<$Res> {
  __$HealthCheckResultCopyWithImpl(this._self, this._then);

  final _HealthCheckResult _self;
  final $Res Function(_HealthCheckResult) _then;

/// Create a copy of HealthCheckResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? message = freezed,}) {
  return _then(_HealthCheckResult(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

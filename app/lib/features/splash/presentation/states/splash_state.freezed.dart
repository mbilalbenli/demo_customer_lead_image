// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'splash_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SplashState {

 bool get systemDone; bool get liveDone; bool get readyDone; bool get systemOk; bool get liveOk; bool get readyOk; String get message; bool get completed;
/// Create a copy of SplashState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SplashStateCopyWith<SplashState> get copyWith => _$SplashStateCopyWithImpl<SplashState>(this as SplashState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SplashState&&(identical(other.systemDone, systemDone) || other.systemDone == systemDone)&&(identical(other.liveDone, liveDone) || other.liveDone == liveDone)&&(identical(other.readyDone, readyDone) || other.readyDone == readyDone)&&(identical(other.systemOk, systemOk) || other.systemOk == systemOk)&&(identical(other.liveOk, liveOk) || other.liveOk == liveOk)&&(identical(other.readyOk, readyOk) || other.readyOk == readyOk)&&(identical(other.message, message) || other.message == message)&&(identical(other.completed, completed) || other.completed == completed));
}


@override
int get hashCode => Object.hash(runtimeType,systemDone,liveDone,readyDone,systemOk,liveOk,readyOk,message,completed);

@override
String toString() {
  return 'SplashState(systemDone: $systemDone, liveDone: $liveDone, readyDone: $readyDone, systemOk: $systemOk, liveOk: $liveOk, readyOk: $readyOk, message: $message, completed: $completed)';
}


}

/// @nodoc
abstract mixin class $SplashStateCopyWith<$Res>  {
  factory $SplashStateCopyWith(SplashState value, $Res Function(SplashState) _then) = _$SplashStateCopyWithImpl;
@useResult
$Res call({
 bool systemDone, bool liveDone, bool readyDone, bool systemOk, bool liveOk, bool readyOk, String message, bool completed
});




}
/// @nodoc
class _$SplashStateCopyWithImpl<$Res>
    implements $SplashStateCopyWith<$Res> {
  _$SplashStateCopyWithImpl(this._self, this._then);

  final SplashState _self;
  final $Res Function(SplashState) _then;

/// Create a copy of SplashState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? systemDone = null,Object? liveDone = null,Object? readyDone = null,Object? systemOk = null,Object? liveOk = null,Object? readyOk = null,Object? message = null,Object? completed = null,}) {
  return _then(_self.copyWith(
systemDone: null == systemDone ? _self.systemDone : systemDone // ignore: cast_nullable_to_non_nullable
as bool,liveDone: null == liveDone ? _self.liveDone : liveDone // ignore: cast_nullable_to_non_nullable
as bool,readyDone: null == readyDone ? _self.readyDone : readyDone // ignore: cast_nullable_to_non_nullable
as bool,systemOk: null == systemOk ? _self.systemOk : systemOk // ignore: cast_nullable_to_non_nullable
as bool,liveOk: null == liveOk ? _self.liveOk : liveOk // ignore: cast_nullable_to_non_nullable
as bool,readyOk: null == readyOk ? _self.readyOk : readyOk // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SplashState].
extension SplashStatePatterns on SplashState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SplashState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SplashState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SplashState value)  $default,){
final _that = this;
switch (_that) {
case _SplashState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SplashState value)?  $default,){
final _that = this;
switch (_that) {
case _SplashState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool systemDone,  bool liveDone,  bool readyDone,  bool systemOk,  bool liveOk,  bool readyOk,  String message,  bool completed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SplashState() when $default != null:
return $default(_that.systemDone,_that.liveDone,_that.readyDone,_that.systemOk,_that.liveOk,_that.readyOk,_that.message,_that.completed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool systemDone,  bool liveDone,  bool readyDone,  bool systemOk,  bool liveOk,  bool readyOk,  String message,  bool completed)  $default,) {final _that = this;
switch (_that) {
case _SplashState():
return $default(_that.systemDone,_that.liveDone,_that.readyDone,_that.systemOk,_that.liveOk,_that.readyOk,_that.message,_that.completed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool systemDone,  bool liveDone,  bool readyDone,  bool systemOk,  bool liveOk,  bool readyOk,  String message,  bool completed)?  $default,) {final _that = this;
switch (_that) {
case _SplashState() when $default != null:
return $default(_that.systemDone,_that.liveDone,_that.readyDone,_that.systemOk,_that.liveOk,_that.readyOk,_that.message,_that.completed);case _:
  return null;

}
}

}

/// @nodoc


class _SplashState implements SplashState {
  const _SplashState({this.systemDone = false, this.liveDone = false, this.readyDone = false, this.systemOk = false, this.liveOk = false, this.readyOk = false, this.message = '', this.completed = false});
  

@override@JsonKey() final  bool systemDone;
@override@JsonKey() final  bool liveDone;
@override@JsonKey() final  bool readyDone;
@override@JsonKey() final  bool systemOk;
@override@JsonKey() final  bool liveOk;
@override@JsonKey() final  bool readyOk;
@override@JsonKey() final  String message;
@override@JsonKey() final  bool completed;

/// Create a copy of SplashState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SplashStateCopyWith<_SplashState> get copyWith => __$SplashStateCopyWithImpl<_SplashState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SplashState&&(identical(other.systemDone, systemDone) || other.systemDone == systemDone)&&(identical(other.liveDone, liveDone) || other.liveDone == liveDone)&&(identical(other.readyDone, readyDone) || other.readyDone == readyDone)&&(identical(other.systemOk, systemOk) || other.systemOk == systemOk)&&(identical(other.liveOk, liveOk) || other.liveOk == liveOk)&&(identical(other.readyOk, readyOk) || other.readyOk == readyOk)&&(identical(other.message, message) || other.message == message)&&(identical(other.completed, completed) || other.completed == completed));
}


@override
int get hashCode => Object.hash(runtimeType,systemDone,liveDone,readyDone,systemOk,liveOk,readyOk,message,completed);

@override
String toString() {
  return 'SplashState(systemDone: $systemDone, liveDone: $liveDone, readyDone: $readyDone, systemOk: $systemOk, liveOk: $liveOk, readyOk: $readyOk, message: $message, completed: $completed)';
}


}

/// @nodoc
abstract mixin class _$SplashStateCopyWith<$Res> implements $SplashStateCopyWith<$Res> {
  factory _$SplashStateCopyWith(_SplashState value, $Res Function(_SplashState) _then) = __$SplashStateCopyWithImpl;
@override @useResult
$Res call({
 bool systemDone, bool liveDone, bool readyDone, bool systemOk, bool liveOk, bool readyOk, String message, bool completed
});




}
/// @nodoc
class __$SplashStateCopyWithImpl<$Res>
    implements _$SplashStateCopyWith<$Res> {
  __$SplashStateCopyWithImpl(this._self, this._then);

  final _SplashState _self;
  final $Res Function(_SplashState) _then;

/// Create a copy of SplashState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? systemDone = null,Object? liveDone = null,Object? readyDone = null,Object? systemOk = null,Object? liveOk = null,Object? readyOk = null,Object? message = null,Object? completed = null,}) {
  return _then(_SplashState(
systemDone: null == systemDone ? _self.systemDone : systemDone // ignore: cast_nullable_to_non_nullable
as bool,liveDone: null == liveDone ? _self.liveDone : liveDone // ignore: cast_nullable_to_non_nullable
as bool,readyDone: null == readyDone ? _self.readyDone : readyDone // ignore: cast_nullable_to_non_nullable
as bool,systemOk: null == systemOk ? _self.systemOk : systemOk // ignore: cast_nullable_to_non_nullable
as bool,liveOk: null == liveOk ? _self.liveOk : liveOk // ignore: cast_nullable_to_non_nullable
as bool,readyOk: null == readyOk ? _self.readyOk : readyOk // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

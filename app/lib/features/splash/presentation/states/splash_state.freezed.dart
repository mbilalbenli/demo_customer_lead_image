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

 String get message; bool get isLoading; bool get allResponsesReceived; int get responsesCount; bool get shouldNavigate; bool get shouldRetry;
/// Create a copy of SplashState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SplashStateCopyWith<SplashState> get copyWith => _$SplashStateCopyWithImpl<SplashState>(this as SplashState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SplashState&&(identical(other.message, message) || other.message == message)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.allResponsesReceived, allResponsesReceived) || other.allResponsesReceived == allResponsesReceived)&&(identical(other.responsesCount, responsesCount) || other.responsesCount == responsesCount)&&(identical(other.shouldNavigate, shouldNavigate) || other.shouldNavigate == shouldNavigate)&&(identical(other.shouldRetry, shouldRetry) || other.shouldRetry == shouldRetry));
}


@override
int get hashCode => Object.hash(runtimeType,message,isLoading,allResponsesReceived,responsesCount,shouldNavigate,shouldRetry);

@override
String toString() {
  return 'SplashState(message: $message, isLoading: $isLoading, allResponsesReceived: $allResponsesReceived, responsesCount: $responsesCount, shouldNavigate: $shouldNavigate, shouldRetry: $shouldRetry)';
}


}

/// @nodoc
abstract mixin class $SplashStateCopyWith<$Res>  {
  factory $SplashStateCopyWith(SplashState value, $Res Function(SplashState) _then) = _$SplashStateCopyWithImpl;
@useResult
$Res call({
 String message, bool isLoading, bool allResponsesReceived, int responsesCount, bool shouldNavigate, bool shouldRetry
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
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? isLoading = null,Object? allResponsesReceived = null,Object? responsesCount = null,Object? shouldNavigate = null,Object? shouldRetry = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,allResponsesReceived: null == allResponsesReceived ? _self.allResponsesReceived : allResponsesReceived // ignore: cast_nullable_to_non_nullable
as bool,responsesCount: null == responsesCount ? _self.responsesCount : responsesCount // ignore: cast_nullable_to_non_nullable
as int,shouldNavigate: null == shouldNavigate ? _self.shouldNavigate : shouldNavigate // ignore: cast_nullable_to_non_nullable
as bool,shouldRetry: null == shouldRetry ? _self.shouldRetry : shouldRetry // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message,  bool isLoading,  bool allResponsesReceived,  int responsesCount,  bool shouldNavigate,  bool shouldRetry)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SplashState() when $default != null:
return $default(_that.message,_that.isLoading,_that.allResponsesReceived,_that.responsesCount,_that.shouldNavigate,_that.shouldRetry);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message,  bool isLoading,  bool allResponsesReceived,  int responsesCount,  bool shouldNavigate,  bool shouldRetry)  $default,) {final _that = this;
switch (_that) {
case _SplashState():
return $default(_that.message,_that.isLoading,_that.allResponsesReceived,_that.responsesCount,_that.shouldNavigate,_that.shouldRetry);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message,  bool isLoading,  bool allResponsesReceived,  int responsesCount,  bool shouldNavigate,  bool shouldRetry)?  $default,) {final _that = this;
switch (_that) {
case _SplashState() when $default != null:
return $default(_that.message,_that.isLoading,_that.allResponsesReceived,_that.responsesCount,_that.shouldNavigate,_that.shouldRetry);case _:
  return null;

}
}

}

/// @nodoc


class _SplashState implements SplashState {
  const _SplashState({this.message = TempL10n.loading, this.isLoading = true, this.allResponsesReceived = false, this.responsesCount = 0, this.shouldNavigate = false, this.shouldRetry = false});
  

@override@JsonKey() final  String message;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool allResponsesReceived;
@override@JsonKey() final  int responsesCount;
@override@JsonKey() final  bool shouldNavigate;
@override@JsonKey() final  bool shouldRetry;

/// Create a copy of SplashState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SplashStateCopyWith<_SplashState> get copyWith => __$SplashStateCopyWithImpl<_SplashState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SplashState&&(identical(other.message, message) || other.message == message)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.allResponsesReceived, allResponsesReceived) || other.allResponsesReceived == allResponsesReceived)&&(identical(other.responsesCount, responsesCount) || other.responsesCount == responsesCount)&&(identical(other.shouldNavigate, shouldNavigate) || other.shouldNavigate == shouldNavigate)&&(identical(other.shouldRetry, shouldRetry) || other.shouldRetry == shouldRetry));
}


@override
int get hashCode => Object.hash(runtimeType,message,isLoading,allResponsesReceived,responsesCount,shouldNavigate,shouldRetry);

@override
String toString() {
  return 'SplashState(message: $message, isLoading: $isLoading, allResponsesReceived: $allResponsesReceived, responsesCount: $responsesCount, shouldNavigate: $shouldNavigate, shouldRetry: $shouldRetry)';
}


}

/// @nodoc
abstract mixin class _$SplashStateCopyWith<$Res> implements $SplashStateCopyWith<$Res> {
  factory _$SplashStateCopyWith(_SplashState value, $Res Function(_SplashState) _then) = __$SplashStateCopyWithImpl;
@override @useResult
$Res call({
 String message, bool isLoading, bool allResponsesReceived, int responsesCount, bool shouldNavigate, bool shouldRetry
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
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? isLoading = null,Object? allResponsesReceived = null,Object? responsesCount = null,Object? shouldNavigate = null,Object? shouldRetry = null,}) {
  return _then(_SplashState(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,allResponsesReceived: null == allResponsesReceived ? _self.allResponsesReceived : allResponsesReceived // ignore: cast_nullable_to_non_nullable
as bool,responsesCount: null == responsesCount ? _self.responsesCount : responsesCount // ignore: cast_nullable_to_non_nullable
as int,shouldNavigate: null == shouldNavigate ? _self.shouldNavigate : shouldNavigate // ignore: cast_nullable_to_non_nullable
as bool,shouldRetry: null == shouldRetry ? _self.shouldRetry : shouldRetry // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

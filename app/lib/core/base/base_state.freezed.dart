// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'base_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoreState {

 bool get isBusy; bool get showAppBar; String get busyOperation; String get title; GlobalKey? get widgetKeyForLoadingPosition;
/// Create a copy of CoreState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoreStateCopyWith<CoreState> get copyWith => _$CoreStateCopyWithImpl<CoreState>(this as CoreState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoreState&&(identical(other.isBusy, isBusy) || other.isBusy == isBusy)&&(identical(other.showAppBar, showAppBar) || other.showAppBar == showAppBar)&&(identical(other.busyOperation, busyOperation) || other.busyOperation == busyOperation)&&(identical(other.title, title) || other.title == title)&&(identical(other.widgetKeyForLoadingPosition, widgetKeyForLoadingPosition) || other.widgetKeyForLoadingPosition == widgetKeyForLoadingPosition));
}


@override
int get hashCode => Object.hash(runtimeType,isBusy,showAppBar,busyOperation,title,widgetKeyForLoadingPosition);

@override
String toString() {
  return 'CoreState(isBusy: $isBusy, showAppBar: $showAppBar, busyOperation: $busyOperation, title: $title, widgetKeyForLoadingPosition: $widgetKeyForLoadingPosition)';
}


}

/// @nodoc
abstract mixin class $CoreStateCopyWith<$Res>  {
  factory $CoreStateCopyWith(CoreState value, $Res Function(CoreState) _then) = _$CoreStateCopyWithImpl;
@useResult
$Res call({
 bool isBusy, bool showAppBar, String busyOperation, String title, GlobalKey? widgetKeyForLoadingPosition
});




}
/// @nodoc
class _$CoreStateCopyWithImpl<$Res>
    implements $CoreStateCopyWith<$Res> {
  _$CoreStateCopyWithImpl(this._self, this._then);

  final CoreState _self;
  final $Res Function(CoreState) _then;

/// Create a copy of CoreState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isBusy = null,Object? showAppBar = null,Object? busyOperation = null,Object? title = null,Object? widgetKeyForLoadingPosition = freezed,}) {
  return _then(_self.copyWith(
isBusy: null == isBusy ? _self.isBusy : isBusy // ignore: cast_nullable_to_non_nullable
as bool,showAppBar: null == showAppBar ? _self.showAppBar : showAppBar // ignore: cast_nullable_to_non_nullable
as bool,busyOperation: null == busyOperation ? _self.busyOperation : busyOperation // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,widgetKeyForLoadingPosition: freezed == widgetKeyForLoadingPosition ? _self.widgetKeyForLoadingPosition : widgetKeyForLoadingPosition // ignore: cast_nullable_to_non_nullable
as GlobalKey?,
  ));
}

}


/// Adds pattern-matching-related methods to [CoreState].
extension CoreStatePatterns on CoreState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoreState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoreState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoreState value)  $default,){
final _that = this;
switch (_that) {
case _CoreState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoreState value)?  $default,){
final _that = this;
switch (_that) {
case _CoreState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isBusy,  bool showAppBar,  String busyOperation,  String title,  GlobalKey? widgetKeyForLoadingPosition)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoreState() when $default != null:
return $default(_that.isBusy,_that.showAppBar,_that.busyOperation,_that.title,_that.widgetKeyForLoadingPosition);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isBusy,  bool showAppBar,  String busyOperation,  String title,  GlobalKey? widgetKeyForLoadingPosition)  $default,) {final _that = this;
switch (_that) {
case _CoreState():
return $default(_that.isBusy,_that.showAppBar,_that.busyOperation,_that.title,_that.widgetKeyForLoadingPosition);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isBusy,  bool showAppBar,  String busyOperation,  String title,  GlobalKey? widgetKeyForLoadingPosition)?  $default,) {final _that = this;
switch (_that) {
case _CoreState() when $default != null:
return $default(_that.isBusy,_that.showAppBar,_that.busyOperation,_that.title,_that.widgetKeyForLoadingPosition);case _:
  return null;

}
}

}

/// @nodoc


class _CoreState implements CoreState {
  const _CoreState({this.isBusy = false, this.showAppBar = false, this.busyOperation = '', this.title = '', this.widgetKeyForLoadingPosition});
  

@override@JsonKey() final  bool isBusy;
@override@JsonKey() final  bool showAppBar;
@override@JsonKey() final  String busyOperation;
@override@JsonKey() final  String title;
@override final  GlobalKey? widgetKeyForLoadingPosition;

/// Create a copy of CoreState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoreStateCopyWith<_CoreState> get copyWith => __$CoreStateCopyWithImpl<_CoreState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoreState&&(identical(other.isBusy, isBusy) || other.isBusy == isBusy)&&(identical(other.showAppBar, showAppBar) || other.showAppBar == showAppBar)&&(identical(other.busyOperation, busyOperation) || other.busyOperation == busyOperation)&&(identical(other.title, title) || other.title == title)&&(identical(other.widgetKeyForLoadingPosition, widgetKeyForLoadingPosition) || other.widgetKeyForLoadingPosition == widgetKeyForLoadingPosition));
}


@override
int get hashCode => Object.hash(runtimeType,isBusy,showAppBar,busyOperation,title,widgetKeyForLoadingPosition);

@override
String toString() {
  return 'CoreState(isBusy: $isBusy, showAppBar: $showAppBar, busyOperation: $busyOperation, title: $title, widgetKeyForLoadingPosition: $widgetKeyForLoadingPosition)';
}


}

/// @nodoc
abstract mixin class _$CoreStateCopyWith<$Res> implements $CoreStateCopyWith<$Res> {
  factory _$CoreStateCopyWith(_CoreState value, $Res Function(_CoreState) _then) = __$CoreStateCopyWithImpl;
@override @useResult
$Res call({
 bool isBusy, bool showAppBar, String busyOperation, String title, GlobalKey? widgetKeyForLoadingPosition
});




}
/// @nodoc
class __$CoreStateCopyWithImpl<$Res>
    implements _$CoreStateCopyWith<$Res> {
  __$CoreStateCopyWithImpl(this._self, this._then);

  final _CoreState _self;
  final $Res Function(_CoreState) _then;

/// Create a copy of CoreState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isBusy = null,Object? showAppBar = null,Object? busyOperation = null,Object? title = null,Object? widgetKeyForLoadingPosition = freezed,}) {
  return _then(_CoreState(
isBusy: null == isBusy ? _self.isBusy : isBusy // ignore: cast_nullable_to_non_nullable
as bool,showAppBar: null == showAppBar ? _self.showAppBar : showAppBar // ignore: cast_nullable_to_non_nullable
as bool,busyOperation: null == busyOperation ? _self.busyOperation : busyOperation // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,widgetKeyForLoadingPosition: freezed == widgetKeyForLoadingPosition ? _self.widgetKeyForLoadingPosition : widgetKeyForLoadingPosition // ignore: cast_nullable_to_non_nullable
as GlobalKey?,
  ));
}


}

// dart format on

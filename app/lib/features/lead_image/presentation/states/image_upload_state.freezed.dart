// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_upload_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ImageUploadState {

 CoreState get core; String get leadId; List<UploadQueueItemEntity> get queue; bool get isUploading; double get totalProgress; UploadOptionsEntity get options; String? get errorMessage;
/// Create a copy of ImageUploadState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageUploadStateCopyWith<ImageUploadState> get copyWith => _$ImageUploadStateCopyWithImpl<ImageUploadState>(this as ImageUploadState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageUploadState&&(identical(other.core, core) || other.core == core)&&(identical(other.leadId, leadId) || other.leadId == leadId)&&const DeepCollectionEquality().equals(other.queue, queue)&&(identical(other.isUploading, isUploading) || other.isUploading == isUploading)&&(identical(other.totalProgress, totalProgress) || other.totalProgress == totalProgress)&&(identical(other.options, options) || other.options == options)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,core,leadId,const DeepCollectionEquality().hash(queue),isUploading,totalProgress,options,errorMessage);

@override
String toString() {
  return 'ImageUploadState(core: $core, leadId: $leadId, queue: $queue, isUploading: $isUploading, totalProgress: $totalProgress, options: $options, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ImageUploadStateCopyWith<$Res>  {
  factory $ImageUploadStateCopyWith(ImageUploadState value, $Res Function(ImageUploadState) _then) = _$ImageUploadStateCopyWithImpl;
@useResult
$Res call({
 CoreState core, String leadId, List<UploadQueueItemEntity> queue, bool isUploading, double totalProgress, UploadOptionsEntity options, String? errorMessage
});


$CoreStateCopyWith<$Res> get core;

}
/// @nodoc
class _$ImageUploadStateCopyWithImpl<$Res>
    implements $ImageUploadStateCopyWith<$Res> {
  _$ImageUploadStateCopyWithImpl(this._self, this._then);

  final ImageUploadState _self;
  final $Res Function(ImageUploadState) _then;

/// Create a copy of ImageUploadState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? core = null,Object? leadId = null,Object? queue = null,Object? isUploading = null,Object? totalProgress = null,Object? options = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
core: null == core ? _self.core : core // ignore: cast_nullable_to_non_nullable
as CoreState,leadId: null == leadId ? _self.leadId : leadId // ignore: cast_nullable_to_non_nullable
as String,queue: null == queue ? _self.queue : queue // ignore: cast_nullable_to_non_nullable
as List<UploadQueueItemEntity>,isUploading: null == isUploading ? _self.isUploading : isUploading // ignore: cast_nullable_to_non_nullable
as bool,totalProgress: null == totalProgress ? _self.totalProgress : totalProgress // ignore: cast_nullable_to_non_nullable
as double,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as UploadOptionsEntity,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ImageUploadState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoreStateCopyWith<$Res> get core {
  
  return $CoreStateCopyWith<$Res>(_self.core, (value) {
    return _then(_self.copyWith(core: value));
  });
}
}


/// Adds pattern-matching-related methods to [ImageUploadState].
extension ImageUploadStatePatterns on ImageUploadState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImageUploadState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImageUploadState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImageUploadState value)  $default,){
final _that = this;
switch (_that) {
case _ImageUploadState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImageUploadState value)?  $default,){
final _that = this;
switch (_that) {
case _ImageUploadState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CoreState core,  String leadId,  List<UploadQueueItemEntity> queue,  bool isUploading,  double totalProgress,  UploadOptionsEntity options,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImageUploadState() when $default != null:
return $default(_that.core,_that.leadId,_that.queue,_that.isUploading,_that.totalProgress,_that.options,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CoreState core,  String leadId,  List<UploadQueueItemEntity> queue,  bool isUploading,  double totalProgress,  UploadOptionsEntity options,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ImageUploadState():
return $default(_that.core,_that.leadId,_that.queue,_that.isUploading,_that.totalProgress,_that.options,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CoreState core,  String leadId,  List<UploadQueueItemEntity> queue,  bool isUploading,  double totalProgress,  UploadOptionsEntity options,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ImageUploadState() when $default != null:
return $default(_that.core,_that.leadId,_that.queue,_that.isUploading,_that.totalProgress,_that.options,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ImageUploadState extends ImageUploadState {
  const _ImageUploadState({this.core = const CoreState(), required this.leadId, final  List<UploadQueueItemEntity> queue = const <UploadQueueItemEntity>[], this.isUploading = false, this.totalProgress = 0.0, this.options = const UploadOptionsEntity(), this.errorMessage}): _queue = queue,super._();
  

@override@JsonKey() final  CoreState core;
@override final  String leadId;
 final  List<UploadQueueItemEntity> _queue;
@override@JsonKey() List<UploadQueueItemEntity> get queue {
  if (_queue is EqualUnmodifiableListView) return _queue;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_queue);
}

@override@JsonKey() final  bool isUploading;
@override@JsonKey() final  double totalProgress;
@override@JsonKey() final  UploadOptionsEntity options;
@override final  String? errorMessage;

/// Create a copy of ImageUploadState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImageUploadStateCopyWith<_ImageUploadState> get copyWith => __$ImageUploadStateCopyWithImpl<_ImageUploadState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImageUploadState&&(identical(other.core, core) || other.core == core)&&(identical(other.leadId, leadId) || other.leadId == leadId)&&const DeepCollectionEquality().equals(other._queue, _queue)&&(identical(other.isUploading, isUploading) || other.isUploading == isUploading)&&(identical(other.totalProgress, totalProgress) || other.totalProgress == totalProgress)&&(identical(other.options, options) || other.options == options)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,core,leadId,const DeepCollectionEquality().hash(_queue),isUploading,totalProgress,options,errorMessage);

@override
String toString() {
  return 'ImageUploadState(core: $core, leadId: $leadId, queue: $queue, isUploading: $isUploading, totalProgress: $totalProgress, options: $options, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ImageUploadStateCopyWith<$Res> implements $ImageUploadStateCopyWith<$Res> {
  factory _$ImageUploadStateCopyWith(_ImageUploadState value, $Res Function(_ImageUploadState) _then) = __$ImageUploadStateCopyWithImpl;
@override @useResult
$Res call({
 CoreState core, String leadId, List<UploadQueueItemEntity> queue, bool isUploading, double totalProgress, UploadOptionsEntity options, String? errorMessage
});


@override $CoreStateCopyWith<$Res> get core;

}
/// @nodoc
class __$ImageUploadStateCopyWithImpl<$Res>
    implements _$ImageUploadStateCopyWith<$Res> {
  __$ImageUploadStateCopyWithImpl(this._self, this._then);

  final _ImageUploadState _self;
  final $Res Function(_ImageUploadState) _then;

/// Create a copy of ImageUploadState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? core = null,Object? leadId = null,Object? queue = null,Object? isUploading = null,Object? totalProgress = null,Object? options = null,Object? errorMessage = freezed,}) {
  return _then(_ImageUploadState(
core: null == core ? _self.core : core // ignore: cast_nullable_to_non_nullable
as CoreState,leadId: null == leadId ? _self.leadId : leadId // ignore: cast_nullable_to_non_nullable
as String,queue: null == queue ? _self._queue : queue // ignore: cast_nullable_to_non_nullable
as List<UploadQueueItemEntity>,isUploading: null == isUploading ? _self.isUploading : isUploading // ignore: cast_nullable_to_non_nullable
as bool,totalProgress: null == totalProgress ? _self.totalProgress : totalProgress // ignore: cast_nullable_to_non_nullable
as double,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as UploadOptionsEntity,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ImageUploadState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoreStateCopyWith<$Res> get core {
  
  return $CoreStateCopyWith<$Res>(_self.core, (value) {
    return _then(_self.copyWith(core: value));
  });
}
}

// dart format on

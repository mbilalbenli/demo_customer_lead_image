// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_gallery_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ImageGalleryState {

 CoreState get core; String get leadId; List<LeadImageEntity> get images; int get currentCount; int get maxCount; int get selectedIndex; bool get isUploading; bool get isDeleting; double? get uploadProgress; String? get errorMessage; bool get showLimitWarning; LeadImageEntity? get imageBeingReplaced; ImageAction get lastAction;
/// Create a copy of ImageGalleryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageGalleryStateCopyWith<ImageGalleryState> get copyWith => _$ImageGalleryStateCopyWithImpl<ImageGalleryState>(this as ImageGalleryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageGalleryState&&(identical(other.core, core) || other.core == core)&&(identical(other.leadId, leadId) || other.leadId == leadId)&&const DeepCollectionEquality().equals(other.images, images)&&(identical(other.currentCount, currentCount) || other.currentCount == currentCount)&&(identical(other.maxCount, maxCount) || other.maxCount == maxCount)&&(identical(other.selectedIndex, selectedIndex) || other.selectedIndex == selectedIndex)&&(identical(other.isUploading, isUploading) || other.isUploading == isUploading)&&(identical(other.isDeleting, isDeleting) || other.isDeleting == isDeleting)&&(identical(other.uploadProgress, uploadProgress) || other.uploadProgress == uploadProgress)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.showLimitWarning, showLimitWarning) || other.showLimitWarning == showLimitWarning)&&(identical(other.imageBeingReplaced, imageBeingReplaced) || other.imageBeingReplaced == imageBeingReplaced)&&(identical(other.lastAction, lastAction) || other.lastAction == lastAction));
}


@override
int get hashCode => Object.hash(runtimeType,core,leadId,const DeepCollectionEquality().hash(images),currentCount,maxCount,selectedIndex,isUploading,isDeleting,uploadProgress,errorMessage,showLimitWarning,imageBeingReplaced,lastAction);

@override
String toString() {
  return 'ImageGalleryState(core: $core, leadId: $leadId, images: $images, currentCount: $currentCount, maxCount: $maxCount, selectedIndex: $selectedIndex, isUploading: $isUploading, isDeleting: $isDeleting, uploadProgress: $uploadProgress, errorMessage: $errorMessage, showLimitWarning: $showLimitWarning, imageBeingReplaced: $imageBeingReplaced, lastAction: $lastAction)';
}


}

/// @nodoc
abstract mixin class $ImageGalleryStateCopyWith<$Res>  {
  factory $ImageGalleryStateCopyWith(ImageGalleryState value, $Res Function(ImageGalleryState) _then) = _$ImageGalleryStateCopyWithImpl;
@useResult
$Res call({
 CoreState core, String leadId, List<LeadImageEntity> images, int currentCount, int maxCount, int selectedIndex, bool isUploading, bool isDeleting, double? uploadProgress, String? errorMessage, bool showLimitWarning, LeadImageEntity? imageBeingReplaced, ImageAction lastAction
});


$CoreStateCopyWith<$Res> get core;$LeadImageEntityCopyWith<$Res>? get imageBeingReplaced;

}
/// @nodoc
class _$ImageGalleryStateCopyWithImpl<$Res>
    implements $ImageGalleryStateCopyWith<$Res> {
  _$ImageGalleryStateCopyWithImpl(this._self, this._then);

  final ImageGalleryState _self;
  final $Res Function(ImageGalleryState) _then;

/// Create a copy of ImageGalleryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? core = null,Object? leadId = null,Object? images = null,Object? currentCount = null,Object? maxCount = null,Object? selectedIndex = null,Object? isUploading = null,Object? isDeleting = null,Object? uploadProgress = freezed,Object? errorMessage = freezed,Object? showLimitWarning = null,Object? imageBeingReplaced = freezed,Object? lastAction = null,}) {
  return _then(_self.copyWith(
core: null == core ? _self.core : core // ignore: cast_nullable_to_non_nullable
as CoreState,leadId: null == leadId ? _self.leadId : leadId // ignore: cast_nullable_to_non_nullable
as String,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<LeadImageEntity>,currentCount: null == currentCount ? _self.currentCount : currentCount // ignore: cast_nullable_to_non_nullable
as int,maxCount: null == maxCount ? _self.maxCount : maxCount // ignore: cast_nullable_to_non_nullable
as int,selectedIndex: null == selectedIndex ? _self.selectedIndex : selectedIndex // ignore: cast_nullable_to_non_nullable
as int,isUploading: null == isUploading ? _self.isUploading : isUploading // ignore: cast_nullable_to_non_nullable
as bool,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,uploadProgress: freezed == uploadProgress ? _self.uploadProgress : uploadProgress // ignore: cast_nullable_to_non_nullable
as double?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,showLimitWarning: null == showLimitWarning ? _self.showLimitWarning : showLimitWarning // ignore: cast_nullable_to_non_nullable
as bool,imageBeingReplaced: freezed == imageBeingReplaced ? _self.imageBeingReplaced : imageBeingReplaced // ignore: cast_nullable_to_non_nullable
as LeadImageEntity?,lastAction: null == lastAction ? _self.lastAction : lastAction // ignore: cast_nullable_to_non_nullable
as ImageAction,
  ));
}
/// Create a copy of ImageGalleryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoreStateCopyWith<$Res> get core {
  
  return $CoreStateCopyWith<$Res>(_self.core, (value) {
    return _then(_self.copyWith(core: value));
  });
}/// Create a copy of ImageGalleryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeadImageEntityCopyWith<$Res>? get imageBeingReplaced {
    if (_self.imageBeingReplaced == null) {
    return null;
  }

  return $LeadImageEntityCopyWith<$Res>(_self.imageBeingReplaced!, (value) {
    return _then(_self.copyWith(imageBeingReplaced: value));
  });
}
}


/// Adds pattern-matching-related methods to [ImageGalleryState].
extension ImageGalleryStatePatterns on ImageGalleryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImageGalleryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImageGalleryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImageGalleryState value)  $default,){
final _that = this;
switch (_that) {
case _ImageGalleryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImageGalleryState value)?  $default,){
final _that = this;
switch (_that) {
case _ImageGalleryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CoreState core,  String leadId,  List<LeadImageEntity> images,  int currentCount,  int maxCount,  int selectedIndex,  bool isUploading,  bool isDeleting,  double? uploadProgress,  String? errorMessage,  bool showLimitWarning,  LeadImageEntity? imageBeingReplaced,  ImageAction lastAction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImageGalleryState() when $default != null:
return $default(_that.core,_that.leadId,_that.images,_that.currentCount,_that.maxCount,_that.selectedIndex,_that.isUploading,_that.isDeleting,_that.uploadProgress,_that.errorMessage,_that.showLimitWarning,_that.imageBeingReplaced,_that.lastAction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CoreState core,  String leadId,  List<LeadImageEntity> images,  int currentCount,  int maxCount,  int selectedIndex,  bool isUploading,  bool isDeleting,  double? uploadProgress,  String? errorMessage,  bool showLimitWarning,  LeadImageEntity? imageBeingReplaced,  ImageAction lastAction)  $default,) {final _that = this;
switch (_that) {
case _ImageGalleryState():
return $default(_that.core,_that.leadId,_that.images,_that.currentCount,_that.maxCount,_that.selectedIndex,_that.isUploading,_that.isDeleting,_that.uploadProgress,_that.errorMessage,_that.showLimitWarning,_that.imageBeingReplaced,_that.lastAction);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CoreState core,  String leadId,  List<LeadImageEntity> images,  int currentCount,  int maxCount,  int selectedIndex,  bool isUploading,  bool isDeleting,  double? uploadProgress,  String? errorMessage,  bool showLimitWarning,  LeadImageEntity? imageBeingReplaced,  ImageAction lastAction)?  $default,) {final _that = this;
switch (_that) {
case _ImageGalleryState() when $default != null:
return $default(_that.core,_that.leadId,_that.images,_that.currentCount,_that.maxCount,_that.selectedIndex,_that.isUploading,_that.isDeleting,_that.uploadProgress,_that.errorMessage,_that.showLimitWarning,_that.imageBeingReplaced,_that.lastAction);case _:
  return null;

}
}

}

/// @nodoc


class _ImageGalleryState extends ImageGalleryState {
  const _ImageGalleryState({this.core = const CoreState(), required this.leadId, final  List<LeadImageEntity> images = const [], this.currentCount = 0, this.maxCount = 10, this.selectedIndex = 0, this.isUploading = false, this.isDeleting = false, this.uploadProgress, this.errorMessage, this.showLimitWarning = false, this.imageBeingReplaced, this.lastAction = ImageAction.none}): _images = images,super._();
  

@override@JsonKey() final  CoreState core;
@override final  String leadId;
 final  List<LeadImageEntity> _images;
@override@JsonKey() List<LeadImageEntity> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

@override@JsonKey() final  int currentCount;
@override@JsonKey() final  int maxCount;
@override@JsonKey() final  int selectedIndex;
@override@JsonKey() final  bool isUploading;
@override@JsonKey() final  bool isDeleting;
@override final  double? uploadProgress;
@override final  String? errorMessage;
@override@JsonKey() final  bool showLimitWarning;
@override final  LeadImageEntity? imageBeingReplaced;
@override@JsonKey() final  ImageAction lastAction;

/// Create a copy of ImageGalleryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImageGalleryStateCopyWith<_ImageGalleryState> get copyWith => __$ImageGalleryStateCopyWithImpl<_ImageGalleryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImageGalleryState&&(identical(other.core, core) || other.core == core)&&(identical(other.leadId, leadId) || other.leadId == leadId)&&const DeepCollectionEquality().equals(other._images, _images)&&(identical(other.currentCount, currentCount) || other.currentCount == currentCount)&&(identical(other.maxCount, maxCount) || other.maxCount == maxCount)&&(identical(other.selectedIndex, selectedIndex) || other.selectedIndex == selectedIndex)&&(identical(other.isUploading, isUploading) || other.isUploading == isUploading)&&(identical(other.isDeleting, isDeleting) || other.isDeleting == isDeleting)&&(identical(other.uploadProgress, uploadProgress) || other.uploadProgress == uploadProgress)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.showLimitWarning, showLimitWarning) || other.showLimitWarning == showLimitWarning)&&(identical(other.imageBeingReplaced, imageBeingReplaced) || other.imageBeingReplaced == imageBeingReplaced)&&(identical(other.lastAction, lastAction) || other.lastAction == lastAction));
}


@override
int get hashCode => Object.hash(runtimeType,core,leadId,const DeepCollectionEquality().hash(_images),currentCount,maxCount,selectedIndex,isUploading,isDeleting,uploadProgress,errorMessage,showLimitWarning,imageBeingReplaced,lastAction);

@override
String toString() {
  return 'ImageGalleryState(core: $core, leadId: $leadId, images: $images, currentCount: $currentCount, maxCount: $maxCount, selectedIndex: $selectedIndex, isUploading: $isUploading, isDeleting: $isDeleting, uploadProgress: $uploadProgress, errorMessage: $errorMessage, showLimitWarning: $showLimitWarning, imageBeingReplaced: $imageBeingReplaced, lastAction: $lastAction)';
}


}

/// @nodoc
abstract mixin class _$ImageGalleryStateCopyWith<$Res> implements $ImageGalleryStateCopyWith<$Res> {
  factory _$ImageGalleryStateCopyWith(_ImageGalleryState value, $Res Function(_ImageGalleryState) _then) = __$ImageGalleryStateCopyWithImpl;
@override @useResult
$Res call({
 CoreState core, String leadId, List<LeadImageEntity> images, int currentCount, int maxCount, int selectedIndex, bool isUploading, bool isDeleting, double? uploadProgress, String? errorMessage, bool showLimitWarning, LeadImageEntity? imageBeingReplaced, ImageAction lastAction
});


@override $CoreStateCopyWith<$Res> get core;@override $LeadImageEntityCopyWith<$Res>? get imageBeingReplaced;

}
/// @nodoc
class __$ImageGalleryStateCopyWithImpl<$Res>
    implements _$ImageGalleryStateCopyWith<$Res> {
  __$ImageGalleryStateCopyWithImpl(this._self, this._then);

  final _ImageGalleryState _self;
  final $Res Function(_ImageGalleryState) _then;

/// Create a copy of ImageGalleryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? core = null,Object? leadId = null,Object? images = null,Object? currentCount = null,Object? maxCount = null,Object? selectedIndex = null,Object? isUploading = null,Object? isDeleting = null,Object? uploadProgress = freezed,Object? errorMessage = freezed,Object? showLimitWarning = null,Object? imageBeingReplaced = freezed,Object? lastAction = null,}) {
  return _then(_ImageGalleryState(
core: null == core ? _self.core : core // ignore: cast_nullable_to_non_nullable
as CoreState,leadId: null == leadId ? _self.leadId : leadId // ignore: cast_nullable_to_non_nullable
as String,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<LeadImageEntity>,currentCount: null == currentCount ? _self.currentCount : currentCount // ignore: cast_nullable_to_non_nullable
as int,maxCount: null == maxCount ? _self.maxCount : maxCount // ignore: cast_nullable_to_non_nullable
as int,selectedIndex: null == selectedIndex ? _self.selectedIndex : selectedIndex // ignore: cast_nullable_to_non_nullable
as int,isUploading: null == isUploading ? _self.isUploading : isUploading // ignore: cast_nullable_to_non_nullable
as bool,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,uploadProgress: freezed == uploadProgress ? _self.uploadProgress : uploadProgress // ignore: cast_nullable_to_non_nullable
as double?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,showLimitWarning: null == showLimitWarning ? _self.showLimitWarning : showLimitWarning // ignore: cast_nullable_to_non_nullable
as bool,imageBeingReplaced: freezed == imageBeingReplaced ? _self.imageBeingReplaced : imageBeingReplaced // ignore: cast_nullable_to_non_nullable
as LeadImageEntity?,lastAction: null == lastAction ? _self.lastAction : lastAction // ignore: cast_nullable_to_non_nullable
as ImageAction,
  ));
}

/// Create a copy of ImageGalleryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoreStateCopyWith<$Res> get core {
  
  return $CoreStateCopyWith<$Res>(_self.core, (value) {
    return _then(_self.copyWith(core: value));
  });
}/// Create a copy of ImageGalleryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeadImageEntityCopyWith<$Res>? get imageBeingReplaced {
    if (_self.imageBeingReplaced == null) {
    return null;
  }

  return $LeadImageEntityCopyWith<$Res>(_self.imageBeingReplaced!, (value) {
    return _then(_self.copyWith(imageBeingReplaced: value));
  });
}
}

// dart format on

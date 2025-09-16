// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lead_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LeadDetailState {

 CoreState get core; LeadEntity? get lead; bool get canAddImage; int get imageCount; int get maxImages; String? get errorMessage;
/// Create a copy of LeadDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeadDetailStateCopyWith<LeadDetailState> get copyWith => _$LeadDetailStateCopyWithImpl<LeadDetailState>(this as LeadDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeadDetailState&&(identical(other.core, core) || other.core == core)&&(identical(other.lead, lead) || other.lead == lead)&&(identical(other.canAddImage, canAddImage) || other.canAddImage == canAddImage)&&(identical(other.imageCount, imageCount) || other.imageCount == imageCount)&&(identical(other.maxImages, maxImages) || other.maxImages == maxImages)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,core,lead,canAddImage,imageCount,maxImages,errorMessage);

@override
String toString() {
  return 'LeadDetailState(core: $core, lead: $lead, canAddImage: $canAddImage, imageCount: $imageCount, maxImages: $maxImages, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $LeadDetailStateCopyWith<$Res>  {
  factory $LeadDetailStateCopyWith(LeadDetailState value, $Res Function(LeadDetailState) _then) = _$LeadDetailStateCopyWithImpl;
@useResult
$Res call({
 CoreState core, LeadEntity? lead, bool canAddImage, int imageCount, int maxImages, String? errorMessage
});


$CoreStateCopyWith<$Res> get core;$LeadEntityCopyWith<$Res>? get lead;

}
/// @nodoc
class _$LeadDetailStateCopyWithImpl<$Res>
    implements $LeadDetailStateCopyWith<$Res> {
  _$LeadDetailStateCopyWithImpl(this._self, this._then);

  final LeadDetailState _self;
  final $Res Function(LeadDetailState) _then;

/// Create a copy of LeadDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? core = null,Object? lead = freezed,Object? canAddImage = null,Object? imageCount = null,Object? maxImages = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
core: null == core ? _self.core : core // ignore: cast_nullable_to_non_nullable
as CoreState,lead: freezed == lead ? _self.lead : lead // ignore: cast_nullable_to_non_nullable
as LeadEntity?,canAddImage: null == canAddImage ? _self.canAddImage : canAddImage // ignore: cast_nullable_to_non_nullable
as bool,imageCount: null == imageCount ? _self.imageCount : imageCount // ignore: cast_nullable_to_non_nullable
as int,maxImages: null == maxImages ? _self.maxImages : maxImages // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of LeadDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoreStateCopyWith<$Res> get core {
  
  return $CoreStateCopyWith<$Res>(_self.core, (value) {
    return _then(_self.copyWith(core: value));
  });
}/// Create a copy of LeadDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeadEntityCopyWith<$Res>? get lead {
    if (_self.lead == null) {
    return null;
  }

  return $LeadEntityCopyWith<$Res>(_self.lead!, (value) {
    return _then(_self.copyWith(lead: value));
  });
}
}


/// Adds pattern-matching-related methods to [LeadDetailState].
extension LeadDetailStatePatterns on LeadDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeadDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeadDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeadDetailState value)  $default,){
final _that = this;
switch (_that) {
case _LeadDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeadDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _LeadDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CoreState core,  LeadEntity? lead,  bool canAddImage,  int imageCount,  int maxImages,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeadDetailState() when $default != null:
return $default(_that.core,_that.lead,_that.canAddImage,_that.imageCount,_that.maxImages,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CoreState core,  LeadEntity? lead,  bool canAddImage,  int imageCount,  int maxImages,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _LeadDetailState():
return $default(_that.core,_that.lead,_that.canAddImage,_that.imageCount,_that.maxImages,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CoreState core,  LeadEntity? lead,  bool canAddImage,  int imageCount,  int maxImages,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _LeadDetailState() when $default != null:
return $default(_that.core,_that.lead,_that.canAddImage,_that.imageCount,_that.maxImages,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _LeadDetailState extends LeadDetailState {
  const _LeadDetailState({this.core = const CoreState(), this.lead, this.canAddImage = false, this.imageCount = 0, this.maxImages = 10, this.errorMessage}): super._();
  

@override@JsonKey() final  CoreState core;
@override final  LeadEntity? lead;
@override@JsonKey() final  bool canAddImage;
@override@JsonKey() final  int imageCount;
@override@JsonKey() final  int maxImages;
@override final  String? errorMessage;

/// Create a copy of LeadDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeadDetailStateCopyWith<_LeadDetailState> get copyWith => __$LeadDetailStateCopyWithImpl<_LeadDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeadDetailState&&(identical(other.core, core) || other.core == core)&&(identical(other.lead, lead) || other.lead == lead)&&(identical(other.canAddImage, canAddImage) || other.canAddImage == canAddImage)&&(identical(other.imageCount, imageCount) || other.imageCount == imageCount)&&(identical(other.maxImages, maxImages) || other.maxImages == maxImages)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,core,lead,canAddImage,imageCount,maxImages,errorMessage);

@override
String toString() {
  return 'LeadDetailState(core: $core, lead: $lead, canAddImage: $canAddImage, imageCount: $imageCount, maxImages: $maxImages, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$LeadDetailStateCopyWith<$Res> implements $LeadDetailStateCopyWith<$Res> {
  factory _$LeadDetailStateCopyWith(_LeadDetailState value, $Res Function(_LeadDetailState) _then) = __$LeadDetailStateCopyWithImpl;
@override @useResult
$Res call({
 CoreState core, LeadEntity? lead, bool canAddImage, int imageCount, int maxImages, String? errorMessage
});


@override $CoreStateCopyWith<$Res> get core;@override $LeadEntityCopyWith<$Res>? get lead;

}
/// @nodoc
class __$LeadDetailStateCopyWithImpl<$Res>
    implements _$LeadDetailStateCopyWith<$Res> {
  __$LeadDetailStateCopyWithImpl(this._self, this._then);

  final _LeadDetailState _self;
  final $Res Function(_LeadDetailState) _then;

/// Create a copy of LeadDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? core = null,Object? lead = freezed,Object? canAddImage = null,Object? imageCount = null,Object? maxImages = null,Object? errorMessage = freezed,}) {
  return _then(_LeadDetailState(
core: null == core ? _self.core : core // ignore: cast_nullable_to_non_nullable
as CoreState,lead: freezed == lead ? _self.lead : lead // ignore: cast_nullable_to_non_nullable
as LeadEntity?,canAddImage: null == canAddImage ? _self.canAddImage : canAddImage // ignore: cast_nullable_to_non_nullable
as bool,imageCount: null == imageCount ? _self.imageCount : imageCount // ignore: cast_nullable_to_non_nullable
as int,maxImages: null == maxImages ? _self.maxImages : maxImages // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of LeadDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoreStateCopyWith<$Res> get core {
  
  return $CoreStateCopyWith<$Res>(_self.core, (value) {
    return _then(_self.copyWith(core: value));
  });
}/// Create a copy of LeadDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeadEntityCopyWith<$Res>? get lead {
    if (_self.lead == null) {
    return null;
  }

  return $LeadEntityCopyWith<$Res>(_self.lead!, (value) {
    return _then(_self.copyWith(lead: value));
  });
}
}

// dart format on

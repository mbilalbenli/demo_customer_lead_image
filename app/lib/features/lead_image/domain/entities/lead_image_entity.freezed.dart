// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lead_image_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeadImageEntity {

 String get id; String get leadId;@Base64ImageDataConverter() Base64ImageData get base64Data;@ImageMetadataConverter() ImageMetadata get metadata; int get orderIndex; DateTime get createdAt; DateTime? get updatedAt;
/// Create a copy of LeadImageEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeadImageEntityCopyWith<LeadImageEntity> get copyWith => _$LeadImageEntityCopyWithImpl<LeadImageEntity>(this as LeadImageEntity, _$identity);

  /// Serializes this LeadImageEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeadImageEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.leadId, leadId) || other.leadId == leadId)&&(identical(other.base64Data, base64Data) || other.base64Data == base64Data)&&(identical(other.metadata, metadata) || other.metadata == metadata)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,leadId,base64Data,metadata,orderIndex,createdAt,updatedAt);

@override
String toString() {
  return 'LeadImageEntity(id: $id, leadId: $leadId, base64Data: $base64Data, metadata: $metadata, orderIndex: $orderIndex, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $LeadImageEntityCopyWith<$Res>  {
  factory $LeadImageEntityCopyWith(LeadImageEntity value, $Res Function(LeadImageEntity) _then) = _$LeadImageEntityCopyWithImpl;
@useResult
$Res call({
 String id, String leadId,@Base64ImageDataConverter() Base64ImageData base64Data,@ImageMetadataConverter() ImageMetadata metadata, int orderIndex, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$LeadImageEntityCopyWithImpl<$Res>
    implements $LeadImageEntityCopyWith<$Res> {
  _$LeadImageEntityCopyWithImpl(this._self, this._then);

  final LeadImageEntity _self;
  final $Res Function(LeadImageEntity) _then;

/// Create a copy of LeadImageEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? leadId = null,Object? base64Data = null,Object? metadata = null,Object? orderIndex = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,leadId: null == leadId ? _self.leadId : leadId // ignore: cast_nullable_to_non_nullable
as String,base64Data: null == base64Data ? _self.base64Data : base64Data // ignore: cast_nullable_to_non_nullable
as Base64ImageData,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as ImageMetadata,orderIndex: null == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [LeadImageEntity].
extension LeadImageEntityPatterns on LeadImageEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeadImageEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeadImageEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeadImageEntity value)  $default,){
final _that = this;
switch (_that) {
case _LeadImageEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeadImageEntity value)?  $default,){
final _that = this;
switch (_that) {
case _LeadImageEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String leadId, @Base64ImageDataConverter()  Base64ImageData base64Data, @ImageMetadataConverter()  ImageMetadata metadata,  int orderIndex,  DateTime createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeadImageEntity() when $default != null:
return $default(_that.id,_that.leadId,_that.base64Data,_that.metadata,_that.orderIndex,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String leadId, @Base64ImageDataConverter()  Base64ImageData base64Data, @ImageMetadataConverter()  ImageMetadata metadata,  int orderIndex,  DateTime createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _LeadImageEntity():
return $default(_that.id,_that.leadId,_that.base64Data,_that.metadata,_that.orderIndex,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String leadId, @Base64ImageDataConverter()  Base64ImageData base64Data, @ImageMetadataConverter()  ImageMetadata metadata,  int orderIndex,  DateTime createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _LeadImageEntity() when $default != null:
return $default(_that.id,_that.leadId,_that.base64Data,_that.metadata,_that.orderIndex,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeadImageEntity extends LeadImageEntity {
  const _LeadImageEntity({required this.id, required this.leadId, @Base64ImageDataConverter() required this.base64Data, @ImageMetadataConverter() required this.metadata, required this.orderIndex, required this.createdAt, this.updatedAt}): super._();
  factory _LeadImageEntity.fromJson(Map<String, dynamic> json) => _$LeadImageEntityFromJson(json);

@override final  String id;
@override final  String leadId;
@override@Base64ImageDataConverter() final  Base64ImageData base64Data;
@override@ImageMetadataConverter() final  ImageMetadata metadata;
@override final  int orderIndex;
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of LeadImageEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeadImageEntityCopyWith<_LeadImageEntity> get copyWith => __$LeadImageEntityCopyWithImpl<_LeadImageEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeadImageEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeadImageEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.leadId, leadId) || other.leadId == leadId)&&(identical(other.base64Data, base64Data) || other.base64Data == base64Data)&&(identical(other.metadata, metadata) || other.metadata == metadata)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,leadId,base64Data,metadata,orderIndex,createdAt,updatedAt);

@override
String toString() {
  return 'LeadImageEntity(id: $id, leadId: $leadId, base64Data: $base64Data, metadata: $metadata, orderIndex: $orderIndex, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$LeadImageEntityCopyWith<$Res> implements $LeadImageEntityCopyWith<$Res> {
  factory _$LeadImageEntityCopyWith(_LeadImageEntity value, $Res Function(_LeadImageEntity) _then) = __$LeadImageEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String leadId,@Base64ImageDataConverter() Base64ImageData base64Data,@ImageMetadataConverter() ImageMetadata metadata, int orderIndex, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$LeadImageEntityCopyWithImpl<$Res>
    implements _$LeadImageEntityCopyWith<$Res> {
  __$LeadImageEntityCopyWithImpl(this._self, this._then);

  final _LeadImageEntity _self;
  final $Res Function(_LeadImageEntity) _then;

/// Create a copy of LeadImageEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? leadId = null,Object? base64Data = null,Object? metadata = null,Object? orderIndex = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_LeadImageEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,leadId: null == leadId ? _self.leadId : leadId // ignore: cast_nullable_to_non_nullable
as String,base64Data: null == base64Data ? _self.base64Data : base64Data // ignore: cast_nullable_to_non_nullable
as Base64ImageData,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as ImageMetadata,orderIndex: null == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

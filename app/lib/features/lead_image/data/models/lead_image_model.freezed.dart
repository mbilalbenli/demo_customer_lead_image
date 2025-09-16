// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lead_image_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeadImageModel {

 String get id; String get leadId; String get base64Data; String get fileName; String get contentType; int get sizeInBytes; int get orderIndex; DateTime get uploadedAt; DateTime get createdAt; DateTime? get updatedAt;
/// Create a copy of LeadImageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeadImageModelCopyWith<LeadImageModel> get copyWith => _$LeadImageModelCopyWithImpl<LeadImageModel>(this as LeadImageModel, _$identity);

  /// Serializes this LeadImageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeadImageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.leadId, leadId) || other.leadId == leadId)&&(identical(other.base64Data, base64Data) || other.base64Data == base64Data)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.sizeInBytes, sizeInBytes) || other.sizeInBytes == sizeInBytes)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex)&&(identical(other.uploadedAt, uploadedAt) || other.uploadedAt == uploadedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,leadId,base64Data,fileName,contentType,sizeInBytes,orderIndex,uploadedAt,createdAt,updatedAt);

@override
String toString() {
  return 'LeadImageModel(id: $id, leadId: $leadId, base64Data: $base64Data, fileName: $fileName, contentType: $contentType, sizeInBytes: $sizeInBytes, orderIndex: $orderIndex, uploadedAt: $uploadedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $LeadImageModelCopyWith<$Res>  {
  factory $LeadImageModelCopyWith(LeadImageModel value, $Res Function(LeadImageModel) _then) = _$LeadImageModelCopyWithImpl;
@useResult
$Res call({
 String id, String leadId, String base64Data, String fileName, String contentType, int sizeInBytes, int orderIndex, DateTime uploadedAt, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$LeadImageModelCopyWithImpl<$Res>
    implements $LeadImageModelCopyWith<$Res> {
  _$LeadImageModelCopyWithImpl(this._self, this._then);

  final LeadImageModel _self;
  final $Res Function(LeadImageModel) _then;

/// Create a copy of LeadImageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? leadId = null,Object? base64Data = null,Object? fileName = null,Object? contentType = null,Object? sizeInBytes = null,Object? orderIndex = null,Object? uploadedAt = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,leadId: null == leadId ? _self.leadId : leadId // ignore: cast_nullable_to_non_nullable
as String,base64Data: null == base64Data ? _self.base64Data : base64Data // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,sizeInBytes: null == sizeInBytes ? _self.sizeInBytes : sizeInBytes // ignore: cast_nullable_to_non_nullable
as int,orderIndex: null == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int,uploadedAt: null == uploadedAt ? _self.uploadedAt : uploadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [LeadImageModel].
extension LeadImageModelPatterns on LeadImageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeadImageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeadImageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeadImageModel value)  $default,){
final _that = this;
switch (_that) {
case _LeadImageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeadImageModel value)?  $default,){
final _that = this;
switch (_that) {
case _LeadImageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String leadId,  String base64Data,  String fileName,  String contentType,  int sizeInBytes,  int orderIndex,  DateTime uploadedAt,  DateTime createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeadImageModel() when $default != null:
return $default(_that.id,_that.leadId,_that.base64Data,_that.fileName,_that.contentType,_that.sizeInBytes,_that.orderIndex,_that.uploadedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String leadId,  String base64Data,  String fileName,  String contentType,  int sizeInBytes,  int orderIndex,  DateTime uploadedAt,  DateTime createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _LeadImageModel():
return $default(_that.id,_that.leadId,_that.base64Data,_that.fileName,_that.contentType,_that.sizeInBytes,_that.orderIndex,_that.uploadedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String leadId,  String base64Data,  String fileName,  String contentType,  int sizeInBytes,  int orderIndex,  DateTime uploadedAt,  DateTime createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _LeadImageModel() when $default != null:
return $default(_that.id,_that.leadId,_that.base64Data,_that.fileName,_that.contentType,_that.sizeInBytes,_that.orderIndex,_that.uploadedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeadImageModel extends LeadImageModel {
  const _LeadImageModel({required this.id, required this.leadId, required this.base64Data, required this.fileName, required this.contentType, required this.sizeInBytes, required this.orderIndex, required this.uploadedAt, required this.createdAt, this.updatedAt}): super._();
  factory _LeadImageModel.fromJson(Map<String, dynamic> json) => _$LeadImageModelFromJson(json);

@override final  String id;
@override final  String leadId;
@override final  String base64Data;
@override final  String fileName;
@override final  String contentType;
@override final  int sizeInBytes;
@override final  int orderIndex;
@override final  DateTime uploadedAt;
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of LeadImageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeadImageModelCopyWith<_LeadImageModel> get copyWith => __$LeadImageModelCopyWithImpl<_LeadImageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeadImageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeadImageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.leadId, leadId) || other.leadId == leadId)&&(identical(other.base64Data, base64Data) || other.base64Data == base64Data)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.sizeInBytes, sizeInBytes) || other.sizeInBytes == sizeInBytes)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex)&&(identical(other.uploadedAt, uploadedAt) || other.uploadedAt == uploadedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,leadId,base64Data,fileName,contentType,sizeInBytes,orderIndex,uploadedAt,createdAt,updatedAt);

@override
String toString() {
  return 'LeadImageModel(id: $id, leadId: $leadId, base64Data: $base64Data, fileName: $fileName, contentType: $contentType, sizeInBytes: $sizeInBytes, orderIndex: $orderIndex, uploadedAt: $uploadedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$LeadImageModelCopyWith<$Res> implements $LeadImageModelCopyWith<$Res> {
  factory _$LeadImageModelCopyWith(_LeadImageModel value, $Res Function(_LeadImageModel) _then) = __$LeadImageModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String leadId, String base64Data, String fileName, String contentType, int sizeInBytes, int orderIndex, DateTime uploadedAt, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$LeadImageModelCopyWithImpl<$Res>
    implements _$LeadImageModelCopyWith<$Res> {
  __$LeadImageModelCopyWithImpl(this._self, this._then);

  final _LeadImageModel _self;
  final $Res Function(_LeadImageModel) _then;

/// Create a copy of LeadImageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? leadId = null,Object? base64Data = null,Object? fileName = null,Object? contentType = null,Object? sizeInBytes = null,Object? orderIndex = null,Object? uploadedAt = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_LeadImageModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,leadId: null == leadId ? _self.leadId : leadId // ignore: cast_nullable_to_non_nullable
as String,base64Data: null == base64Data ? _self.base64Data : base64Data // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,sizeInBytes: null == sizeInBytes ? _self.sizeInBytes : sizeInBytes // ignore: cast_nullable_to_non_nullable
as int,orderIndex: null == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int,uploadedAt: null == uploadedAt ? _self.uploadedAt : uploadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lead_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeadModel {

 String get id;@JsonKey(name: 'name') String get customerName; String get email; String get phone; String get description; LeadStatus get status; int get imageCount; int get availableImageSlots; bool get canAddMoreImages; DateTime get createdAt; DateTime? get updatedAt;
/// Create a copy of LeadModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeadModelCopyWith<LeadModel> get copyWith => _$LeadModelCopyWithImpl<LeadModel>(this as LeadModel, _$identity);

  /// Serializes this LeadModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeadModel&&(identical(other.id, id) || other.id == id)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.imageCount, imageCount) || other.imageCount == imageCount)&&(identical(other.availableImageSlots, availableImageSlots) || other.availableImageSlots == availableImageSlots)&&(identical(other.canAddMoreImages, canAddMoreImages) || other.canAddMoreImages == canAddMoreImages)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerName,email,phone,description,status,imageCount,availableImageSlots,canAddMoreImages,createdAt,updatedAt);

@override
String toString() {
  return 'LeadModel(id: $id, customerName: $customerName, email: $email, phone: $phone, description: $description, status: $status, imageCount: $imageCount, availableImageSlots: $availableImageSlots, canAddMoreImages: $canAddMoreImages, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $LeadModelCopyWith<$Res>  {
  factory $LeadModelCopyWith(LeadModel value, $Res Function(LeadModel) _then) = _$LeadModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'name') String customerName, String email, String phone, String description, LeadStatus status, int imageCount, int availableImageSlots, bool canAddMoreImages, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$LeadModelCopyWithImpl<$Res>
    implements $LeadModelCopyWith<$Res> {
  _$LeadModelCopyWithImpl(this._self, this._then);

  final LeadModel _self;
  final $Res Function(LeadModel) _then;

/// Create a copy of LeadModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? customerName = null,Object? email = null,Object? phone = null,Object? description = null,Object? status = null,Object? imageCount = null,Object? availableImageSlots = null,Object? canAddMoreImages = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeadStatus,imageCount: null == imageCount ? _self.imageCount : imageCount // ignore: cast_nullable_to_non_nullable
as int,availableImageSlots: null == availableImageSlots ? _self.availableImageSlots : availableImageSlots // ignore: cast_nullable_to_non_nullable
as int,canAddMoreImages: null == canAddMoreImages ? _self.canAddMoreImages : canAddMoreImages // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [LeadModel].
extension LeadModelPatterns on LeadModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeadModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeadModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeadModel value)  $default,){
final _that = this;
switch (_that) {
case _LeadModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeadModel value)?  $default,){
final _that = this;
switch (_that) {
case _LeadModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'name')  String customerName,  String email,  String phone,  String description,  LeadStatus status,  int imageCount,  int availableImageSlots,  bool canAddMoreImages,  DateTime createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeadModel() when $default != null:
return $default(_that.id,_that.customerName,_that.email,_that.phone,_that.description,_that.status,_that.imageCount,_that.availableImageSlots,_that.canAddMoreImages,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'name')  String customerName,  String email,  String phone,  String description,  LeadStatus status,  int imageCount,  int availableImageSlots,  bool canAddMoreImages,  DateTime createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _LeadModel():
return $default(_that.id,_that.customerName,_that.email,_that.phone,_that.description,_that.status,_that.imageCount,_that.availableImageSlots,_that.canAddMoreImages,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'name')  String customerName,  String email,  String phone,  String description,  LeadStatus status,  int imageCount,  int availableImageSlots,  bool canAddMoreImages,  DateTime createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _LeadModel() when $default != null:
return $default(_that.id,_that.customerName,_that.email,_that.phone,_that.description,_that.status,_that.imageCount,_that.availableImageSlots,_that.canAddMoreImages,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeadModel extends LeadModel {
  const _LeadModel({required this.id, @JsonKey(name: 'name') required this.customerName, required this.email, required this.phone, this.description = '', required this.status, required this.imageCount, this.availableImageSlots = 10, this.canAddMoreImages = true, required this.createdAt, this.updatedAt}): super._();
  factory _LeadModel.fromJson(Map<String, dynamic> json) => _$LeadModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'name') final  String customerName;
@override final  String email;
@override final  String phone;
@override@JsonKey() final  String description;
@override final  LeadStatus status;
@override final  int imageCount;
@override@JsonKey() final  int availableImageSlots;
@override@JsonKey() final  bool canAddMoreImages;
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of LeadModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeadModelCopyWith<_LeadModel> get copyWith => __$LeadModelCopyWithImpl<_LeadModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeadModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeadModel&&(identical(other.id, id) || other.id == id)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.imageCount, imageCount) || other.imageCount == imageCount)&&(identical(other.availableImageSlots, availableImageSlots) || other.availableImageSlots == availableImageSlots)&&(identical(other.canAddMoreImages, canAddMoreImages) || other.canAddMoreImages == canAddMoreImages)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerName,email,phone,description,status,imageCount,availableImageSlots,canAddMoreImages,createdAt,updatedAt);

@override
String toString() {
  return 'LeadModel(id: $id, customerName: $customerName, email: $email, phone: $phone, description: $description, status: $status, imageCount: $imageCount, availableImageSlots: $availableImageSlots, canAddMoreImages: $canAddMoreImages, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$LeadModelCopyWith<$Res> implements $LeadModelCopyWith<$Res> {
  factory _$LeadModelCopyWith(_LeadModel value, $Res Function(_LeadModel) _then) = __$LeadModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'name') String customerName, String email, String phone, String description, LeadStatus status, int imageCount, int availableImageSlots, bool canAddMoreImages, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$LeadModelCopyWithImpl<$Res>
    implements _$LeadModelCopyWith<$Res> {
  __$LeadModelCopyWithImpl(this._self, this._then);

  final _LeadModel _self;
  final $Res Function(_LeadModel) _then;

/// Create a copy of LeadModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? customerName = null,Object? email = null,Object? phone = null,Object? description = null,Object? status = null,Object? imageCount = null,Object? availableImageSlots = null,Object? canAddMoreImages = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_LeadModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeadStatus,imageCount: null == imageCount ? _self.imageCount : imageCount // ignore: cast_nullable_to_non_nullable
as int,availableImageSlots: null == availableImageSlots ? _self.availableImageSlots : availableImageSlots // ignore: cast_nullable_to_non_nullable
as int,canAddMoreImages: null == canAddMoreImages ? _self.canAddMoreImages : canAddMoreImages // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

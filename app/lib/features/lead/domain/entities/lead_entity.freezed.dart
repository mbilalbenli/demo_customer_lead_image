// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lead_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeadEntity {

 String get id;@CustomerNameConverter() CustomerName get customerName;@EmailAddressConverter() EmailAddress get email;@PhoneNumberConverter() PhoneNumber get phone; String get description; LeadStatus get status; int get imageCount; DateTime get createdAt; DateTime? get updatedAt;
/// Create a copy of LeadEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeadEntityCopyWith<LeadEntity> get copyWith => _$LeadEntityCopyWithImpl<LeadEntity>(this as LeadEntity, _$identity);

  /// Serializes this LeadEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeadEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.imageCount, imageCount) || other.imageCount == imageCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerName,email,phone,description,status,imageCount,createdAt,updatedAt);

@override
String toString() {
  return 'LeadEntity(id: $id, customerName: $customerName, email: $email, phone: $phone, description: $description, status: $status, imageCount: $imageCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $LeadEntityCopyWith<$Res>  {
  factory $LeadEntityCopyWith(LeadEntity value, $Res Function(LeadEntity) _then) = _$LeadEntityCopyWithImpl;
@useResult
$Res call({
 String id,@CustomerNameConverter() CustomerName customerName,@EmailAddressConverter() EmailAddress email,@PhoneNumberConverter() PhoneNumber phone, String description, LeadStatus status, int imageCount, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$LeadEntityCopyWithImpl<$Res>
    implements $LeadEntityCopyWith<$Res> {
  _$LeadEntityCopyWithImpl(this._self, this._then);

  final LeadEntity _self;
  final $Res Function(LeadEntity) _then;

/// Create a copy of LeadEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? customerName = null,Object? email = null,Object? phone = null,Object? description = null,Object? status = null,Object? imageCount = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as CustomerName,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as EmailAddress,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as PhoneNumber,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeadStatus,imageCount: null == imageCount ? _self.imageCount : imageCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [LeadEntity].
extension LeadEntityPatterns on LeadEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeadEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeadEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeadEntity value)  $default,){
final _that = this;
switch (_that) {
case _LeadEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeadEntity value)?  $default,){
final _that = this;
switch (_that) {
case _LeadEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @CustomerNameConverter()  CustomerName customerName, @EmailAddressConverter()  EmailAddress email, @PhoneNumberConverter()  PhoneNumber phone,  String description,  LeadStatus status,  int imageCount,  DateTime createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeadEntity() when $default != null:
return $default(_that.id,_that.customerName,_that.email,_that.phone,_that.description,_that.status,_that.imageCount,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @CustomerNameConverter()  CustomerName customerName, @EmailAddressConverter()  EmailAddress email, @PhoneNumberConverter()  PhoneNumber phone,  String description,  LeadStatus status,  int imageCount,  DateTime createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _LeadEntity():
return $default(_that.id,_that.customerName,_that.email,_that.phone,_that.description,_that.status,_that.imageCount,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @CustomerNameConverter()  CustomerName customerName, @EmailAddressConverter()  EmailAddress email, @PhoneNumberConverter()  PhoneNumber phone,  String description,  LeadStatus status,  int imageCount,  DateTime createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _LeadEntity() when $default != null:
return $default(_that.id,_that.customerName,_that.email,_that.phone,_that.description,_that.status,_that.imageCount,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeadEntity extends LeadEntity {
  const _LeadEntity({required this.id, @CustomerNameConverter() required this.customerName, @EmailAddressConverter() required this.email, @PhoneNumberConverter() required this.phone, required this.description, required this.status, required this.imageCount, required this.createdAt, this.updatedAt}): super._();
  factory _LeadEntity.fromJson(Map<String, dynamic> json) => _$LeadEntityFromJson(json);

@override final  String id;
@override@CustomerNameConverter() final  CustomerName customerName;
@override@EmailAddressConverter() final  EmailAddress email;
@override@PhoneNumberConverter() final  PhoneNumber phone;
@override final  String description;
@override final  LeadStatus status;
@override final  int imageCount;
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of LeadEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeadEntityCopyWith<_LeadEntity> get copyWith => __$LeadEntityCopyWithImpl<_LeadEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeadEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeadEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.imageCount, imageCount) || other.imageCount == imageCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerName,email,phone,description,status,imageCount,createdAt,updatedAt);

@override
String toString() {
  return 'LeadEntity(id: $id, customerName: $customerName, email: $email, phone: $phone, description: $description, status: $status, imageCount: $imageCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$LeadEntityCopyWith<$Res> implements $LeadEntityCopyWith<$Res> {
  factory _$LeadEntityCopyWith(_LeadEntity value, $Res Function(_LeadEntity) _then) = __$LeadEntityCopyWithImpl;
@override @useResult
$Res call({
 String id,@CustomerNameConverter() CustomerName customerName,@EmailAddressConverter() EmailAddress email,@PhoneNumberConverter() PhoneNumber phone, String description, LeadStatus status, int imageCount, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$LeadEntityCopyWithImpl<$Res>
    implements _$LeadEntityCopyWith<$Res> {
  __$LeadEntityCopyWithImpl(this._self, this._then);

  final _LeadEntity _self;
  final $Res Function(_LeadEntity) _then;

/// Create a copy of LeadEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? customerName = null,Object? email = null,Object? phone = null,Object? description = null,Object? status = null,Object? imageCount = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_LeadEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as CustomerName,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as EmailAddress,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as PhoneNumber,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeadStatus,imageCount: null == imageCount ? _self.imageCount : imageCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lead_edit_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LeadEditState {

 CoreState get core; LeadEntity? get originalLead; String get name; String get email; String get phone; String get company; String get notes; LeadStatus? get status; bool get isFormValid; bool get hasChanges;
/// Create a copy of LeadEditState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeadEditStateCopyWith<LeadEditState> get copyWith => _$LeadEditStateCopyWithImpl<LeadEditState>(this as LeadEditState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeadEditState&&(identical(other.core, core) || other.core == core)&&(identical(other.originalLead, originalLead) || other.originalLead == originalLead)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.company, company) || other.company == company)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.status, status) || other.status == status)&&(identical(other.isFormValid, isFormValid) || other.isFormValid == isFormValid)&&(identical(other.hasChanges, hasChanges) || other.hasChanges == hasChanges));
}


@override
int get hashCode => Object.hash(runtimeType,core,originalLead,name,email,phone,company,notes,status,isFormValid,hasChanges);

@override
String toString() {
  return 'LeadEditState(core: $core, originalLead: $originalLead, name: $name, email: $email, phone: $phone, company: $company, notes: $notes, status: $status, isFormValid: $isFormValid, hasChanges: $hasChanges)';
}


}

/// @nodoc
abstract mixin class $LeadEditStateCopyWith<$Res>  {
  factory $LeadEditStateCopyWith(LeadEditState value, $Res Function(LeadEditState) _then) = _$LeadEditStateCopyWithImpl;
@useResult
$Res call({
 CoreState core, LeadEntity? originalLead, String name, String email, String phone, String company, String notes, LeadStatus? status, bool isFormValid, bool hasChanges
});


$CoreStateCopyWith<$Res> get core;$LeadEntityCopyWith<$Res>? get originalLead;

}
/// @nodoc
class _$LeadEditStateCopyWithImpl<$Res>
    implements $LeadEditStateCopyWith<$Res> {
  _$LeadEditStateCopyWithImpl(this._self, this._then);

  final LeadEditState _self;
  final $Res Function(LeadEditState) _then;

/// Create a copy of LeadEditState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? core = null,Object? originalLead = freezed,Object? name = null,Object? email = null,Object? phone = null,Object? company = null,Object? notes = null,Object? status = freezed,Object? isFormValid = null,Object? hasChanges = null,}) {
  return _then(_self.copyWith(
core: null == core ? _self.core : core // ignore: cast_nullable_to_non_nullable
as CoreState,originalLead: freezed == originalLead ? _self.originalLead : originalLead // ignore: cast_nullable_to_non_nullable
as LeadEntity?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeadStatus?,isFormValid: null == isFormValid ? _self.isFormValid : isFormValid // ignore: cast_nullable_to_non_nullable
as bool,hasChanges: null == hasChanges ? _self.hasChanges : hasChanges // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of LeadEditState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoreStateCopyWith<$Res> get core {
  
  return $CoreStateCopyWith<$Res>(_self.core, (value) {
    return _then(_self.copyWith(core: value));
  });
}/// Create a copy of LeadEditState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeadEntityCopyWith<$Res>? get originalLead {
    if (_self.originalLead == null) {
    return null;
  }

  return $LeadEntityCopyWith<$Res>(_self.originalLead!, (value) {
    return _then(_self.copyWith(originalLead: value));
  });
}
}


/// Adds pattern-matching-related methods to [LeadEditState].
extension LeadEditStatePatterns on LeadEditState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeadEditState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeadEditState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeadEditState value)  $default,){
final _that = this;
switch (_that) {
case _LeadEditState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeadEditState value)?  $default,){
final _that = this;
switch (_that) {
case _LeadEditState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CoreState core,  LeadEntity? originalLead,  String name,  String email,  String phone,  String company,  String notes,  LeadStatus? status,  bool isFormValid,  bool hasChanges)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeadEditState() when $default != null:
return $default(_that.core,_that.originalLead,_that.name,_that.email,_that.phone,_that.company,_that.notes,_that.status,_that.isFormValid,_that.hasChanges);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CoreState core,  LeadEntity? originalLead,  String name,  String email,  String phone,  String company,  String notes,  LeadStatus? status,  bool isFormValid,  bool hasChanges)  $default,) {final _that = this;
switch (_that) {
case _LeadEditState():
return $default(_that.core,_that.originalLead,_that.name,_that.email,_that.phone,_that.company,_that.notes,_that.status,_that.isFormValid,_that.hasChanges);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CoreState core,  LeadEntity? originalLead,  String name,  String email,  String phone,  String company,  String notes,  LeadStatus? status,  bool isFormValid,  bool hasChanges)?  $default,) {final _that = this;
switch (_that) {
case _LeadEditState() when $default != null:
return $default(_that.core,_that.originalLead,_that.name,_that.email,_that.phone,_that.company,_that.notes,_that.status,_that.isFormValid,_that.hasChanges);case _:
  return null;

}
}

}

/// @nodoc


class _LeadEditState extends LeadEditState {
  const _LeadEditState({this.core = const CoreState(), this.originalLead, this.name = '', this.email = '', this.phone = '', this.company = '', this.notes = '', this.status, this.isFormValid = false, this.hasChanges = false}): super._();
  

@override@JsonKey() final  CoreState core;
@override final  LeadEntity? originalLead;
@override@JsonKey() final  String name;
@override@JsonKey() final  String email;
@override@JsonKey() final  String phone;
@override@JsonKey() final  String company;
@override@JsonKey() final  String notes;
@override final  LeadStatus? status;
@override@JsonKey() final  bool isFormValid;
@override@JsonKey() final  bool hasChanges;

/// Create a copy of LeadEditState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeadEditStateCopyWith<_LeadEditState> get copyWith => __$LeadEditStateCopyWithImpl<_LeadEditState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeadEditState&&(identical(other.core, core) || other.core == core)&&(identical(other.originalLead, originalLead) || other.originalLead == originalLead)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.company, company) || other.company == company)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.status, status) || other.status == status)&&(identical(other.isFormValid, isFormValid) || other.isFormValid == isFormValid)&&(identical(other.hasChanges, hasChanges) || other.hasChanges == hasChanges));
}


@override
int get hashCode => Object.hash(runtimeType,core,originalLead,name,email,phone,company,notes,status,isFormValid,hasChanges);

@override
String toString() {
  return 'LeadEditState(core: $core, originalLead: $originalLead, name: $name, email: $email, phone: $phone, company: $company, notes: $notes, status: $status, isFormValid: $isFormValid, hasChanges: $hasChanges)';
}


}

/// @nodoc
abstract mixin class _$LeadEditStateCopyWith<$Res> implements $LeadEditStateCopyWith<$Res> {
  factory _$LeadEditStateCopyWith(_LeadEditState value, $Res Function(_LeadEditState) _then) = __$LeadEditStateCopyWithImpl;
@override @useResult
$Res call({
 CoreState core, LeadEntity? originalLead, String name, String email, String phone, String company, String notes, LeadStatus? status, bool isFormValid, bool hasChanges
});


@override $CoreStateCopyWith<$Res> get core;@override $LeadEntityCopyWith<$Res>? get originalLead;

}
/// @nodoc
class __$LeadEditStateCopyWithImpl<$Res>
    implements _$LeadEditStateCopyWith<$Res> {
  __$LeadEditStateCopyWithImpl(this._self, this._then);

  final _LeadEditState _self;
  final $Res Function(_LeadEditState) _then;

/// Create a copy of LeadEditState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? core = null,Object? originalLead = freezed,Object? name = null,Object? email = null,Object? phone = null,Object? company = null,Object? notes = null,Object? status = freezed,Object? isFormValid = null,Object? hasChanges = null,}) {
  return _then(_LeadEditState(
core: null == core ? _self.core : core // ignore: cast_nullable_to_non_nullable
as CoreState,originalLead: freezed == originalLead ? _self.originalLead : originalLead // ignore: cast_nullable_to_non_nullable
as LeadEntity?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeadStatus?,isFormValid: null == isFormValid ? _self.isFormValid : isFormValid // ignore: cast_nullable_to_non_nullable
as bool,hasChanges: null == hasChanges ? _self.hasChanges : hasChanges // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of LeadEditState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoreStateCopyWith<$Res> get core {
  
  return $CoreStateCopyWith<$Res>(_self.core, (value) {
    return _then(_self.copyWith(core: value));
  });
}/// Create a copy of LeadEditState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeadEntityCopyWith<$Res>? get originalLead {
    if (_self.originalLead == null) {
    return null;
  }

  return $LeadEntityCopyWith<$Res>(_self.originalLead!, (value) {
    return _then(_self.copyWith(originalLead: value));
  });
}
}

// dart format on

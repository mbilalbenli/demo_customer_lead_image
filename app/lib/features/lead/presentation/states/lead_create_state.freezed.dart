// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lead_create_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LeadCreateState {

 CoreState get core; String get name; String get email; String get phone; String get company; String get notes; LeadStatus get status; bool get isFormValid; bool get hasChanges; bool get leadCreatedSuccessfully; String? get errorMessage;
/// Create a copy of LeadCreateState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeadCreateStateCopyWith<LeadCreateState> get copyWith => _$LeadCreateStateCopyWithImpl<LeadCreateState>(this as LeadCreateState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeadCreateState&&(identical(other.core, core) || other.core == core)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.company, company) || other.company == company)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.status, status) || other.status == status)&&(identical(other.isFormValid, isFormValid) || other.isFormValid == isFormValid)&&(identical(other.hasChanges, hasChanges) || other.hasChanges == hasChanges)&&(identical(other.leadCreatedSuccessfully, leadCreatedSuccessfully) || other.leadCreatedSuccessfully == leadCreatedSuccessfully)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,core,name,email,phone,company,notes,status,isFormValid,hasChanges,leadCreatedSuccessfully,errorMessage);

@override
String toString() {
  return 'LeadCreateState(core: $core, name: $name, email: $email, phone: $phone, company: $company, notes: $notes, status: $status, isFormValid: $isFormValid, hasChanges: $hasChanges, leadCreatedSuccessfully: $leadCreatedSuccessfully, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $LeadCreateStateCopyWith<$Res>  {
  factory $LeadCreateStateCopyWith(LeadCreateState value, $Res Function(LeadCreateState) _then) = _$LeadCreateStateCopyWithImpl;
@useResult
$Res call({
 CoreState core, String name, String email, String phone, String company, String notes, LeadStatus status, bool isFormValid, bool hasChanges, bool leadCreatedSuccessfully, String? errorMessage
});


$CoreStateCopyWith<$Res> get core;

}
/// @nodoc
class _$LeadCreateStateCopyWithImpl<$Res>
    implements $LeadCreateStateCopyWith<$Res> {
  _$LeadCreateStateCopyWithImpl(this._self, this._then);

  final LeadCreateState _self;
  final $Res Function(LeadCreateState) _then;

/// Create a copy of LeadCreateState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? core = null,Object? name = null,Object? email = null,Object? phone = null,Object? company = null,Object? notes = null,Object? status = null,Object? isFormValid = null,Object? hasChanges = null,Object? leadCreatedSuccessfully = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
core: null == core ? _self.core : core // ignore: cast_nullable_to_non_nullable
as CoreState,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeadStatus,isFormValid: null == isFormValid ? _self.isFormValid : isFormValid // ignore: cast_nullable_to_non_nullable
as bool,hasChanges: null == hasChanges ? _self.hasChanges : hasChanges // ignore: cast_nullable_to_non_nullable
as bool,leadCreatedSuccessfully: null == leadCreatedSuccessfully ? _self.leadCreatedSuccessfully : leadCreatedSuccessfully // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of LeadCreateState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoreStateCopyWith<$Res> get core {
  
  return $CoreStateCopyWith<$Res>(_self.core, (value) {
    return _then(_self.copyWith(core: value));
  });
}
}


/// Adds pattern-matching-related methods to [LeadCreateState].
extension LeadCreateStatePatterns on LeadCreateState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeadCreateState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeadCreateState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeadCreateState value)  $default,){
final _that = this;
switch (_that) {
case _LeadCreateState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeadCreateState value)?  $default,){
final _that = this;
switch (_that) {
case _LeadCreateState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CoreState core,  String name,  String email,  String phone,  String company,  String notes,  LeadStatus status,  bool isFormValid,  bool hasChanges,  bool leadCreatedSuccessfully,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeadCreateState() when $default != null:
return $default(_that.core,_that.name,_that.email,_that.phone,_that.company,_that.notes,_that.status,_that.isFormValid,_that.hasChanges,_that.leadCreatedSuccessfully,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CoreState core,  String name,  String email,  String phone,  String company,  String notes,  LeadStatus status,  bool isFormValid,  bool hasChanges,  bool leadCreatedSuccessfully,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _LeadCreateState():
return $default(_that.core,_that.name,_that.email,_that.phone,_that.company,_that.notes,_that.status,_that.isFormValid,_that.hasChanges,_that.leadCreatedSuccessfully,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CoreState core,  String name,  String email,  String phone,  String company,  String notes,  LeadStatus status,  bool isFormValid,  bool hasChanges,  bool leadCreatedSuccessfully,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _LeadCreateState() when $default != null:
return $default(_that.core,_that.name,_that.email,_that.phone,_that.company,_that.notes,_that.status,_that.isFormValid,_that.hasChanges,_that.leadCreatedSuccessfully,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _LeadCreateState extends LeadCreateState {
  const _LeadCreateState({this.core = const CoreState(), this.name = '', this.email = '', this.phone = '', this.company = '', this.notes = '', this.status = LeadStatus.newLead, this.isFormValid = false, this.hasChanges = false, this.leadCreatedSuccessfully = false, this.errorMessage}): super._();
  

@override@JsonKey() final  CoreState core;
@override@JsonKey() final  String name;
@override@JsonKey() final  String email;
@override@JsonKey() final  String phone;
@override@JsonKey() final  String company;
@override@JsonKey() final  String notes;
@override@JsonKey() final  LeadStatus status;
@override@JsonKey() final  bool isFormValid;
@override@JsonKey() final  bool hasChanges;
@override@JsonKey() final  bool leadCreatedSuccessfully;
@override final  String? errorMessage;

/// Create a copy of LeadCreateState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeadCreateStateCopyWith<_LeadCreateState> get copyWith => __$LeadCreateStateCopyWithImpl<_LeadCreateState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeadCreateState&&(identical(other.core, core) || other.core == core)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.company, company) || other.company == company)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.status, status) || other.status == status)&&(identical(other.isFormValid, isFormValid) || other.isFormValid == isFormValid)&&(identical(other.hasChanges, hasChanges) || other.hasChanges == hasChanges)&&(identical(other.leadCreatedSuccessfully, leadCreatedSuccessfully) || other.leadCreatedSuccessfully == leadCreatedSuccessfully)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,core,name,email,phone,company,notes,status,isFormValid,hasChanges,leadCreatedSuccessfully,errorMessage);

@override
String toString() {
  return 'LeadCreateState(core: $core, name: $name, email: $email, phone: $phone, company: $company, notes: $notes, status: $status, isFormValid: $isFormValid, hasChanges: $hasChanges, leadCreatedSuccessfully: $leadCreatedSuccessfully, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$LeadCreateStateCopyWith<$Res> implements $LeadCreateStateCopyWith<$Res> {
  factory _$LeadCreateStateCopyWith(_LeadCreateState value, $Res Function(_LeadCreateState) _then) = __$LeadCreateStateCopyWithImpl;
@override @useResult
$Res call({
 CoreState core, String name, String email, String phone, String company, String notes, LeadStatus status, bool isFormValid, bool hasChanges, bool leadCreatedSuccessfully, String? errorMessage
});


@override $CoreStateCopyWith<$Res> get core;

}
/// @nodoc
class __$LeadCreateStateCopyWithImpl<$Res>
    implements _$LeadCreateStateCopyWith<$Res> {
  __$LeadCreateStateCopyWithImpl(this._self, this._then);

  final _LeadCreateState _self;
  final $Res Function(_LeadCreateState) _then;

/// Create a copy of LeadCreateState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? core = null,Object? name = null,Object? email = null,Object? phone = null,Object? company = null,Object? notes = null,Object? status = null,Object? isFormValid = null,Object? hasChanges = null,Object? leadCreatedSuccessfully = null,Object? errorMessage = freezed,}) {
  return _then(_LeadCreateState(
core: null == core ? _self.core : core // ignore: cast_nullable_to_non_nullable
as CoreState,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeadStatus,isFormValid: null == isFormValid ? _self.isFormValid : isFormValid // ignore: cast_nullable_to_non_nullable
as bool,hasChanges: null == hasChanges ? _self.hasChanges : hasChanges // ignore: cast_nullable_to_non_nullable
as bool,leadCreatedSuccessfully: null == leadCreatedSuccessfully ? _self.leadCreatedSuccessfully : leadCreatedSuccessfully // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of LeadCreateState
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

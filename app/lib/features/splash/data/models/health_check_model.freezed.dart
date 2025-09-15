// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_check_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HealthCheckModel {

 String get status; String? get version; String? get totalDuration; Map<String, dynamic>? get results;
/// Create a copy of HealthCheckModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthCheckModelCopyWith<HealthCheckModel> get copyWith => _$HealthCheckModelCopyWithImpl<HealthCheckModel>(this as HealthCheckModel, _$identity);

  /// Serializes this HealthCheckModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthCheckModel&&(identical(other.status, status) || other.status == status)&&(identical(other.version, version) || other.version == version)&&(identical(other.totalDuration, totalDuration) || other.totalDuration == totalDuration)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,version,totalDuration,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'HealthCheckModel(status: $status, version: $version, totalDuration: $totalDuration, results: $results)';
}


}

/// @nodoc
abstract mixin class $HealthCheckModelCopyWith<$Res>  {
  factory $HealthCheckModelCopyWith(HealthCheckModel value, $Res Function(HealthCheckModel) _then) = _$HealthCheckModelCopyWithImpl;
@useResult
$Res call({
 String status, String? version, String? totalDuration, Map<String, dynamic>? results
});




}
/// @nodoc
class _$HealthCheckModelCopyWithImpl<$Res>
    implements $HealthCheckModelCopyWith<$Res> {
  _$HealthCheckModelCopyWithImpl(this._self, this._then);

  final HealthCheckModel _self;
  final $Res Function(HealthCheckModel) _then;

/// Create a copy of HealthCheckModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? version = freezed,Object? totalDuration = freezed,Object? results = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,totalDuration: freezed == totalDuration ? _self.totalDuration : totalDuration // ignore: cast_nullable_to_non_nullable
as String?,results: freezed == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthCheckModel].
extension HealthCheckModelPatterns on HealthCheckModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthCheckModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthCheckModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthCheckModel value)  $default,){
final _that = this;
switch (_that) {
case _HealthCheckModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthCheckModel value)?  $default,){
final _that = this;
switch (_that) {
case _HealthCheckModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status,  String? version,  String? totalDuration,  Map<String, dynamic>? results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthCheckModel() when $default != null:
return $default(_that.status,_that.version,_that.totalDuration,_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status,  String? version,  String? totalDuration,  Map<String, dynamic>? results)  $default,) {final _that = this;
switch (_that) {
case _HealthCheckModel():
return $default(_that.status,_that.version,_that.totalDuration,_that.results);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status,  String? version,  String? totalDuration,  Map<String, dynamic>? results)?  $default,) {final _that = this;
switch (_that) {
case _HealthCheckModel() when $default != null:
return $default(_that.status,_that.version,_that.totalDuration,_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthCheckModel implements HealthCheckModel {
  const _HealthCheckModel({required this.status, this.version, this.totalDuration, final  Map<String, dynamic>? results}): _results = results;
  factory _HealthCheckModel.fromJson(Map<String, dynamic> json) => _$HealthCheckModelFromJson(json);

@override final  String status;
@override final  String? version;
@override final  String? totalDuration;
 final  Map<String, dynamic>? _results;
@override Map<String, dynamic>? get results {
  final value = _results;
  if (value == null) return null;
  if (_results is EqualUnmodifiableMapView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of HealthCheckModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthCheckModelCopyWith<_HealthCheckModel> get copyWith => __$HealthCheckModelCopyWithImpl<_HealthCheckModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthCheckModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthCheckModel&&(identical(other.status, status) || other.status == status)&&(identical(other.version, version) || other.version == version)&&(identical(other.totalDuration, totalDuration) || other.totalDuration == totalDuration)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,version,totalDuration,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'HealthCheckModel(status: $status, version: $version, totalDuration: $totalDuration, results: $results)';
}


}

/// @nodoc
abstract mixin class _$HealthCheckModelCopyWith<$Res> implements $HealthCheckModelCopyWith<$Res> {
  factory _$HealthCheckModelCopyWith(_HealthCheckModel value, $Res Function(_HealthCheckModel) _then) = __$HealthCheckModelCopyWithImpl;
@override @useResult
$Res call({
 String status, String? version, String? totalDuration, Map<String, dynamic>? results
});




}
/// @nodoc
class __$HealthCheckModelCopyWithImpl<$Res>
    implements _$HealthCheckModelCopyWith<$Res> {
  __$HealthCheckModelCopyWithImpl(this._self, this._then);

  final _HealthCheckModel _self;
  final $Res Function(_HealthCheckModel) _then;

/// Create a copy of HealthCheckModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? version = freezed,Object? totalDuration = freezed,Object? results = freezed,}) {
  return _then(_HealthCheckModel(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,totalDuration: freezed == totalDuration ? _self.totalDuration : totalDuration // ignore: cast_nullable_to_non_nullable
as String?,results: freezed == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on

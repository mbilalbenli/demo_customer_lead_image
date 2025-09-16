// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lead_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LeadListState {

 CoreState get core; List<LeadEntity> get leads; bool get isLoadingMore; int get currentPage; bool get hasMorePages; String? get errorMessage; String? get searchQuery;
/// Create a copy of LeadListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeadListStateCopyWith<LeadListState> get copyWith => _$LeadListStateCopyWithImpl<LeadListState>(this as LeadListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeadListState&&(identical(other.core, core) || other.core == core)&&const DeepCollectionEquality().equals(other.leads, leads)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.hasMorePages, hasMorePages) || other.hasMorePages == hasMorePages)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}


@override
int get hashCode => Object.hash(runtimeType,core,const DeepCollectionEquality().hash(leads),isLoadingMore,currentPage,hasMorePages,errorMessage,searchQuery);

@override
String toString() {
  return 'LeadListState(core: $core, leads: $leads, isLoadingMore: $isLoadingMore, currentPage: $currentPage, hasMorePages: $hasMorePages, errorMessage: $errorMessage, searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class $LeadListStateCopyWith<$Res>  {
  factory $LeadListStateCopyWith(LeadListState value, $Res Function(LeadListState) _then) = _$LeadListStateCopyWithImpl;
@useResult
$Res call({
 CoreState core, List<LeadEntity> leads, bool isLoadingMore, int currentPage, bool hasMorePages, String? errorMessage, String? searchQuery
});


$CoreStateCopyWith<$Res> get core;

}
/// @nodoc
class _$LeadListStateCopyWithImpl<$Res>
    implements $LeadListStateCopyWith<$Res> {
  _$LeadListStateCopyWithImpl(this._self, this._then);

  final LeadListState _self;
  final $Res Function(LeadListState) _then;

/// Create a copy of LeadListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? core = null,Object? leads = null,Object? isLoadingMore = null,Object? currentPage = null,Object? hasMorePages = null,Object? errorMessage = freezed,Object? searchQuery = freezed,}) {
  return _then(_self.copyWith(
core: null == core ? _self.core : core // ignore: cast_nullable_to_non_nullable
as CoreState,leads: null == leads ? _self.leads : leads // ignore: cast_nullable_to_non_nullable
as List<LeadEntity>,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,hasMorePages: null == hasMorePages ? _self.hasMorePages : hasMorePages // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,searchQuery: freezed == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of LeadListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoreStateCopyWith<$Res> get core {
  
  return $CoreStateCopyWith<$Res>(_self.core, (value) {
    return _then(_self.copyWith(core: value));
  });
}
}


/// Adds pattern-matching-related methods to [LeadListState].
extension LeadListStatePatterns on LeadListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeadListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeadListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeadListState value)  $default,){
final _that = this;
switch (_that) {
case _LeadListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeadListState value)?  $default,){
final _that = this;
switch (_that) {
case _LeadListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CoreState core,  List<LeadEntity> leads,  bool isLoadingMore,  int currentPage,  bool hasMorePages,  String? errorMessage,  String? searchQuery)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeadListState() when $default != null:
return $default(_that.core,_that.leads,_that.isLoadingMore,_that.currentPage,_that.hasMorePages,_that.errorMessage,_that.searchQuery);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CoreState core,  List<LeadEntity> leads,  bool isLoadingMore,  int currentPage,  bool hasMorePages,  String? errorMessage,  String? searchQuery)  $default,) {final _that = this;
switch (_that) {
case _LeadListState():
return $default(_that.core,_that.leads,_that.isLoadingMore,_that.currentPage,_that.hasMorePages,_that.errorMessage,_that.searchQuery);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CoreState core,  List<LeadEntity> leads,  bool isLoadingMore,  int currentPage,  bool hasMorePages,  String? errorMessage,  String? searchQuery)?  $default,) {final _that = this;
switch (_that) {
case _LeadListState() when $default != null:
return $default(_that.core,_that.leads,_that.isLoadingMore,_that.currentPage,_that.hasMorePages,_that.errorMessage,_that.searchQuery);case _:
  return null;

}
}

}

/// @nodoc


class _LeadListState extends LeadListState {
  const _LeadListState({this.core = const CoreState(), final  List<LeadEntity> leads = const [], this.isLoadingMore = false, this.currentPage = 1, this.hasMorePages = false, this.errorMessage, this.searchQuery}): _leads = leads,super._();
  

@override@JsonKey() final  CoreState core;
 final  List<LeadEntity> _leads;
@override@JsonKey() List<LeadEntity> get leads {
  if (_leads is EqualUnmodifiableListView) return _leads;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_leads);
}

@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  int currentPage;
@override@JsonKey() final  bool hasMorePages;
@override final  String? errorMessage;
@override final  String? searchQuery;

/// Create a copy of LeadListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeadListStateCopyWith<_LeadListState> get copyWith => __$LeadListStateCopyWithImpl<_LeadListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeadListState&&(identical(other.core, core) || other.core == core)&&const DeepCollectionEquality().equals(other._leads, _leads)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.hasMorePages, hasMorePages) || other.hasMorePages == hasMorePages)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}


@override
int get hashCode => Object.hash(runtimeType,core,const DeepCollectionEquality().hash(_leads),isLoadingMore,currentPage,hasMorePages,errorMessage,searchQuery);

@override
String toString() {
  return 'LeadListState(core: $core, leads: $leads, isLoadingMore: $isLoadingMore, currentPage: $currentPage, hasMorePages: $hasMorePages, errorMessage: $errorMessage, searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class _$LeadListStateCopyWith<$Res> implements $LeadListStateCopyWith<$Res> {
  factory _$LeadListStateCopyWith(_LeadListState value, $Res Function(_LeadListState) _then) = __$LeadListStateCopyWithImpl;
@override @useResult
$Res call({
 CoreState core, List<LeadEntity> leads, bool isLoadingMore, int currentPage, bool hasMorePages, String? errorMessage, String? searchQuery
});


@override $CoreStateCopyWith<$Res> get core;

}
/// @nodoc
class __$LeadListStateCopyWithImpl<$Res>
    implements _$LeadListStateCopyWith<$Res> {
  __$LeadListStateCopyWithImpl(this._self, this._then);

  final _LeadListState _self;
  final $Res Function(_LeadListState) _then;

/// Create a copy of LeadListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? core = null,Object? leads = null,Object? isLoadingMore = null,Object? currentPage = null,Object? hasMorePages = null,Object? errorMessage = freezed,Object? searchQuery = freezed,}) {
  return _then(_LeadListState(
core: null == core ? _self.core : core // ignore: cast_nullable_to_non_nullable
as CoreState,leads: null == leads ? _self._leads : leads // ignore: cast_nullable_to_non_nullable
as List<LeadEntity>,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,hasMorePages: null == hasMorePages ? _self.hasMorePages : hasMorePages // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,searchQuery: freezed == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of LeadListState
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

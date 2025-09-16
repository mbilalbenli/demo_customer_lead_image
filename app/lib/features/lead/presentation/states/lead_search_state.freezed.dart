// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lead_search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LeadSearchState {

 CoreState get core; String get searchQuery; List<LeadEntity> get results; List<LeadEntity> get searchResults; List<String> get filters; List<String> get activeFilters; List<String> get availableFilters; bool get isSearching; bool get isLoadingMore; bool get hasSearched; String? get errorMessage;
/// Create a copy of LeadSearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeadSearchStateCopyWith<LeadSearchState> get copyWith => _$LeadSearchStateCopyWithImpl<LeadSearchState>(this as LeadSearchState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeadSearchState&&(identical(other.core, core) || other.core == core)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&const DeepCollectionEquality().equals(other.results, results)&&const DeepCollectionEquality().equals(other.searchResults, searchResults)&&const DeepCollectionEquality().equals(other.filters, filters)&&const DeepCollectionEquality().equals(other.activeFilters, activeFilters)&&const DeepCollectionEquality().equals(other.availableFilters, availableFilters)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasSearched, hasSearched) || other.hasSearched == hasSearched)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,core,searchQuery,const DeepCollectionEquality().hash(results),const DeepCollectionEquality().hash(searchResults),const DeepCollectionEquality().hash(filters),const DeepCollectionEquality().hash(activeFilters),const DeepCollectionEquality().hash(availableFilters),isSearching,isLoadingMore,hasSearched,errorMessage);

@override
String toString() {
  return 'LeadSearchState(core: $core, searchQuery: $searchQuery, results: $results, searchResults: $searchResults, filters: $filters, activeFilters: $activeFilters, availableFilters: $availableFilters, isSearching: $isSearching, isLoadingMore: $isLoadingMore, hasSearched: $hasSearched, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $LeadSearchStateCopyWith<$Res>  {
  factory $LeadSearchStateCopyWith(LeadSearchState value, $Res Function(LeadSearchState) _then) = _$LeadSearchStateCopyWithImpl;
@useResult
$Res call({
 CoreState core, String searchQuery, List<LeadEntity> results, List<LeadEntity> searchResults, List<String> filters, List<String> activeFilters, List<String> availableFilters, bool isSearching, bool isLoadingMore, bool hasSearched, String? errorMessage
});


$CoreStateCopyWith<$Res> get core;

}
/// @nodoc
class _$LeadSearchStateCopyWithImpl<$Res>
    implements $LeadSearchStateCopyWith<$Res> {
  _$LeadSearchStateCopyWithImpl(this._self, this._then);

  final LeadSearchState _self;
  final $Res Function(LeadSearchState) _then;

/// Create a copy of LeadSearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? core = null,Object? searchQuery = null,Object? results = null,Object? searchResults = null,Object? filters = null,Object? activeFilters = null,Object? availableFilters = null,Object? isSearching = null,Object? isLoadingMore = null,Object? hasSearched = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
core: null == core ? _self.core : core // ignore: cast_nullable_to_non_nullable
as CoreState,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<LeadEntity>,searchResults: null == searchResults ? _self.searchResults : searchResults // ignore: cast_nullable_to_non_nullable
as List<LeadEntity>,filters: null == filters ? _self.filters : filters // ignore: cast_nullable_to_non_nullable
as List<String>,activeFilters: null == activeFilters ? _self.activeFilters : activeFilters // ignore: cast_nullable_to_non_nullable
as List<String>,availableFilters: null == availableFilters ? _self.availableFilters : availableFilters // ignore: cast_nullable_to_non_nullable
as List<String>,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasSearched: null == hasSearched ? _self.hasSearched : hasSearched // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of LeadSearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoreStateCopyWith<$Res> get core {
  
  return $CoreStateCopyWith<$Res>(_self.core, (value) {
    return _then(_self.copyWith(core: value));
  });
}
}


/// Adds pattern-matching-related methods to [LeadSearchState].
extension LeadSearchStatePatterns on LeadSearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeadSearchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeadSearchState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeadSearchState value)  $default,){
final _that = this;
switch (_that) {
case _LeadSearchState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeadSearchState value)?  $default,){
final _that = this;
switch (_that) {
case _LeadSearchState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CoreState core,  String searchQuery,  List<LeadEntity> results,  List<LeadEntity> searchResults,  List<String> filters,  List<String> activeFilters,  List<String> availableFilters,  bool isSearching,  bool isLoadingMore,  bool hasSearched,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeadSearchState() when $default != null:
return $default(_that.core,_that.searchQuery,_that.results,_that.searchResults,_that.filters,_that.activeFilters,_that.availableFilters,_that.isSearching,_that.isLoadingMore,_that.hasSearched,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CoreState core,  String searchQuery,  List<LeadEntity> results,  List<LeadEntity> searchResults,  List<String> filters,  List<String> activeFilters,  List<String> availableFilters,  bool isSearching,  bool isLoadingMore,  bool hasSearched,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _LeadSearchState():
return $default(_that.core,_that.searchQuery,_that.results,_that.searchResults,_that.filters,_that.activeFilters,_that.availableFilters,_that.isSearching,_that.isLoadingMore,_that.hasSearched,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CoreState core,  String searchQuery,  List<LeadEntity> results,  List<LeadEntity> searchResults,  List<String> filters,  List<String> activeFilters,  List<String> availableFilters,  bool isSearching,  bool isLoadingMore,  bool hasSearched,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _LeadSearchState() when $default != null:
return $default(_that.core,_that.searchQuery,_that.results,_that.searchResults,_that.filters,_that.activeFilters,_that.availableFilters,_that.isSearching,_that.isLoadingMore,_that.hasSearched,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _LeadSearchState extends LeadSearchState {
  const _LeadSearchState({this.core = const CoreState(), this.searchQuery = '', final  List<LeadEntity> results = const [], final  List<LeadEntity> searchResults = const [], final  List<String> filters = const [], final  List<String> activeFilters = const [], final  List<String> availableFilters = const [], this.isSearching = false, this.isLoadingMore = false, this.hasSearched = false, this.errorMessage}): _results = results,_searchResults = searchResults,_filters = filters,_activeFilters = activeFilters,_availableFilters = availableFilters,super._();
  

@override@JsonKey() final  CoreState core;
@override@JsonKey() final  String searchQuery;
 final  List<LeadEntity> _results;
@override@JsonKey() List<LeadEntity> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

 final  List<LeadEntity> _searchResults;
@override@JsonKey() List<LeadEntity> get searchResults {
  if (_searchResults is EqualUnmodifiableListView) return _searchResults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_searchResults);
}

 final  List<String> _filters;
@override@JsonKey() List<String> get filters {
  if (_filters is EqualUnmodifiableListView) return _filters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filters);
}

 final  List<String> _activeFilters;
@override@JsonKey() List<String> get activeFilters {
  if (_activeFilters is EqualUnmodifiableListView) return _activeFilters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activeFilters);
}

 final  List<String> _availableFilters;
@override@JsonKey() List<String> get availableFilters {
  if (_availableFilters is EqualUnmodifiableListView) return _availableFilters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableFilters);
}

@override@JsonKey() final  bool isSearching;
@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  bool hasSearched;
@override final  String? errorMessage;

/// Create a copy of LeadSearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeadSearchStateCopyWith<_LeadSearchState> get copyWith => __$LeadSearchStateCopyWithImpl<_LeadSearchState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeadSearchState&&(identical(other.core, core) || other.core == core)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&const DeepCollectionEquality().equals(other._results, _results)&&const DeepCollectionEquality().equals(other._searchResults, _searchResults)&&const DeepCollectionEquality().equals(other._filters, _filters)&&const DeepCollectionEquality().equals(other._activeFilters, _activeFilters)&&const DeepCollectionEquality().equals(other._availableFilters, _availableFilters)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasSearched, hasSearched) || other.hasSearched == hasSearched)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,core,searchQuery,const DeepCollectionEquality().hash(_results),const DeepCollectionEquality().hash(_searchResults),const DeepCollectionEquality().hash(_filters),const DeepCollectionEquality().hash(_activeFilters),const DeepCollectionEquality().hash(_availableFilters),isSearching,isLoadingMore,hasSearched,errorMessage);

@override
String toString() {
  return 'LeadSearchState(core: $core, searchQuery: $searchQuery, results: $results, searchResults: $searchResults, filters: $filters, activeFilters: $activeFilters, availableFilters: $availableFilters, isSearching: $isSearching, isLoadingMore: $isLoadingMore, hasSearched: $hasSearched, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$LeadSearchStateCopyWith<$Res> implements $LeadSearchStateCopyWith<$Res> {
  factory _$LeadSearchStateCopyWith(_LeadSearchState value, $Res Function(_LeadSearchState) _then) = __$LeadSearchStateCopyWithImpl;
@override @useResult
$Res call({
 CoreState core, String searchQuery, List<LeadEntity> results, List<LeadEntity> searchResults, List<String> filters, List<String> activeFilters, List<String> availableFilters, bool isSearching, bool isLoadingMore, bool hasSearched, String? errorMessage
});


@override $CoreStateCopyWith<$Res> get core;

}
/// @nodoc
class __$LeadSearchStateCopyWithImpl<$Res>
    implements _$LeadSearchStateCopyWith<$Res> {
  __$LeadSearchStateCopyWithImpl(this._self, this._then);

  final _LeadSearchState _self;
  final $Res Function(_LeadSearchState) _then;

/// Create a copy of LeadSearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? core = null,Object? searchQuery = null,Object? results = null,Object? searchResults = null,Object? filters = null,Object? activeFilters = null,Object? availableFilters = null,Object? isSearching = null,Object? isLoadingMore = null,Object? hasSearched = null,Object? errorMessage = freezed,}) {
  return _then(_LeadSearchState(
core: null == core ? _self.core : core // ignore: cast_nullable_to_non_nullable
as CoreState,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<LeadEntity>,searchResults: null == searchResults ? _self._searchResults : searchResults // ignore: cast_nullable_to_non_nullable
as List<LeadEntity>,filters: null == filters ? _self._filters : filters // ignore: cast_nullable_to_non_nullable
as List<String>,activeFilters: null == activeFilters ? _self._activeFilters : activeFilters // ignore: cast_nullable_to_non_nullable
as List<String>,availableFilters: null == availableFilters ? _self._availableFilters : availableFilters // ignore: cast_nullable_to_non_nullable
as List<String>,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasSearched: null == hasSearched ? _self.hasSearched : hasSearched // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of LeadSearchState
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

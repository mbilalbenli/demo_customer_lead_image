import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/base/base_state.dart';
import '../../domain/entities/lead_entity.dart';

part 'lead_search_state.freezed.dart';

@freezed
abstract class LeadSearchState with _$LeadSearchState implements BaseState {
  const factory LeadSearchState({
    @Default(CoreState()) CoreState core,
    @Default('') String searchQuery,
    @Default([]) List<LeadEntity> results,
    @Default([]) List<LeadEntity> searchResults,
    @Default([]) List<String> filters,
    @Default([]) List<String> activeFilters,
    @Default([]) List<String> availableFilters,
    @Default(false) bool isSearching,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasSearched,
    String? errorMessage,
  }) = _LeadSearchState;

  const LeadSearchState._();

  @override
  bool get isBusy => core.isBusy;

  @override
  bool get showAppBar => core.showAppBar;

  @override
  String get busyOperation => core.busyOperation;

  @override
  String get title => core.title;

  @override
  GlobalKey? get widgetKeyForLoadingPosition =>
      core.widgetKeyForLoadingPosition;
}
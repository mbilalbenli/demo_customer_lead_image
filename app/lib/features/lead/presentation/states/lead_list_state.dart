import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import '../../../../core/base/base_state.dart';
import '../../domain/entities/lead_entity.dart';

part 'lead_list_state.freezed.dart';

@freezed
abstract class LeadListState with _$LeadListState implements BaseState {
  const LeadListState._();

  const factory LeadListState({
    @Default(CoreState()) CoreState core,
    @Default([]) List<LeadEntity> leads,
    @Default(false) bool isLoadingMore,
    @Default(1) int currentPage,
    @Default(false) bool hasMorePages,
    String? errorMessage,
    String? searchQuery,
  }) = _LeadListState;

  @override
  bool get isBusy => core.isBusy;

  @override
  bool get showAppBar => core.showAppBar;

  @override
  String get busyOperation => core.busyOperation;

  @override
  String get title => core.title.isNotEmpty ? core.title : 'Leads';

  @override
  GlobalKey? get widgetKeyForLoadingPosition => core.widgetKeyForLoadingPosition;
}
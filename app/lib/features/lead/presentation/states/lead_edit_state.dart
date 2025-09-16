import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/base/base_state.dart';
import '../../domain/entities/lead_entity.dart';

part 'lead_edit_state.freezed.dart';

@freezed
abstract class LeadEditState with _$LeadEditState implements BaseState {
  const factory LeadEditState({
    @Default(CoreState()) CoreState core,
    LeadEntity? originalLead,
    @Default('') String name,
    @Default('') String email,
    @Default('') String phone,
    @Default('') String company,
    @Default('') String notes,
    LeadStatus? status,
    @Default(false) bool isFormValid,
    @Default(false) bool hasChanges,
  }) = _LeadEditState;

  const LeadEditState._();

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
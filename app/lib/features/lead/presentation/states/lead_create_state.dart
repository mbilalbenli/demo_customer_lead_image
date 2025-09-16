import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/base/base_state.dart';
import '../../domain/entities/lead_entity.dart';

part 'lead_create_state.freezed.dart';

@freezed
abstract class LeadCreateState with _$LeadCreateState implements BaseState {
  const factory LeadCreateState({
    @Default(CoreState()) CoreState core,
    @Default('') String name,
    @Default('') String email,
    @Default('') String phone,
    @Default('') String company,
    @Default('') String notes,
    @Default(LeadStatus.active) LeadStatus status,
    @Default(false) bool isFormValid,
    String? errorMessage,
  }) = _LeadCreateState;

  const LeadCreateState._();

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
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_state.freezed.dart';

/// Core state that contains common properties for all feature states
@freezed
abstract class CoreState with _$CoreState {
  const factory CoreState({
    @Default(false) bool isBusy,
    @Default(false) bool showAppBar,
    @Default('') String busyOperation,
    @Default('') String title,
    GlobalKey? widgetKeyForLoadingPosition,
  }) = _CoreState;
}

/// Interface for all feature states
abstract class BaseState {
  CoreState get core;

  // Convenience getters
  bool get isBusy => core.isBusy;
  bool get showAppBar => core.showAppBar;
  String get busyOperation => core.busyOperation;
  String get title => core.title;
  GlobalKey? get widgetKeyForLoadingPosition =>
      core.widgetKeyForLoadingPosition;
}

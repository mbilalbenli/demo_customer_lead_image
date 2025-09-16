import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/app_logger.dart';
import 'base_state.dart';

abstract class BaseViewModel<T extends BaseState> extends StateNotifier<T> {
  BaseViewModel(T initialState) : super(initialState) {
    onInit();
  }

  /// Called in constructor - override this for initialization
  void onInit() {}

  /// Called from UI when context is needed
  void onInitWithContext(BuildContext context) {}

  /// Called when disposing
  @override
  void dispose() {
    onDispose();
    super.dispose();
  }

  /// Override this for cleanup
  void onDispose() {}

  // Core State Management Methods

  /// Set global loading state
  void setBusy(bool isBusy, {String? operation}) {
    final updatedCore = state.core.copyWith(
      isBusy: isBusy,
      busyOperation: operation ?? '',
    );
    state = _updateStateWithCore(state, updatedCore);
  }

  /// Set loading state for specific widget
  void setBusyWithWidgetKey(GlobalKey key, bool isBusy, {String? operation}) {
    final updatedCore = state.core.copyWith(
      isBusy: isBusy,
      busyOperation: operation ?? '',
      widgetKeyForLoadingPosition: isBusy ? key : null,
    );
    state = _updateStateWithCore(state, updatedCore);
  }

  /// Update page title
  void setTitle(String title) {
    final updatedCore = state.core.copyWith(title: title);
    state = _updateStateWithCore(state, updatedCore);
  }

  /// Toggle AppBar visibility
  void setShowAppBar(bool show) {
    final updatedCore = state.core.copyWith(showAppBar: show);
    state = _updateStateWithCore(state, updatedCore);
  }

  /// Assign loading position
  void assignWidgetPositionKey(GlobalKey key) {
    final updatedCore = state.core.copyWith(widgetKeyForLoadingPosition: key);
    state = _updateStateWithCore(state, updatedCore);
  }

  /// Clear loading position
  void clearLoadingKey() {
    final updatedCore = state.core.copyWith(widgetKeyForLoadingPosition: null);
    state = _updateStateWithCore(state, updatedCore);
  }

  // Async Operations

  /// Execute operations with automatic loading management
  Future<void> executeWithLoading<R>({
    required Future<R> Function() operation,
    String? operationName,
    GlobalKey? loadingKey,
    void Function(R result)? onSuccess,
    void Function(dynamic error)? onError,
  }) async {
    try {
      // Set loading state
      if (loadingKey != null) {
        setBusyWithWidgetKey(loadingKey, true, operation: operationName);
      } else {
        setBusy(true, operation: operationName);
      }

      // Execute operation
      final result = await operation();

      // Handle success
      if (onSuccess != null) {
        onSuccess(result);
      }
    } catch (error, stackTrace) {
      // Log error
      AppLogger.error(
        'Error in ${operationName ?? 'operation'}: $error',
        error,
        stackTrace,
      );

      // Handle error
      if (onError != null) {
        onError(error);
      }
    } finally {
      // Clear loading state
      if (loadingKey != null) {
        clearLoadingKey();
      }
      setBusy(false);
    }
  }

  // Navigation Helpers (Use Judiciously)

  void navigateTo(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  void navigateToReplacement(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
  }

  void goBack(BuildContext context, {dynamic result}) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(result);
    }
  }

  // Helper method to update state with new core
  T _updateStateWithCore(T currentState, CoreState newCore) {
    // This method needs to be implemented differently for each state type
    // Since we can't know the exact structure of T at compile time,
    // we'll use dynamic here and rely on the implementing class
    // to have a copyWith method that accepts a core parameter
    try {
      final dynamic dynamicState = currentState;
      return dynamicState.copyWith(core: newCore) as T;
    } catch (e) {
      AppLogger.error('Failed to update state core: $e', e);
      return currentState;
    }
  }
}
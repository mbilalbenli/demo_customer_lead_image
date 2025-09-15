import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool _isDisposed = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isDisposed => _isDisposed;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  @protected
  void setLoading(bool value) {
    if (_isDisposed) return;
    _isLoading = value;
    notifyListeners();
  }

  @protected
  void setError(String? message) {
    if (_isDisposed) return;
    _errorMessage = message;
    notifyListeners();
  }

  @protected
  void clearError() {
    if (_isDisposed) return;
    _errorMessage = null;
    notifyListeners();
  }

  @protected
  Future<T?> executeAsync<T>(
    Future<T> Function() operation, {
    bool showLoading = true,
    Function(dynamic error)? onError,
  }) async {
    try {
      if (showLoading) setLoading(true);
      clearError();

      final result = await operation();
      return result;
    } catch (error) {
      setError(error.toString());
      onError?.call(error);
      return null;
    } finally {
      if (showLoading) setLoading(false);
    }
  }

  @protected
  void safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void onInit() {}
}

abstract class StateNotifierViewModel<T> extends StateNotifier<T> {
  StateNotifierViewModel(super.state);

  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;

  @protected
  void updateState(T Function(T state) updater) {
    if (!_isDisposed) {
      state = updater(state);
    }
  }

  @protected
  Future<R?> executeAsync<R>(
    Future<R> Function() operation, {
    Function(T state)? onLoading,
    Function(T state)? onSuccess,
    Function(T state, dynamic error)? onError,
  }) async {
    try {
      if (onLoading != null && !_isDisposed) {
        state = onLoading(state) as T;
      }

      final result = await operation();

      if (onSuccess != null && !_isDisposed) {
        state = onSuccess(state) as T;
      }

      return result;
    } catch (error) {
      if (onError != null && !_isDisposed) {
        state = onError(state, error) as T;
      }
      return null;
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
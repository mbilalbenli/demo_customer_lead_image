import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BaseState<T extends ConsumerStatefulWidget> extends ConsumerState<T> {
  bool _isDisposed = false;
  bool _isMounted = false;

  bool get isDisposed => _isDisposed;
  bool get isMountedAndActive => _isMounted && mounted;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    onInit();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _isMounted = false;
    onDispose();
    super.dispose();
  }

  @protected
  void onInit() {}

  @protected
  void onDispose() {}

  @protected
  void safeSetState(VoidCallback fn) {
    if (isMountedAndActive) {
      setState(fn);
    }
  }

  @protected
  Future<void> runAsync(Future<void> Function() operation, {
    VoidCallback? onError,
    VoidCallback? onFinally,
  }) async {
    try {
      await operation();
    } catch (e) {
      if (isMountedAndActive) {
        onError?.call();
      }
      rethrow;
    } finally {
      if (isMountedAndActive) {
        onFinally?.call();
      }
    }
  }

  @protected
  void showSnackBar(String message, {bool isError = false}) {
    if (!isMountedAndActive) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @protected
  void hideKeyboard() {
    FocusScope.of(context).unfocus();
  }
}
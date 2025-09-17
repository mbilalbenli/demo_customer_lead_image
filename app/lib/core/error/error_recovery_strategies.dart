import 'dart:async';
import '../utils/app_logger.dart';

/// Strategies for recovering from various error conditions
class ErrorRecoveryStrategies {
  /// Retry with exponential backoff
  static Future<T?> retryWithBackoff<T>({
    required Future<T> Function() operation,
    required String operationName,
    int maxAttempts = 3,
    Duration initialDelay = const Duration(seconds: 1),
    double backoffMultiplier = 2.0,
    bool Function(dynamic)? shouldRetry,
  }) async {
    int attempt = 0;
    Duration delay = initialDelay;

    while (attempt < maxAttempts) {
      try {
        attempt++;
        AppLogger.info('Attempting $operationName (attempt $attempt/$maxAttempts)');

        final result = await operation();
        AppLogger.info('$operationName succeeded on attempt $attempt');
        return result;
      } catch (error, stackTrace) {
        AppLogger.error(
          '$operationName failed on attempt $attempt',
          error,
          stackTrace,
        );

        // Check if we should retry this error
        if (shouldRetry != null && !shouldRetry(error)) {
          AppLogger.info('Error is not retryable, stopping retry attempts');
          rethrow;
        }

        // Check if we have more attempts
        if (attempt >= maxAttempts) {
          AppLogger.error('Max retry attempts reached for $operationName');
          rethrow;
        }

        // Wait before next attempt
        AppLogger.info('Waiting ${delay.inSeconds}s before retry...');
        await Future.delayed(delay);
        delay = Duration(
          milliseconds: (delay.inMilliseconds * backoffMultiplier).round(),
        );
      }
    }

    return null;
  }

  /// Retry on network failure
  static Future<T?> retryOnNetworkFailure<T>({
    required Future<T> Function() operation,
    required String operationName,
    int maxAttempts = 5,
    Duration checkInterval = const Duration(seconds: 2),
  }) async {
    return retryWithBackoff(
      operation: operation,
      operationName: operationName,
      maxAttempts: maxAttempts,
      initialDelay: checkInterval,
      shouldRetry: (error) {
        // Check if it's a network error
        final isNetworkError = _isNetworkError(error);
        return isNetworkError;
      },
    );
  }

  /// Circuit breaker pattern
  static CircuitBreaker createCircuitBreaker({
    required String name,
    int failureThreshold = 5,
    Duration timeout = const Duration(seconds: 60),
    Duration halfOpenAfter = const Duration(seconds: 30),
  }) {
    return CircuitBreaker(
      name: name,
      failureThreshold: failureThreshold,
      timeout: timeout,
      halfOpenAfter: halfOpenAfter,
    );
  }

  /// Check if error is network-related
  static bool _isNetworkError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    return errorString.contains('network') ||
           errorString.contains('connection') ||
           errorString.contains('timeout') ||
           errorString.contains('socket') ||
           errorString.contains('host');
  }

  /// Fallback to cached data
  static Future<T> fallbackToCache<T>({
    required Future<T> Function() primaryOperation,
    required T Function() cacheOperation,
    required String operationName,
  }) async {
    try {
      return await primaryOperation();
    } catch (error) {
      AppLogger.warning('$operationName failed, falling back to cache');
      return cacheOperation();
    }
  }

  /// Queue operation for retry
  static void queueForRetry({
    required Future<void> Function() operation,
    required String operationId,
    Duration delay = const Duration(minutes: 5),
  }) {
    AppLogger.info('Queueing $operationId for retry in ${delay.inMinutes} minutes');

    Timer(delay, () async {
      try {
        AppLogger.info('Retrying queued operation: $operationId');
        await operation();
        AppLogger.info('Queued operation succeeded: $operationId');
      } catch (error) {
        AppLogger.error('Queued operation failed: $operationId', error);
      }
    });
  }
}

/// Circuit breaker implementation
class CircuitBreaker {
  final String name;
  final int failureThreshold;
  final Duration timeout;
  final Duration halfOpenAfter;

  CircuitBreakerState _state = CircuitBreakerState.closed;
  int _failureCount = 0;
  DateTime? _lastFailureTime;
  Timer? _resetTimer;

  CircuitBreaker({
    required this.name,
    required this.failureThreshold,
    required this.timeout,
    required this.halfOpenAfter,
  });

  /// Execute operation with circuit breaker
  Future<T> execute<T>(Future<T> Function() operation) async {
    // Check circuit state
    if (_state == CircuitBreakerState.open) {
      _checkIfShouldTransitionToHalfOpen();

      if (_state == CircuitBreakerState.open) {
        throw CircuitBreakerOpenException(
          'Circuit breaker $name is open',
        );
      }
    }

    try {
      final result = await operation().timeout(timeout);

      // Success - reset failure count
      if (_state == CircuitBreakerState.halfOpen) {
        _transitionToClosed();
      }
      _failureCount = 0;

      return result;
    } catch (error) {
      _recordFailure();
      rethrow;
    }
  }

  void _recordFailure() {
    _failureCount++;
    _lastFailureTime = DateTime.now();

    AppLogger.warning(
      'Circuit breaker $name recorded failure $_failureCount/$failureThreshold',
    );

    if (_failureCount >= failureThreshold) {
      _transitionToOpen();
    }
  }

  void _transitionToOpen() {
    _state = CircuitBreakerState.open;
    AppLogger.error('Circuit breaker $name is now OPEN');

    // Schedule transition to half-open
    _resetTimer?.cancel();
    _resetTimer = Timer(halfOpenAfter, () {
      _transitionToHalfOpen();
    });
  }

  void _transitionToHalfOpen() {
    _state = CircuitBreakerState.halfOpen;
    AppLogger.info('Circuit breaker $name is now HALF-OPEN');
  }

  void _transitionToClosed() {
    _state = CircuitBreakerState.closed;
    _failureCount = 0;
    _resetTimer?.cancel();
    AppLogger.info('Circuit breaker $name is now CLOSED');
  }

  void _checkIfShouldTransitionToHalfOpen() {
    if (_lastFailureTime != null) {
      final timeSinceLastFailure = DateTime.now().difference(_lastFailureTime!);
      if (timeSinceLastFailure >= halfOpenAfter) {
        _transitionToHalfOpen();
      }
    }
  }

  CircuitBreakerState get state => _state;
  int get failureCount => _failureCount;

  void dispose() {
    _resetTimer?.cancel();
  }
}

enum CircuitBreakerState {
  closed,
  open,
  halfOpen,
}

class CircuitBreakerOpenException implements Exception {
  final String message;
  CircuitBreakerOpenException(this.message);
}
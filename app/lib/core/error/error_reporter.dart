import 'package:flutter/foundation.dart';
import '../utils/app_logger.dart';

/// Error reporter for analytics and crash reporting
class ErrorReporter {
  static final ErrorReporter _instance = ErrorReporter._internal();
  factory ErrorReporter() => _instance;
  ErrorReporter._internal();

  /// Report error to analytics service
  static Future<void> reportError({
    required dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? additionalData,
    ErrorSeverity severity = ErrorSeverity.medium,
  }) async {
    try {
      // Log locally
      AppLogger.error(
        'Error reported with severity: ${severity.name}',
        error,
        stackTrace,
      );

      // In production, send to crash reporting service
      if (kReleaseMode) {
        // TODO: Integrate with crash reporting service like Sentry or Firebase Crashlytics
        await _sendToCrashlytics(
          error: error,
          stackTrace: stackTrace,
          additionalData: additionalData,
          severity: severity,
        );
      }

      // Log additional data if provided
      if (additionalData != null && additionalData.isNotEmpty) {
        AppLogger.info('Additional error data: $additionalData');
      }
    } catch (e) {
      AppLogger.error('Failed to report error', e);
    }
  }

  /// Send error to crash reporting service
  static Future<void> _sendToCrashlytics({
    required dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? additionalData,
    required ErrorSeverity severity,
  }) async {
    // Placeholder for actual crash reporting implementation
    // Example with Firebase Crashlytics:
    // FirebaseCrashlytics.instance.recordError(
    //   error,
    //   stackTrace,
    //   reason: additionalData?['reason'],
    //   fatal: severity == ErrorSeverity.critical,
    // );
  }

  /// Report non-fatal error
  static void reportNonFatal({
    required String message,
    Map<String, dynamic>? data,
  }) {
    reportError(
      error: Exception(message),
      additionalData: data,
      severity: ErrorSeverity.low,
    );
  }

  /// Report image limit violation attempt
  static void reportImageLimitViolation({
    required String leadId,
    required int currentCount,
    required int attemptedCount,
  }) {
    reportNonFatal(
      message: 'Image limit violation attempted',
      data: {
        'leadId': leadId,
        'currentCount': currentCount,
        'attemptedCount': attemptedCount,
        'limit': 10,
      },
    );
  }

  /// Report upload failure
  static void reportUploadFailure({
    required String leadId,
    required String error,
    int? imageSize,
    String? mimeType,
  }) {
    reportError(
      error: Exception('Image upload failed: $error'),
      additionalData: {
        'leadId': leadId,
        'error': error,
        'imageSize': imageSize,
        'mimeType': mimeType,
      },
      severity: ErrorSeverity.medium,
    );
  }

  /// Report performance issue
  static void reportPerformanceIssue({
    required String operation,
    required Duration duration,
    Map<String, dynamic>? context,
  }) {
    if (duration.inSeconds > 5) {
      reportNonFatal(
        message: 'Performance issue detected',
        data: {
          'operation': operation,
          'durationMs': duration.inMilliseconds,
          'context': context,
        },
      );
    }
  }
}

/// Error severity levels
enum ErrorSeverity {
  low,
  medium,
  high,
  critical,
}

/// Error tracking for analytics
class ErrorTracker {
  static final Map<String, int> _errorCounts = {};
  static final Map<String, DateTime> _lastOccurrence = {};

  /// Track error occurrence
  static void trackError(String errorType) {
    _errorCounts[errorType] = (_errorCounts[errorType] ?? 0) + 1;
    _lastOccurrence[errorType] = DateTime.now();

    // Report if error occurs too frequently
    final count = _errorCounts[errorType]!;
    if (count % 10 == 0) {
      ErrorReporter.reportNonFatal(
        message: 'Frequent error detected: $errorType',
        data: {
          'errorType': errorType,
          'count': count,
          'lastOccurrence': _lastOccurrence[errorType]?.toIso8601String(),
        },
      );
    }
  }

  /// Get error statistics
  static Map<String, dynamic> getStatistics() {
    return {
      'errorCounts': Map<String, int>.from(_errorCounts),
      'lastOccurrences': _lastOccurrence.map(
        (key, value) => MapEntry(key, value.toIso8601String()),
      ),
      'totalErrors': _errorCounts.values.fold(0, (sum, count) => sum + count),
    };
  }

  /// Clear error tracking data
  static void clear() {
    _errorCounts.clear();
    _lastOccurrence.clear();
  }
}
import 'package:flutter/foundation.dart';

enum LogLevel {
  info('[INFO]'),
  warning('[WARN]'),
  error('[ERROR]'),
  debug('[DEBUG]'),
  success('[SUCCESS]');

  final String tag;
  const LogLevel(this.tag);
}

class AppLogger {
  static bool _enableLogging = kDebugMode;
  static const String _separator = ' | ';

  static void setLoggingEnabled(bool enabled) {
    _enableLogging = enabled;
  }

  static String _getTimestamp() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}.'
        '${now.millisecond.toString().padLeft(3, '0')}';
  }

  static void _log(LogLevel level, String message, [Object? error, StackTrace? stackTrace]) {
    if (!_enableLogging) return;

    final timestamp = _getTimestamp();
    final logMessage = '$timestamp$_separator${level.tag}$_separator$message';

    switch (level) {
      case LogLevel.error:
        debugPrint('\x1B[31m$logMessage\x1B[0m'); // Red
        if (error != null) {
          debugPrint('\x1B[31m$timestamp$_separator${level.tag}$_separator Error: $error\x1B[0m');
        }
        if (stackTrace != null && kDebugMode) {
          debugPrint('\x1B[31m$timestamp$_separator${level.tag}$_separator StackTrace: $stackTrace\x1B[0m');
        }
        break;
      case LogLevel.warning:
        debugPrint('\x1B[33m$logMessage\x1B[0m'); // Yellow
        break;
      case LogLevel.success:
        debugPrint('\x1B[32m$logMessage\x1B[0m'); // Green
        break;
      case LogLevel.info:
        debugPrint('\x1B[36m$logMessage\x1B[0m'); // Cyan
        break;
      case LogLevel.debug:
        debugPrint('\x1B[35m$logMessage\x1B[0m'); // Magenta
        break;
    }
  }

  static void info(String message) => _log(LogLevel.info, message);
  static void warning(String message) => _log(LogLevel.warning, message);
  static void error(String message, [Object? error, StackTrace? stackTrace]) =>
      _log(LogLevel.error, message, error, stackTrace);
  static void debug(String message) => _log(LogLevel.debug, message);
  static void success(String message) => _log(LogLevel.success, message);

  // Convenience methods for specific use cases
  static void logRequest(String endpoint) {
    info('→ Request: $endpoint');
  }

  static void logResponse(String endpoint, int? statusCode, Duration duration) {
    if (statusCode == null || statusCode >= 400) {
      error('← Response: $endpoint | Status: ${statusCode ?? 'unknown'} | ${duration.inMilliseconds}ms');
    } else if (statusCode >= 200 && statusCode < 300) {
      success('← Response: $endpoint | Status: $statusCode | ${duration.inMilliseconds}ms');
    } else {
      warning('← Response: $endpoint | Status: $statusCode | ${duration.inMilliseconds}ms');
    }
  }

  static void logDivider([String title = '']) {
    if (!_enableLogging) return;
    if (title.isEmpty) {
      debugPrint('════════════════════════════════════════════════════════════');
    } else {
      debugPrint('═══════════════════[ $title ]═══════════════════');
    }
  }
}
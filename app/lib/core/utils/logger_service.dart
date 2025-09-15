import 'package:logger/logger.dart';

class LoggerService {
  late final Logger _logger;

  LoggerService() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 80,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      level: Level.debug,
    );
  }

  void debug(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  void info(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  void warning(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  void error(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  void verbose(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  void wtf(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  void logNetwork({
    required String method,
    required String url,
    int? statusCode,
    dynamic requestData,
    dynamic responseData,
    dynamic error,
    Duration? duration,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('🌐 Network Request');
    buffer.writeln('├─ Method: $method');
    buffer.writeln('├─ URL: $url');

    if (statusCode != null) {
      buffer.writeln('├─ Status: $statusCode');
    }

    if (duration != null) {
      buffer.writeln('├─ Duration: ${duration.inMilliseconds}ms');
    }

    if (requestData != null) {
      buffer.writeln('├─ Request: $requestData');
    }

    if (responseData != null) {
      buffer.writeln('├─ Response: $responseData');
    }

    if (error != null) {
      buffer.writeln('└─ Error: $error');
      _logger.e(buffer.toString());
    } else if (statusCode != null && statusCode >= 400) {
      _logger.w(buffer.toString());
    } else {
      _logger.i(buffer.toString());
    }
  }
}
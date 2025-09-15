class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic data;

  AppException({
    required this.message,
    this.code,
    this.data,
  });

  factory AppException.network() => AppException(
        message: 'Network connection error. Please check your internet connection.',
        code: 'NETWORK_ERROR',
      );

  factory AppException.timeout() => AppException(
        message: 'Request timeout. Please try again.',
        code: 'TIMEOUT',
      );

  factory AppException.server([String? message]) => AppException(
        message: message ?? 'Server error. Please try again later.',
        code: 'SERVER_ERROR',
      );

  factory AppException.unauthorized([String? message]) => AppException(
        message: message ?? 'Unauthorized access. Please login again.',
        code: 'UNAUTHORIZED',
      );

  factory AppException.forbidden([String? message]) => AppException(
        message: message ?? 'Access forbidden.',
        code: 'FORBIDDEN',
      );

  factory AppException.notFound([String? message]) => AppException(
        message: message ?? 'Resource not found.',
        code: 'NOT_FOUND',
      );

  factory AppException.badRequest([String? message]) => AppException(
        message: message ?? 'Invalid request.',
        code: 'BAD_REQUEST',
      );

  factory AppException.cancelled() => AppException(
        message: 'Request cancelled.',
        code: 'CANCELLED',
      );

  factory AppException.unknown([String? message]) => AppException(
        message: message ?? 'An unexpected error occurred.',
        code: 'UNKNOWN',
      );

  factory AppException.validation(String message, [Map<String, dynamic>? errors]) => AppException(
        message: message,
        code: 'VALIDATION_ERROR',
        data: errors,
      );

  @override
  String toString() => message;
}
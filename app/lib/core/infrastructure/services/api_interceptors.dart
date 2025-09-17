import 'package:dio/dio.dart';
import '../../utils/app_logger.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.debug(
      'REQUEST[${options.method}] => PATH: ${options.path}',
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.debug(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    super.onError(err, handler);
  }
}

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeoutException(err.requestOptions);
      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            throw BadRequestException(err.requestOptions, err.response);
          case 401:
            throw UnauthorizedException(err.requestOptions);
          case 403:
            throw ForbiddenException(err.requestOptions);
          case 404:
            throw NotFoundException(err.requestOptions);
          case 409:
            throw ConflictException(err.requestOptions);
          case 422:
            throw UnprocessableEntityException(err.requestOptions, err.response);
          case 500:
            throw InternalServerException(err.requestOptions);
          default:
            throw ServerException(err.requestOptions);
        }
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.connectionError:
        throw NoInternetException(err.requestOptions);
      case DioExceptionType.badCertificate:
        throw BadCertificateException(err.requestOptions);
      case DioExceptionType.unknown:
        throw UnknownException(err.requestOptions);
    }
    handler.next(err);
  }
}

class RetryInterceptor extends Interceptor {
  final Dio dio;
  int retryCount = 0;
  static const int maxRetries = 3;

  RetryInterceptor(this.dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) && retryCount < maxRetries) {
      retryCount++;
      AppLogger.info('Retrying request... Attempt: $retryCount');

      await Future.delayed(Duration(seconds: retryCount));

      try {
        final response = await dio.fetch(err.requestOptions);
        handler.resolve(response);
        retryCount = 0;
      } catch (e) {
        handler.next(err);
      }
    } else {
      retryCount = 0;
      handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        (err.response?.statusCode != null &&
            err.response!.statusCode! >= 500);
  }
}

class ApiException implements Exception {
  final String message;
  final RequestOptions requestOptions;

  ApiException(this.message, this.requestOptions);

  @override
  String toString() => message;
}

class TimeoutException extends ApiException {
  TimeoutException(RequestOptions r) : super('Connection timeout', r);
}

class BadRequestException extends ApiException {
  final Response? response;
  BadRequestException(RequestOptions r, this.response)
      : super(_extractMessage(response) ?? 'Bad request', r);

  static String? _extractMessage(Response? response) {
    if (response?.data is Map) {
      return response?.data['message'] ?? response?.data['error'];
    }
    return null;
  }
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(RequestOptions r) : super('Unauthorized', r);
}

class ForbiddenException extends ApiException {
  ForbiddenException(RequestOptions r) : super('Forbidden', r);
}

class NotFoundException extends ApiException {
  NotFoundException(RequestOptions r) : super('Not found', r);
}

class ConflictException extends ApiException {
  ConflictException(RequestOptions r) : super('Conflict', r);
}

class UnprocessableEntityException extends ApiException {
  final Response? response;
  UnprocessableEntityException(RequestOptions r, this.response)
      : super(_extractMessage(response) ?? 'Unprocessable entity', r);

  static String? _extractMessage(Response? response) {
    if (response?.data is Map) {
      return response?.data['message'] ?? response?.data['error'];
    }
    return null;
  }
}

class InternalServerException extends ApiException {
  InternalServerException(RequestOptions r) : super('Internal server error', r);
}

class ServerException extends ApiException {
  ServerException(RequestOptions r) : super('Server error', r);
}

class NoInternetException extends ApiException {
  NoInternetException(RequestOptions r) : super('No internet connection', r);
}

class BadCertificateException extends ApiException {
  BadCertificateException(RequestOptions r) : super('Bad certificate', r);
}

class UnknownException extends ApiException {
  UnknownException(RequestOptions r) : super('Unknown error occurred', r);
}
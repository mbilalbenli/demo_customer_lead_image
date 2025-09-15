import 'package:dio/dio.dart';
import '../../utils/logger_service.dart';
import '../../domain/errors/app_exception.dart';

class ApiClient {
  final Dio dio;
  final LoggerService logger;

  ApiClient({
    required this.dio,
    required this.logger,
  });

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _parseResponse(response, parser);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AppException.unknown(e.toString());
    }
  }

  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _parseResponse(response, parser);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AppException.unknown(e.toString());
    }
  }

  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _parseResponse(response, parser);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AppException.unknown(e.toString());
    }
  }

  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _parseResponse(response, parser);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AppException.unknown(e.toString());
    }
  }

  T _parseResponse<T>(Response response, T Function(dynamic)? parser) {
    if (parser != null) {
      return parser(response.data);
    }
    return response.data as T;
  }

  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppException.timeout();
      case DioExceptionType.connectionError:
        return AppException.network();
      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response);
      case DioExceptionType.cancel:
        return AppException.cancelled();
      default:
        return AppException.unknown(error.message ?? 'Unknown error');
    }
  }

  AppException _handleStatusCode(Response? response) {
    if (response == null) {
      return AppException.unknown('No response from server');
    }

    final statusCode = response.statusCode ?? 0;
    final message = _extractErrorMessage(response.data);

    switch (statusCode) {
      case 400:
        return AppException.badRequest(message);
      case 401:
        return AppException.unauthorized(message);
      case 403:
        return AppException.forbidden(message);
      case 404:
        return AppException.notFound(message);
      case 500:
      case 502:
      case 503:
        return AppException.server(message);
      default:
        return AppException.unknown(message);
    }
  }

  String _extractErrorMessage(dynamic data) {
    if (data == null) return 'An error occurred';

    if (data is Map) {
      return data['message'] ??
             data['error'] ??
             data['detail'] ??
             'An error occurred';
    }

    if (data is String) {
      return data;
    }

    return 'An error occurred';
  }
}
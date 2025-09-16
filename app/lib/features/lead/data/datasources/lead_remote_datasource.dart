import 'package:dio/dio.dart';
import '../models/lead_model.dart';
import '../../../../core/utils/app_logger.dart';

abstract class LeadRemoteDataSource {
  Future<LeadModel> getLeadById(String id);
  Future<List<LeadModel>> getLeadsList({int page = 1, int pageSize = 20});
  Future<List<LeadModel>> searchLeads({required String query, int page = 1, int pageSize = 20});
  Future<LeadModel> createLead(LeadModel lead);
  Future<LeadModel> updateLead(LeadModel lead);
  Future<void> deleteLead(String id);
  Future<int> getImageCountForLead(String leadId);
  Future<Map<String, dynamic>> getImageStatus(String leadId);
}

class LeadRemoteDataSourceImpl implements LeadRemoteDataSource {
  final Dio _dio;
  static const String _baseUrl = '/api/leads';

  LeadRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<LeadModel> getLeadById(String id) async {
    try {
      AppLogger.info('Fetching lead with id: $id');
      final response = await _dio.get('$_baseUrl/$id');
      return LeadModel.fromJson(response.data);
    } on DioException catch (e) {
      AppLogger.error('Failed to fetch lead', e);
      throw _handleDioError(e);
    }
  }

  @override
  Future<List<LeadModel>> getLeadsList({int page = 1, int pageSize = 20}) async {
    try {
      AppLogger.info('Fetching leads list - page: $page, pageSize: $pageSize');
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
        },
      );
      final List<dynamic> data = response.data['items'] ?? [];
      return data.map((json) => LeadModel.fromJson(json)).toList();
    } on DioException catch (e) {
      AppLogger.error('Failed to fetch leads list', e);
      throw _handleDioError(e);
    }
  }

  @override
  Future<List<LeadModel>> searchLeads({
    required String query,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      AppLogger.info('Searching leads with query: $query');
      final response = await _dio.get(
        '$_baseUrl/search',
        queryParameters: {
          'query': query,
          'page': page,
          'pageSize': pageSize,
        },
      );
      final List<dynamic> data = response.data['items'] ?? [];
      return data.map((json) => LeadModel.fromJson(json)).toList();
    } on DioException catch (e) {
      AppLogger.error('Failed to search leads', e);
      throw _handleDioError(e);
    }
  }

  @override
  Future<LeadModel> createLead(LeadModel lead) async {
    try {
      AppLogger.info('Creating new lead');
      final response = await _dio.post(
        _baseUrl,
        data: lead.toJson(),
      );
      return LeadModel.fromJson(response.data);
    } on DioException catch (e) {
      AppLogger.error('Failed to create lead', e);
      throw _handleDioError(e);
    }
  }

  @override
  Future<LeadModel> updateLead(LeadModel lead) async {
    try {
      AppLogger.info('Updating lead with id: ${lead.id}');
      final response = await _dio.put(
        '$_baseUrl/${lead.id}',
        data: lead.toJson(),
      );
      return LeadModel.fromJson(response.data);
    } on DioException catch (e) {
      AppLogger.error('Failed to update lead', e);
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> deleteLead(String id) async {
    try {
      AppLogger.info('Deleting lead with id: $id');
      await _dio.delete('$_baseUrl/$id');
    } on DioException catch (e) {
      AppLogger.error('Failed to delete lead', e);
      throw _handleDioError(e);
    }
  }

  @override
  Future<int> getImageCountForLead(String leadId) async {
    try {
      AppLogger.info('Fetching image count for lead: $leadId');
      final response = await _dio.get('$_baseUrl/$leadId/image-status');
      return response.data['currentCount'] ?? 0;
    } on DioException catch (e) {
      AppLogger.error('Failed to fetch image count', e);
      throw _handleDioError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getImageStatus(String leadId) async {
    try {
      AppLogger.info('Fetching image status for lead: $leadId');
      final response = await _dio.get('$_baseUrl/$leadId/image-status');
      return response.data;
    } on DioException catch (e) {
      AppLogger.error('Failed to fetch image status', e);
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final message = error.response!.data?['message'] ?? 'Unknown error occurred';

      switch (statusCode) {
        case 400:
          return Exception('Bad request: $message');
        case 401:
          return Exception('Unauthorized: Please login again');
        case 404:
          return Exception('Resource not found');
        case 409:
          return Exception('Conflict: $message');
        case 500:
          return Exception('Server error: Please try again later');
        default:
          return Exception('Error $statusCode: $message');
      }
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return Exception('Connection timeout: Please check your internet connection');
    }

    if (error.type == DioExceptionType.connectionError) {
      return Exception('Connection error: Please check your internet connection');
    }

    return Exception('An unexpected error occurred');
  }
}
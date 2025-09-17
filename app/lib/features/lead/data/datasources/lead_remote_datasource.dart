import '../models/lead_model.dart';
import '../../../../core/utils/app_logger.dart';
import '../../infrastructure/services/lead_api_service.dart';
import '../../../../core/infrastructure/services/api_interceptors.dart';
import '../../domain/exceptions/lead_exceptions.dart';

abstract class LeadRemoteDataSource {
  Future<LeadModel> getLeadById(String id);
  Future<List<LeadModel>> getLeadsList({int page = 1, int pageSize = 20});
}

class LeadRemoteDataSourceImpl implements LeadRemoteDataSource {
  final LeadApiService _apiService;

  LeadRemoteDataSourceImpl({dynamic dio}) : _apiService = LeadApiService();

  @override
  Future<LeadModel> getLeadById(String id) async {
    try {
      return await _apiService.getLeadById(id);
    } on ApiException catch (e) {
      AppLogger.error('Failed to fetch lead: ${e.message}');
      if (e.statusCode == 404) {
        throw LeadNotFoundException(leadId: id, originalError: e);
      }
      throw LeadSearchException(
        message: e.message,
        originalError: e,
      );
    } catch (e) {
      if (e is LeadException) rethrow;
      AppLogger.error('Unexpected error fetching lead: $e');
      throw LeadSearchException(
        message: 'Failed to fetch lead',
        originalError: e,
      );
    }
  }

  @override
  Future<List<LeadModel>> getLeadsList({int page = 1, int pageSize = 20}) async {
    try {
      final skip = (page - 1) * pageSize;
      return await _apiService.getLeads(
        skip: skip,
        take: pageSize,
      );
    } on ApiException catch (e) {
      AppLogger.error('Failed to fetch leads list: ${e.message}');
      throw LeadSearchException(
        message: e.message,
        originalError: e,
      );
    } catch (e) {
      if (e is LeadException) rethrow;
      AppLogger.error('Unexpected error fetching leads list: $e');
      throw LeadSearchException(
        message: 'Failed to fetch leads',
        originalError: e,
      );
    }
  }
}

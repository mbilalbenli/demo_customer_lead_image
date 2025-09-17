import '../models/lead_model.dart';
import '../../../../core/utils/app_logger.dart';
import '../../infrastructure/services/lead_api_service.dart';
import '../../../../core/infrastructure/services/api_interceptors.dart';
import '../../domain/exceptions/lead_exceptions.dart';

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

  @override
  Future<List<LeadModel>> searchLeads({
    required String query,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final skip = (page - 1) * pageSize;
      return await _apiService.searchLeads(
        query: query,
        skip: skip,
        take: pageSize,
      );
    } on ApiException catch (e) {
      AppLogger.error('Failed to search leads: ${e.message}');
      throw LeadSearchException(
        message: e.message,
        originalError: e,
      );
    } catch (e) {
      if (e is LeadException) rethrow;
      AppLogger.error('Unexpected error searching leads: $e');
      throw LeadSearchException(
        message: 'Failed to search leads',
        originalError: e,
      );
    }
  }

  @override
  Future<LeadModel> createLead(LeadModel lead) async {
    try {
      return await _apiService.createLead(lead);
    } on ApiException catch (e) {
      AppLogger.error('Failed to create lead: ${e.message}');
      if (e.statusCode == 400) {
        throw LeadValidationException(
          message: e.message,
          validationErrors: e.validationErrors ?? {},
          originalError: e,
        );
      }
      throw LeadCreationException(
        message: e.message,
        originalError: e,
      );
    } catch (e) {
      if (e is LeadException) rethrow;
      AppLogger.error('Unexpected error creating lead: $e');
      throw LeadCreationException(
        message: 'Failed to create lead',
        originalError: e,
      );
    }
  }

  @override
  Future<LeadModel> updateLead(LeadModel lead) async {
    try {
      return await _apiService.updateLead(lead.id, lead);
    } on ApiException catch (e) {
      AppLogger.error('Failed to update lead: ${e.message}');
      if (e.statusCode == 404) {
        throw LeadNotFoundException(leadId: lead.id, originalError: e);
      }
      if (e.statusCode == 400) {
        throw LeadValidationException(
          message: e.message,
          validationErrors: e.validationErrors ?? {},
          originalError: e,
        );
      }
      throw LeadUpdateException(
        message: e.message,
        originalError: e,
      );
    } catch (e) {
      if (e is LeadException) rethrow;
      AppLogger.error('Unexpected error updating lead: $e');
      throw LeadUpdateException(
        message: 'Failed to update lead',
        originalError: e,
      );
    }
  }

  @override
  Future<void> deleteLead(String id) async {
    try {
      await _apiService.deleteLead(id);
    } on ApiException catch (e) {
      AppLogger.error('Failed to delete lead: ${e.message}');
      if (e.statusCode == 404) {
        throw LeadNotFoundException(leadId: id, originalError: e);
      }
      throw LeadDeletionException(
        message: e.message,
        originalError: e,
      );
    } catch (e) {
      if (e is LeadException) rethrow;
      AppLogger.error('Unexpected error deleting lead: $e');
      throw LeadDeletionException(
        message: 'Failed to delete lead',
        originalError: e,
      );
    }
  }

  @override
  Future<int> getImageCountForLead(String leadId) async {
    try {
      // This should use the ImageApiService but since it's not defined in LeadApiService,
      // we'll create a temporary implementation
      // TODO: Move to ImageApiService
      return 0; // Placeholder - will be implemented with ImageApiService
    } catch (e) {
      AppLogger.error('Failed to fetch image count: $e');
      throw Exception('Failed to fetch image count');
    }
  }

  @override
  Future<Map<String, dynamic>> getImageStatus(String leadId) async {
    try {
      // This should use the ImageApiService
      // TODO: Move to ImageApiService
      return {
        'currentCount': 0,
        'maxCount': 10,
        'canAddMore': true,
      }; // Placeholder - will be implemented with ImageApiService
    } catch (e) {
      AppLogger.error('Failed to fetch image status: $e');
      throw Exception('Failed to fetch image status');
    }
  }

}
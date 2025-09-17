import '../../../../core/infrastructure/services/api_endpoints.dart';
import '../../../../core/infrastructure/services/dio_client.dart';
import '../../../../core/utils/app_logger.dart';
import '../../data/models/lead_model.dart';

class LeadApiService {
  final DioClient _dioClient = DioClient.instance;

  Future<List<LeadModel>> getLeads({
    int? skip,
    int? take,
    String? searchTerm,
  }) async {
    try {
      AppLogger.info('Fetching leads list');
      final response = await _dioClient.get<Map<String, dynamic>>(
        ApiEndpoints.leads,
        queryParameters: {
          if (skip != null) 'skip': skip,
          if (take != null) 'take': take,
          if (searchTerm != null) 'searchTerm': searchTerm,
        },
      );

      if (response.data != null && response.data!['leads'] != null) {
        final leadsList = (response.data!['leads'] as List)
            .map((json) => LeadModel.fromJson(json as Map<String, dynamic>))
            .toList();
        AppLogger.info('Fetched ${leadsList.length} leads');
        return leadsList;
      }
      return [];
    } catch (e) {
      AppLogger.error('Error fetching leads: $e');
      rethrow;
    }
  }

  Future<LeadModel> getLeadById(String id) async {
    try {
      AppLogger.info('Fetching lead with id: $id');
      final response = await _dioClient.get<Map<String, dynamic>>(
        ApiEndpoints.getLeadById(id),
      );

      if (response.data != null && response.data!['lead'] != null) {
        final lead = LeadModel.fromJson(response.data!['lead'] as Map<String, dynamic>);
        AppLogger.info('Fetched lead: ${lead.customerName}');
        return lead;
      }
      throw Exception('Lead not found');
    } catch (e) {
      AppLogger.error('Error fetching lead by id: $e');
      rethrow;
    }
  }

  Future<LeadModel> createLead(LeadModel lead) async {
    try {
      AppLogger.info('Creating new lead: ${lead.customerName}');
      final response = await _dioClient.post<Map<String, dynamic>>(
        ApiEndpoints.leads,
        data: lead.toJson(),
      );

      if (response.data != null && response.data!['lead'] != null) {
        final createdLead = LeadModel.fromJson(response.data!['lead'] as Map<String, dynamic>);
        AppLogger.info('Created lead with id: ${createdLead.id}');
        return createdLead;
      }
      throw Exception('Failed to create lead');
    } catch (e) {
      AppLogger.error('Error creating lead: $e');
      rethrow;
    }
  }

  Future<LeadModel> updateLead(String id, LeadModel lead) async {
    try {
      AppLogger.info('Updating lead with id: $id');
      final response = await _dioClient.put<Map<String, dynamic>>(
        ApiEndpoints.getLeadById(id),
        data: lead.toJson(),
      );

      if (response.data != null && response.data!['lead'] != null) {
        final updatedLead = LeadModel.fromJson(response.data!['lead'] as Map<String, dynamic>);
        AppLogger.info('Updated lead: ${updatedLead.customerName}');
        return updatedLead;
      }
      throw Exception('Failed to update lead');
    } catch (e) {
      AppLogger.error('Error updating lead: $e');
      rethrow;
    }
  }

  Future<void> deleteLead(String id) async {
    try {
      AppLogger.info('Deleting lead with id: $id');
      await _dioClient.delete<void>(
        ApiEndpoints.getLeadById(id),
      );
      AppLogger.info('Deleted lead successfully');
    } catch (e) {
      AppLogger.error('Error deleting lead: $e');
      rethrow;
    }
  }

  Future<List<LeadModel>> searchLeads({
    required String query,
    String? status,
    int? skip,
    int? take,
  }) async {
    try {
      AppLogger.info('Searching leads with query: $query');
      final response = await _dioClient.get<Map<String, dynamic>>(
        ApiEndpoints.searchLeads,
        queryParameters: {
          'query': query,
          if (status != null) 'status': status,
          if (skip != null) 'skip': skip,
          if (take != null) 'take': take,
        },
      );

      if (response.data != null && response.data!['results'] != null) {
        final results = (response.data!['results'] as List)
            .map((json) => LeadModel.fromJson(json as Map<String, dynamic>))
            .toList();
        AppLogger.info('Found ${results.length} matching leads');
        return results;
      }
      return [];
    } catch (e) {
      AppLogger.error('Error searching leads: $e');
      rethrow;
    }
  }
}
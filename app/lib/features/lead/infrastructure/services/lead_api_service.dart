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

      if (response.data != null && response.data!['items'] != null) {
        final leadsList = (response.data!['items'] as List)
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

      if (response.data != null) {
        final lead = LeadModel.fromJson(response.data!);
        AppLogger.info('Fetched lead: ${lead.customerName}');
        return lead;
      }
      throw Exception('Lead not found');
    } catch (e) {
      AppLogger.error('Error fetching lead by id: $e');
      rethrow;
    }
  }
}

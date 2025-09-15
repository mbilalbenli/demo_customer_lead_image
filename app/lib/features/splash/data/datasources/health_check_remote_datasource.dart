import '../../../../core/infrastructure/network/api_client.dart';
import '../../../../core/utils/constants.dart';
import '../models/health_check_model.dart';

abstract class HealthCheckRemoteDataSource {
  Future<HealthCheckModel> system();
  Future<HealthCheckModel> live();
  Future<HealthCheckModel> ready();
}

class HealthCheckRemoteDataSourceImpl implements HealthCheckRemoteDataSource {
  final ApiClient _api;
  HealthCheckRemoteDataSourceImpl({required ApiClient apiClient}) : _api = apiClient;

  @override
  Future<HealthCheckModel> system() async {
    final data = await _api.get<Map<String, dynamic>>(ApiEndpoints.health);
    return HealthCheckModel.fromJson(data);
  }

  @override
  Future<HealthCheckModel> live() async {
    final data = await _api.get<Map<String, dynamic>>(ApiEndpoints.healthLive);
    return HealthCheckModel.fromJson(data);
  }

  @override
  Future<HealthCheckModel> ready() async {
    final data = await _api.get<Map<String, dynamic>>(ApiEndpoints.healthReady);
    return HealthCheckModel.fromJson(data);
  }
}


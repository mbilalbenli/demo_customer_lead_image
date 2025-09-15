import '../entities/health_check_result.dart';

abstract class HealthCheckRepository {
  Future<HealthCheckResult> checkSystemHealth();
  Future<HealthCheckResult> checkLiveness();
  Future<HealthCheckResult> checkReadiness();
}


import '../../domain/entities/health_check_result.dart';
import '../../domain/repositories/health_check_repository.dart';
import '../datasources/health_check_remote_datasource.dart';

class HealthCheckRepositoryImpl implements HealthCheckRepository {
  final HealthCheckRemoteDataSource _remote;
  HealthCheckRepositoryImpl({required HealthCheckRemoteDataSource remote}) : _remote = remote;

  HealthCheckResult _map(String status) => HealthCheckResult(ok: status.toLowerCase() == 'healthy');

  @override
  Future<HealthCheckResult> checkSystemHealth() async {
    try {
      final dto = await _remote.system();
      return _map(dto.status);
    } catch (e) {
      return HealthCheckResult(ok: false, message: e.toString());
    }
  }

  @override
  Future<HealthCheckResult> checkLiveness() async {
    try {
      final dto = await _remote.live();
      return _map(dto.status);
    } catch (e) {
      return HealthCheckResult(ok: false, message: e.toString());
    }
  }

  @override
  Future<HealthCheckResult> checkReadiness() async {
    try {
      final dto = await _remote.ready();
      return _map(dto.status);
    } catch (e) {
      return HealthCheckResult(ok: false, message: e.toString());
    }
  }
}


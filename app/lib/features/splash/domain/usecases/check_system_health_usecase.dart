import '../entities/health_check_result.dart';
import '../repositories/health_check_repository.dart';

class CheckSystemHealthUseCase {
  final HealthCheckRepository _repo;
  CheckSystemHealthUseCase({required HealthCheckRepository repository}) : _repo = repository;

  Future<HealthCheckResult> execute() => _repo.checkSystemHealth();
}


import '../entities/health_check_result.dart';
import '../repositories/health_check_repository.dart';

class CheckReadinessUseCase {
  final HealthCheckRepository _repo;
  CheckReadinessUseCase({required HealthCheckRepository repository}) : _repo = repository;

  Future<HealthCheckResult> execute() => _repo.checkReadiness();
}


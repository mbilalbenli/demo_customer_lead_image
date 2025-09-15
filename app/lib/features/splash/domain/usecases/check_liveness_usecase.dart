import '../entities/health_check_result.dart';
import '../repositories/health_check_repository.dart';

class CheckLivenessUseCase {
  final HealthCheckRepository _repo;
  CheckLivenessUseCase({required HealthCheckRepository repository}) : _repo = repository;

  Future<HealthCheckResult> execute() => _repo.checkLiveness();
}


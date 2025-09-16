import 'package:dartz/dartz.dart';
import '../../domain/entities/lead_entity.dart';
import '../../domain/repositories/lead_repository.dart';

class GetLeadsListUseCase {
  final LeadRepository _repository;

  GetLeadsListUseCase(this._repository);

  Future<Either<Exception, List<LeadEntity>>> execute({
    int page = 1,
    int pageSize = 20,
  }) async {
    return await _repository.getLeadsList(page: page, pageSize: pageSize);
  }
}
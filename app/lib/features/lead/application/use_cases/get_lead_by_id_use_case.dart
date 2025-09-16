import 'package:dartz/dartz.dart';
import '../../domain/entities/lead_entity.dart';
import '../../domain/repositories/lead_repository.dart';

class GetLeadByIdUseCase {
  final LeadRepository _repository;

  GetLeadByIdUseCase(this._repository);

  Future<Either<Exception, LeadEntity>> execute(String id) async {
    return await _repository.getLeadById(id);
  }
}
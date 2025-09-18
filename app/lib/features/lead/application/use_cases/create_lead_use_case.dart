import 'package:dartz/dartz.dart';
import '../../domain/entities/lead_entity.dart';
import '../../domain/repositories/lead_repository.dart';

class CreateLeadUseCase {
  final LeadRepository _repository;

  CreateLeadUseCase(this._repository);

  Future<Either<Exception, LeadEntity>> execute({
    required String name,
    required String email,
    required String phone,
    String? description,
  }) {
    return _repository.createLead(
      name: name,
      email: email,
      phone: phone,
      description: description,
    );
  }
}


import 'package:dartz/dartz.dart';
import '../../domain/entities/lead_image_entity.dart';
import '../../domain/repositories/lead_image_repository.dart';

class GetImagesByLeadUseCase {
  final LeadImageRepository _repository;

  GetImagesByLeadUseCase(this._repository);

  Future<Either<Exception, List<LeadImageEntity>>> execute(
    String leadId, {
    int page = 1,
    int pageSize = 5,
  }) async {
    return await _repository.getImagesByLeadId(
      leadId,
      page: page,
      pageSize: pageSize,
    );
  }
}
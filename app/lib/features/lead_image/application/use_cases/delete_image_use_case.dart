import 'package:dartz/dartz.dart';
import '../../domain/repositories/lead_image_repository.dart';

class DeleteImageUseCase {
  final LeadImageRepository _repository;

  DeleteImageUseCase(this._repository);

  Future<Either<Exception, void>> execute({
    required String leadId,
    required String imageId,
  }) async {
    return await _repository.deleteImage(leadId: leadId, imageId: imageId);
  }
}

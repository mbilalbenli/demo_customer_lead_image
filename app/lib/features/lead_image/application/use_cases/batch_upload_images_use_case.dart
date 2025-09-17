import 'package:dartz/dartz.dart';
import '../../domain/entities/lead_image_entity.dart';
import '../../domain/repositories/lead_image_repository.dart';

class BatchUploadImagesUseCase {
  final LeadImageRepository _repository;
  BatchUploadImagesUseCase(this._repository);

  Future<Either<Exception, List<LeadImageEntity>>> execute({
    required String leadId,
    required List<Map<String, String>> images,
  }) async {
    return _repository.uploadMultipleImages(leadId: leadId, images: images);
  }
}


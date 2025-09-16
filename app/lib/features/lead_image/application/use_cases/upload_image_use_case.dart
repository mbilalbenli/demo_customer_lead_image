import 'package:dartz/dartz.dart';
import '../../domain/entities/lead_image_entity.dart';
import '../../domain/repositories/lead_image_repository.dart';
import '../../../../core/utils/app_logger.dart';

class UploadImageUseCase {
  final LeadImageRepository _repository;

  UploadImageUseCase(this._repository);

  Future<Either<Exception, LeadImageEntity>> execute({
    required String leadId,
    required String base64Data,
    required String fileName,
    String contentType = 'image/jpeg',
  }) async {
    try {
      AppLogger.info('Uploading image for lead: $leadId');

      // Check if we can add more images (enforces 10-image limit)
      final canAddResult = await _repository.canAddImage(leadId);
      return await canAddResult.fold(
        (error) {
          AppLogger.error('Failed to check image limit', error);
          return Left(error);
        },
        (canAdd) async {
          if (!canAdd) {
            AppLogger.warning('Image limit reached for lead: $leadId');
            return Left(Exception(
              'Maximum limit of 10 images reached. Please delete an existing image before uploading a new one.',
            ));
          }

          // Upload the image
          return await _repository.uploadImage(
            leadId: leadId,
            base64Data: base64Data,
            fileName: fileName,
            contentType: contentType,
          );
        },
      );
    } catch (e) {
      AppLogger.error('Failed to upload image', e);
      return Left(Exception(e.toString()));
    }
  }
}
import 'package:dartz/dartz.dart';
import '../entities/lead_image_entity.dart';

abstract class LeadImageRepository {
  Future<Either<Exception, List<LeadImageEntity>>> getImagesByLeadId(
    String leadId, {
    int page = 1,
    int pageSize = 5,
  });

  Future<Either<Exception, LeadImageEntity>> getImageById(String imageId);

  Future<Either<Exception, LeadImageEntity>> uploadImage({
    required String leadId,
    required String base64Data,
    required String fileName,
    required String contentType,
  });

  Future<Either<Exception, List<LeadImageEntity>>> uploadMultipleImages({
    required String leadId,
    required List<Map<String, String>> images, // base64Data, fileName, contentType
  });

  Future<Either<Exception, void>> deleteImage(String imageId);

  Future<Either<Exception, LeadImageEntity>> replaceImage({
    required String imageId,
    required String base64Data,
    required String fileName,
    required String contentType,
  });

  Future<Either<Exception, int>> getImageCount(String leadId);

  Future<Either<Exception, bool>> canAddImage(String leadId);

  Future<Either<Exception, Map<String, dynamic>>> getImageStatus(String leadId);

  Future<Either<Exception, void>> reorderImages({
    required String leadId,
    required List<String> imageIds,
  });

  Future<Either<Exception, void>> clearImageCache(String leadId);

  Future<Either<Exception, List<LeadImageEntity>>> getCachedImages(String leadId);

  Future<Either<Exception, void>> cacheImage(LeadImageEntity image);
}
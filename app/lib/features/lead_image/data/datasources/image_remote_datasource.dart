import '../models/lead_image_model.dart';
import '../../../../core/utils/app_logger.dart';
import '../../infrastructure/services/image_api_service.dart';
import '../../../../core/infrastructure/services/api_interceptors.dart';

abstract class ImageRemoteDataSource {
  Future<List<LeadImageModel>> getImagesByLeadId(String leadId, {int page = 1, int pageSize = 5});
  Future<LeadImageModel> getImageById(String imageId);
  Future<LeadImageModel> uploadImage({
    required String leadId,
    required String base64Data,
    required String fileName,
    required String contentType,
  });
  Future<List<LeadImageModel>> uploadMultipleImages({
    required String leadId,
    required List<Map<String, String>> images,
  });
  Future<void> deleteImage(String leadId, String imageId);
  Future<Map<String, dynamic>> getImageStatus(String leadId);
  Future<int> getImageCount(String leadId);
}

class ImageRemoteDataSourceImpl implements ImageRemoteDataSource {
  final ImageApiService _apiService;

  ImageRemoteDataSourceImpl({dynamic dio}) : _apiService = ImageApiService();

  @override
  Future<List<LeadImageModel>> getImagesByLeadId(
    String leadId, {
    int page = 1,
    int pageSize = 5,
  }) async {
    try {
      return await _apiService.getImagesByLeadId(leadId);
    } on ApiException catch (e) {
      AppLogger.error('Failed to fetch images: ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      AppLogger.error('Unexpected error fetching images: $e');
      throw Exception('Failed to fetch images');
    }
  }

  @override
  Future<LeadImageModel> getImageById(String imageId) async {
    try {
      // This endpoint is not in ImageApiService yet, using placeholder
      // TODO: Add endpoint to ImageApiService
      throw UnimplementedError('getImageById not yet implemented');
    } catch (e) {
      AppLogger.error('Failed to fetch image: $e');
      throw Exception('Failed to fetch image');
    }
  }

  @override
  Future<LeadImageModel> uploadImage({
    required String leadId,
    required String base64Data,
    required String fileName,
    required String contentType,
  }) async {
    try {
      // Check limit first
      final limitReached = await _apiService.checkImageLimit(leadId);
      if (limitReached) {
        throw Exception(
          'Maximum image limit reached (10). Please delete an existing image before uploading a new one.',
        );
      }

      return await _apiService.uploadImage(
        leadId: leadId,
        base64ImageData: base64Data,
        fileName: fileName,
        description: null,
      );
    } on ApiException catch (e) {
      AppLogger.error('Failed to upload image: ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      AppLogger.error('Unexpected error uploading image: $e');
      rethrow;
    }
  }

  @override
  Future<List<LeadImageModel>> uploadMultipleImages({
    required String leadId,
    required List<Map<String, String>> images,
  }) async {
    try {
      // Check limit first
      final count = await _apiService.getImageCount(leadId);
      const maxImages = 10;
      final availableSlots = maxImages - count;

      if (images.length > availableSlots) {
        throw Exception(
          'Cannot upload ${images.length} images. Only $availableSlots slot(s) available.',
        );
      }

      // Upload images one by one
      final uploadedImages = <LeadImageModel>[];
      for (final image in images) {
        final uploaded = await _apiService.uploadImage(
          leadId: leadId,
          base64ImageData: image['base64Data'] ?? '',
          fileName: image['fileName'] ?? 'image.jpg',
          description: image['description'],
        );
        uploadedImages.add(uploaded);
      }

      return uploadedImages;
    } on ApiException catch (e) {
      AppLogger.error('Failed to upload multiple images: ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      AppLogger.error('Unexpected error uploading multiple images: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteImage(String leadId, String imageId) async {
    try {
      await _apiService.deleteImage(imageId);
    } on ApiException catch (e) {
      AppLogger.error('Failed to delete image: ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      AppLogger.error('Unexpected error deleting image: $e');
      throw Exception('Failed to delete image');
    }
  }

  @override
  Future<Map<String, dynamic>> getImageStatus(String leadId) async {
    try {
      final count = await _apiService.getImageCount(leadId);
      const maxCount = 10;
      return {
        'currentCount': count,
        'maxCount': maxCount,
        'slotsAvailable': maxCount - count,
        'canAddMore': count < maxCount,
      };
    } catch (e) {
      AppLogger.error('Failed to get image status: $e');
      throw Exception('Failed to get image status');
    }
  }

  @override
  Future<int> getImageCount(String leadId) async {
    try {
      return await _apiService.getImageCount(leadId);
    } catch (e) {
      AppLogger.error('Failed to get image count: $e');
      throw Exception('Failed to get image count');
    }
  }

}
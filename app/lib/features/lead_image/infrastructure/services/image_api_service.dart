import '../../../../core/infrastructure/services/api_endpoints.dart';
import '../../../../core/infrastructure/services/dio_client.dart';
import '../../../../core/utils/app_logger.dart';
import '../../data/models/lead_image_model.dart';

class ImageApiService {
  final DioClient _dioClient = DioClient.instance;

  Future<List<LeadImageModel>> getImagesByLeadId(String leadId) async {
    try {
      AppLogger.info('Fetching images for lead: $leadId');
      final response = await _dioClient.get<Map<String, dynamic>>(
        ApiEndpoints.getImagesByLeadId(leadId),
      );

      if (response.data != null && response.data!['images'] != null) {
        final images = (response.data!['images'] as List)
            .map((json) => LeadImageModel.fromJson(json as Map<String, dynamic>))
            .toList();
        AppLogger.info('Fetched ${images.length} images');
        return images;
      }
      return [];
    } catch (e) {
      AppLogger.error('Error fetching images: $e');
      rethrow;
    }
  }

  Future<LeadImageModel> uploadImage({
    required String leadId,
    required String base64ImageData,
    required String fileName,
    String? description,
  }) async {
    try {
      AppLogger.info('Uploading image for lead: $leadId');
      final response = await _dioClient.post<Map<String, dynamic>>(
        ApiEndpoints.uploadImage,
        data: {
          'leadId': leadId,
          'base64ImageData': base64ImageData,
          'fileName': fileName,
          if (description != null) 'description': description,
        },
      );

      if (response.data != null && response.data!['image'] != null) {
        final uploadedImage = LeadImageModel.fromJson(
          response.data!['image'] as Map<String, dynamic>,
        );
        AppLogger.info('Uploaded image with id: ${uploadedImage.id}');
        return uploadedImage;
      }
      throw Exception('Failed to upload image');
    } catch (e) {
      AppLogger.error('Error uploading image: $e');
      rethrow;
    }
  }

  Future<void> deleteImage(String imageId) async {
    try {
      AppLogger.info('Deleting image: $imageId');
      await _dioClient.delete<void>(
        ApiEndpoints.getImageById(imageId),
      );
      AppLogger.info('Deleted image successfully');
    } catch (e) {
      AppLogger.error('Error deleting image: $e');
      rethrow;
    }
  }

  Future<int> getImageCount(String leadId) async {
    try {
      AppLogger.info('Getting image count for lead: $leadId');
      final response = await _dioClient.get<Map<String, dynamic>>(
        ApiEndpoints.getImageCount(leadId),
      );

      if (response.data != null && response.data!['count'] != null) {
        final count = response.data!['count'] as int;
        AppLogger.info('Lead has $count images');
        return count;
      }
      return 0;
    } catch (e) {
      AppLogger.error('Error getting image count: $e');
      rethrow;
    }
  }

  Future<LeadImageModel> replaceImage({
    required String imageId,
    required String base64ImageData,
    required String fileName,
    String? description,
  }) async {
    try {
      AppLogger.info('Replacing image: $imageId');
      final response = await _dioClient.put<Map<String, dynamic>>(
        ApiEndpoints.getReplaceImage(imageId),
        data: {
          'base64ImageData': base64ImageData,
          'fileName': fileName,
          if (description != null) 'description': description,
        },
      );

      if (response.data != null && response.data!['image'] != null) {
        final replacedImage = LeadImageModel.fromJson(
          response.data!['image'] as Map<String, dynamic>,
        );
        AppLogger.info('Replaced image successfully');
        return replacedImage;
      }
      throw Exception('Failed to replace image');
    } catch (e) {
      AppLogger.error('Error replacing image: $e');
      rethrow;
    }
  }

  Future<bool> checkImageLimit(String leadId) async {
    try {
      final count = await getImageCount(leadId);
      const maxImages = 10;
      final limitReached = count >= maxImages;
      AppLogger.info('Image limit check: $count/$maxImages - Limit reached: $limitReached');
      return limitReached;
    } catch (e) {
      AppLogger.error('Error checking image limit: $e');
      rethrow;
    }
  }
}
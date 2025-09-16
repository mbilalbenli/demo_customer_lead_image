import 'package:dio/dio.dart';
import '../models/lead_image_model.dart';
import '../../../../core/utils/app_logger.dart';

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
  Future<LeadImageModel> replaceImage({
    required String leadId,
    required String imageId,
    required String base64Data,
    required String fileName,
    required String contentType,
  });
  Future<Map<String, dynamic>> getImageStatus(String leadId);
  Future<int> getImageCount(String leadId);
}

class ImageRemoteDataSourceImpl implements ImageRemoteDataSource {
  final Dio _dio;
  static const String _baseUrl = '/api/leads';

  ImageRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<List<LeadImageModel>> getImagesByLeadId(
    String leadId, {
    int page = 1,
    int pageSize = 5,
  }) async {
    try {
      AppLogger.info('Fetching images for lead: $leadId, page: $page');

      final response = await _dio.get(
        '$_baseUrl/$leadId/images',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
        },
        options: Options(
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      final List<dynamic> data = response.data['items'] ?? [];
      final images = data.map((json) => LeadImageModel.fromJson(json)).toList();

      AppLogger.info('Fetched ${images.length} images for lead: $leadId');
      return images;
    } on DioException catch (e) {
      AppLogger.error('Failed to fetch images', e);
      throw _handleDioError(e);
    }
  }

  @override
  Future<LeadImageModel> getImageById(String imageId) async {
    try {
      AppLogger.info('Fetching image with id: $imageId');

      // Assuming endpoint structure based on RESTful conventions
      final response = await _dio.get(
        '$_baseUrl/images/$imageId',
        options: Options(
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      return LeadImageModel.fromJson(response.data);
    } on DioException catch (e) {
      AppLogger.error('Failed to fetch image', e);
      throw _handleDioError(e);
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
      AppLogger.info('Uploading image for lead: $leadId');

      // Check image status first
      final status = await getImageStatus(leadId);
      final currentCount = status['currentCount'] ?? 0;
      final maxCount = status['maxCount'] ?? 10;

      if (currentCount >= maxCount) {
        throw Exception(
          'Maximum image limit reached ($maxCount). Please delete an existing image before uploading a new one.',
        );
      }

      final response = await _dio.post(
        '$_baseUrl/$leadId/images',
        data: {
          'base64Image': base64Data,
          'fileName': fileName,
          'contentType': contentType,
        },
        options: Options(
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
        onSendProgress: (sent, total) {
          final progress = (sent / total * 100).toStringAsFixed(0);
          AppLogger.info('Upload progress: $progress%');
        },
      );

      AppLogger.info('Successfully uploaded image for lead: $leadId');
      return LeadImageModel.fromJson(response.data);
    } on DioException catch (e) {
      AppLogger.error('Failed to upload image', e);

      // Handle specific 409 Conflict for limit reached
      if (e.response?.statusCode == 409) {
        throw Exception(
          'Image limit reached. You have reached the maximum of 10 images for this lead. '
          'Please delete an existing image to upload a new one.',
        );
      }

      throw _handleDioError(e);
    }
  }

  @override
  Future<List<LeadImageModel>> uploadMultipleImages({
    required String leadId,
    required List<Map<String, String>> images,
  }) async {
    try {
      AppLogger.info('Uploading ${images.length} images for lead: $leadId');

      // Check how many slots are available
      final status = await getImageStatus(leadId);
      final currentCount = status['currentCount'] ?? 0;
      final maxCount = status['maxCount'] ?? 10;
      final availableSlots = maxCount - currentCount;

      if (images.length > availableSlots) {
        throw Exception(
          'Cannot upload ${images.length} images. Only $availableSlots slot(s) available.',
        );
      }

      final response = await _dio.post(
        '$_baseUrl/$leadId/images/batch',
        data: {
          'images': images,
        },
        options: Options(
          sendTimeout: const Duration(seconds: 120),
          receiveTimeout: const Duration(seconds: 120),
        ),
        onSendProgress: (sent, total) {
          final progress = (sent / total * 100).toStringAsFixed(0);
          AppLogger.info('Batch upload progress: $progress%');
        },
      );

      final List<dynamic> data = response.data['uploadedImages'] ?? [];
      final uploadedImages = data.map((json) => LeadImageModel.fromJson(json)).toList();

      AppLogger.info('Successfully uploaded ${uploadedImages.length} images');
      return uploadedImages;
    } on DioException catch (e) {
      AppLogger.error('Failed to upload multiple images', e);
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> deleteImage(String leadId, String imageId) async {
    try {
      AppLogger.info('Deleting image $imageId for lead: $leadId');

      await _dio.delete(
        '$_baseUrl/$leadId/images/$imageId',
      );

      AppLogger.info('Successfully deleted image: $imageId');
    } on DioException catch (e) {
      AppLogger.error('Failed to delete image', e);
      throw _handleDioError(e);
    }
  }

  @override
  Future<LeadImageModel> replaceImage({
    required String leadId,
    required String imageId,
    required String base64Data,
    required String fileName,
    required String contentType,
  }) async {
    try {
      AppLogger.info('Replacing image $imageId for lead: $leadId');

      final response = await _dio.put(
        '$_baseUrl/$leadId/images/$imageId/replace',
        data: {
          'base64Image': base64Data,
          'fileName': fileName,
          'contentType': contentType,
        },
        options: Options(
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
      );

      AppLogger.info('Successfully replaced image: $imageId');
      return LeadImageModel.fromJson(response.data);
    } on DioException catch (e) {
      AppLogger.error('Failed to replace image', e);
      throw _handleDioError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getImageStatus(String leadId) async {
    try {
      AppLogger.info('Fetching image status for lead: $leadId');

      final response = await _dio.get(
        '$_baseUrl/$leadId/image-status',
      );

      final status = response.data as Map<String, dynamic>;
      AppLogger.info(
        'Image status - Count: ${status['currentCount']}/${status['maxCount']}, '
        'Available: ${status['slotsAvailable']}',
      );

      return status;
    } on DioException catch (e) {
      AppLogger.error('Failed to fetch image status', e);
      throw _handleDioError(e);
    }
  }

  @override
  Future<int> getImageCount(String leadId) async {
    try {
      final status = await getImageStatus(leadId);
      return status['currentCount'] ?? 0;
    } catch (e) {
      AppLogger.error('Failed to get image count', e);
      throw Exception('Failed to get image count: $e');
    }
  }

  Exception _handleDioError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final message = error.response!.data?['message'] ??
                      error.response!.data?['error'] ??
                      'Unknown error occurred';

      switch (statusCode) {
        case 400:
          return Exception('Invalid request: $message');
        case 401:
          return Exception('Unauthorized: Please login again');
        case 404:
          return Exception('Resource not found');
        case 409:
          return Exception('Conflict: $message');
        case 413:
          return Exception('Image too large: Maximum size is 5MB');
        case 500:
          return Exception('Server error: Please try again later');
        default:
          return Exception('Error $statusCode: $message');
      }
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return Exception('Connection timeout: Please check your internet connection');
    }

    if (error.type == DioExceptionType.connectionError) {
      return Exception('Connection error: Please check your internet connection');
    }

    return Exception('An unexpected error occurred');
  }
}
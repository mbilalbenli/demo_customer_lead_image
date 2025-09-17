import 'dart:convert';
import '../../data/services/base64_encoder_service.dart';
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
        final list = response.data!['images'] as List;
        final images = <LeadImageModel>[];
        for (var i = 0; i < list.length; i++) {
          final item = list[i] as Map<String, dynamic>;
          final id = (item['id'] ?? item['imageId'] ?? '').toString();
          final fileName = (item['fileName'] ?? 'image.jpg').toString();
          final contentType = (item['contentType'] ?? 'image/jpeg').toString();
          final base64Data = (item['base64Data'] ?? item['base64'] ?? '').toString();

          // Calculate size in bytes from base64 or use provided size string
          int sizeInBytes;
          if (base64Data.isNotEmpty) {
            sizeInBytes = Base64EncoderService.calculateBase64Size(base64Data);
          } else if (item['size'] is String) {
            // Parse strings like "78.88 KB" ⇒ bytes (approx)
            final sz = (item['size'] as String).trim();
            final match = RegExp(r'([0-9]+(?:\.[0-9]+)?)\s*(B|KB|MB|GB)', caseSensitive: false).firstMatch(sz);
            if (match != null) {
              final numVal = double.tryParse(match.group(1)!) ?? 0;
              final unit = (match.group(2) ?? 'B').toUpperCase();
              final factor = unit == 'GB' ? 1024 * 1024 * 1024 : unit == 'MB' ? 1024 * 1024 : unit == 'KB' ? 1024 : 1;
              sizeInBytes = (numVal * factor).round();
            } else {
              sizeInBytes = 0;
            }
          } else {
            sizeInBytes = 0;
          }

          final uploadedAtStr = (item['uploadedAt'] ?? item['createdAt'])?.toString();
          final uploadedAt = uploadedAtStr != null ? DateTime.tryParse(uploadedAtStr) ?? DateTime.now() : DateTime.now();

          images.add(LeadImageModel(
            id: id,
            leadId: response.data!['leadId']?.toString() ?? leadId,
            base64Data: base64Data,
            fileName: fileName,
            contentType: contentType,
            sizeInBytes: sizeInBytes,
            orderIndex: i,
            uploadedAt: uploadedAt,
            createdAt: uploadedAt,
            updatedAt: null,
          ));
        }

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
    String? contentType,
    String? description,
  }) async {
    try {
      AppLogger.info('Uploading image for lead: $leadId');
      final response = await _dioClient.post<dynamic>(
        ApiEndpoints.postUploadImage(leadId),
        data: {
          // Some backends require leadId in body in addition to route param
          'leadId': leadId,
          'base64Image': base64ImageData,
          'fileName': fileName,
          if (contentType != null) 'contentType': contentType,
          if (description != null) 'description': description,
        },
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        // Path 1: API wraps image payload under `image`
        if (data['image'] is Map<String, dynamic>) {
          final uploadedImage = LeadImageModel.fromJson(
            data['image'] as Map<String, dynamic>,
          );
          AppLogger.info('Uploaded image with id: ${uploadedImage.id}');
          return uploadedImage;
        }

        // Path 2: API returns upload result with meta (imageId, leadId, fileName...)
        if (data.containsKey('imageId') || data.containsKey('id')) {
          final imageId = (data['imageId'] ?? data['id']).toString();
          final uploadedAtStr = (data['uploadedAt'] ?? data['createdAt'])?.toString();
          final uploadedAt = uploadedAtStr != null ? DateTime.tryParse(uploadedAtStr) : null;
          final currentCount = (data['currentImageCount'] is int) ? data['currentImageCount'] as int : 0;

          final bytesLen = base64ImageData.isNotEmpty ? base64.decode(base64ImageData).length : 0;

          final model = LeadImageModel(
            id: imageId,
            leadId: leadId,
            base64Data: base64ImageData,
            fileName: fileName,
            contentType: (contentType ?? 'image/jpeg'),
            sizeInBytes: bytesLen,
            orderIndex: currentCount > 0 ? currentCount - 1 : 0,
            uploadedAt: uploadedAt ?? DateTime.now(),
            createdAt: uploadedAt ?? DateTime.now(),
            updatedAt: null,
          );
          AppLogger.info('Uploaded image with id: ${model.id}');
          return model;
        }

        // Path 3: API returns the created image directly as JSON object
        try {
          final uploadedImage = LeadImageModel.fromJson(data);
          AppLogger.info('Uploaded image with id: ${uploadedImage.id}');
          return uploadedImage;
        } catch (_) {
          // fallthrough to String path
        }
      }

      // Path 4: API returned JSON as String
      if (data is String && data.trim().startsWith('{')) {
        final jsonMap = jsonDecode(data) as Map<String, dynamic>;
        try {
          final uploadedImage = LeadImageModel.fromJson(jsonMap);
          AppLogger.info('Uploaded image with id: ${uploadedImage.id}');
          return uploadedImage;
        } catch (_) {
          // Try to adapt meta-style string
          if (jsonMap.containsKey('imageId') || jsonMap.containsKey('id')) {
            final imageId = (jsonMap['imageId'] ?? jsonMap['id']).toString();
            final uploadedAtStr = (jsonMap['uploadedAt'] ?? jsonMap['createdAt'])?.toString();
            final uploadedAt = uploadedAtStr != null ? DateTime.tryParse(uploadedAtStr) : null;
            final currentCount = (jsonMap['currentImageCount'] is int) ? jsonMap['currentImageCount'] as int : 0;

            final bytesLen = base64ImageData.isNotEmpty ? base64.decode(base64ImageData).length : 0;

            final model = LeadImageModel(
              id: imageId,
              leadId: leadId,
              base64Data: base64ImageData,
              fileName: fileName,
              contentType: (contentType ?? 'image/jpeg'),
              sizeInBytes: bytesLen,
              orderIndex: currentCount > 0 ? currentCount - 1 : 0,
              uploadedAt: uploadedAt ?? DateTime.now(),
              createdAt: uploadedAt ?? DateTime.now(),
              updatedAt: null,
            );
            AppLogger.info('Uploaded image with id: ${model.id}');
            return model;
          }
        }
      }

      throw Exception('Failed to upload image');
    } catch (e) {
      AppLogger.error('Error uploading image: $e');
      rethrow;
    }
  }

  Future<void> deleteImage(String leadId, String imageId) async {
    try {
      AppLogger.info('Deleting image: $imageId');
      await _dioClient.delete<void>(
        ApiEndpoints.deleteImagePath(leadId, imageId),
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

      if (response.data != null) {
        // Support either { count: N } or { currentCount: N }
        final map = response.data!;
        final dynamicCount = map.containsKey('count')
            ? map['count']
            : map.containsKey('currentCount')
                ? map['currentCount']
                : null;
        if (dynamicCount is int) {
          final count = dynamicCount;
          AppLogger.info('Lead has $count images');
          return count;
        }
      }
      return 0;
    } catch (e) {
      AppLogger.error('Error getting image count: $e');
      rethrow;
    }
  }

  Future<LeadImageModel> replaceImage({
    required String leadId,
    required String imageId,
    required String base64ImageData,
    required String fileName,
    String? contentType,
    String? description,
  }) async {
    try {
      AppLogger.info('Replacing image: $imageId');
      final response = await _dioClient.put<Map<String, dynamic>>(
        ApiEndpoints.putReplaceImage(leadId, imageId),
        data: {
          'newBase64Image': base64ImageData,
          'newFileName': fileName,
          if (contentType != null) 'newContentType': contentType,
          if (description != null) 'newDescription': description,
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

  Future<List<LeadImageModel>> batchUploadImages({
    required String leadId,
    required List<Map<String, String>> images,
  }) async {
    try {
      await _dioClient.post<Map<String, dynamic>>(
        ApiEndpoints.postBatchUploadImages(leadId),
        data: {
          'images': images
              .map((e) => {
                    'base64Image': e['base64Data'],
                    'fileName': e['fileName'],
                    'contentType': e['contentType'],
                  })
              .toList(),
        },
      );
      // Ignore response mapping for now; repository provides refreshed list later
      return <LeadImageModel>[];
    } catch (e) {
      AppLogger.error('Error in batch upload: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> validateImage({
    required String leadId,
    required String base64Data,
    required String fileName,
    String? contentType,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        ApiEndpoints.postValidateImage(leadId),
        data: {
          'base64Image': base64Data,
          'fileName': fileName,
          if (contentType != null) 'contentType': contentType,
        },
      );
      return response.data ?? {};
    } catch (e) {
      AppLogger.error('Error validating image: $e');
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

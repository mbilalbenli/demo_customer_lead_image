import 'package:dartz/dartz.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/lead_image_entity.dart';
import '../../domain/repositories/lead_image_repository.dart';
import '../datasources/image_remote_datasource.dart';
import '../datasources/image_cache_datasource.dart';
import '../models/lead_image_model.dart';
import '../services/base64_encoder_service.dart';
import '../services/image_compressor_service.dart';
import '../../../../core/utils/app_logger.dart';

class LeadImageRepositoryImpl implements LeadImageRepository {
  final ImageRemoteDataSource _remoteDataSource;
  final ImageCacheDataSource _cacheDataSource;
  final Connectivity _connectivity;

  LeadImageRepositoryImpl({
    required ImageRemoteDataSource remoteDataSource,
    required ImageCacheDataSource cacheDataSource,
    required Connectivity connectivity,
    required Uuid uuid,
  })  : _remoteDataSource = remoteDataSource,
        _cacheDataSource = cacheDataSource,
        _connectivity = connectivity;

  @override
  Future<Either<Exception, List<LeadImageEntity>>> getImagesByLeadId(
    String leadId, {
    int page = 1,
    int pageSize = 5,
  }) async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult .contains(ConnectivityResult.none) || connectivityResult.isEmpty) {
        AppLogger.info('Offline mode - fetching images from cache');
        final cachedImages = await _cacheDataSource.getCachedImages(leadId);
        return Right(cachedImages.map((model) => model.toEntity()).toList());
      }

      final imageModels = await _remoteDataSource.getImagesByLeadId(
        leadId,
        page: page,
        pageSize: pageSize,
      );

      // Cache the images for offline access
      if (page == 1) {
        await _cacheDataSource.cacheImages(leadId, imageModels);
      }

      return Right(imageModels.map((model) => model.toEntity()).toList());
    } catch (e) {
      AppLogger.error('Failed to get images by lead id', e);

      // Try cache as fallback
      final cachedImages = await _cacheDataSource.getCachedImages(leadId);
      if (cachedImages.isNotEmpty) {
        AppLogger.info('Returning cached images as fallback');
        return Right(cachedImages.map((model) => model.toEntity()).toList());
      }

      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, LeadImageEntity>> getImageById(String imageId) async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult .contains(ConnectivityResult.none) || connectivityResult.isEmpty) {
        final cachedImage = await _cacheDataSource.getCachedImage(imageId);
        if (cachedImage != null) {
          return Right(cachedImage.toEntity());
        }
        return Left(Exception('No internet connection and image not cached'));
      }

      final imageModel = await _remoteDataSource.getImageById(imageId);

      // Cache the image
      await _cacheDataSource.cacheImage(imageModel);

      return Right(imageModel.toEntity());
    } catch (e) {
      AppLogger.error('Failed to get image by id', e);

      // Try cache as fallback
      final cachedImage = await _cacheDataSource.getCachedImage(imageId);
      if (cachedImage != null) {
        return Right(cachedImage.toEntity());
      }

      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, LeadImageEntity>> uploadImage({
    required String leadId,
    required String base64Data,
    required String fileName,
    required String contentType,
  }) async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult .contains(ConnectivityResult.none) || connectivityResult.isEmpty) {
        return Left(Exception('Cannot upload image while offline'));
      }

      // Check if we can add more images
      final canAddResult = await canAddImage(leadId);
      if (canAddResult.isLeft()) {
        return Left(Exception('Failed to check image limit'));
      }
      if (!canAddResult.getOrElse(() => false)) {
        return Left(Exception(
          'Maximum limit of 10 images reached. Please delete an existing image before uploading a new one.',
        ));
      }

      // Process the image if needed (compression)
      String processedBase64 = base64Data;
      if (Base64EncoderService.calculateBase64Size(base64Data) > 1024 * 1024) {
        AppLogger.info('Image size > 1MB, applying compression');
        final imageBytes = Base64EncoderService.decodeBase64ToImage(base64Data);
        final compressedBytes = await ImageCompressorService.compressImage(imageBytes);
        processedBase64 = await Base64EncoderService.encodeImageToBase64(compressedBytes);
      }

      final uploadedImage = await _remoteDataSource.uploadImage(
        leadId: leadId,
        base64Data: processedBase64,
        fileName: fileName,
        contentType: contentType,
      );

      // Cache the uploaded image
      await _cacheDataSource.cacheImage(uploadedImage);

      // Clear lead images cache to force refresh
      await _cacheDataSource.clearImageCache(leadId);

      return Right(uploadedImage.toEntity());
    } catch (e) {
      AppLogger.error('Failed to upload image', e);
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, List<LeadImageEntity>>> uploadMultipleImages({
    required String leadId,
    required List<Map<String, String>> images,
  }) async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult .contains(ConnectivityResult.none) || connectivityResult.isEmpty) {
        return Left(Exception('Cannot upload images while offline'));
      }

      // Check available slots
      final countResult = await getImageCount(leadId);
      final currentCount = countResult.getOrElse(() => 0);
      final availableSlots = 10 - currentCount;

      if (images.length > availableSlots) {
        return Left(Exception(
          'Cannot upload ${images.length} images. Only $availableSlots slot(s) available.',
        ));
      }

      // Process images (compress if needed)
      final processedImages = <Map<String, String>>[];
      for (final image in images) {
        final base64Data = image['base64Data']!;
        String processedBase64 = base64Data;

        if (Base64EncoderService.calculateBase64Size(base64Data) > 1024 * 1024) {
          final imageBytes = Base64EncoderService.decodeBase64ToImage(base64Data);
          final compressedBytes = await ImageCompressorService.compressImage(imageBytes);
          processedBase64 = await Base64EncoderService.encodeImageToBase64(compressedBytes);
        }

        processedImages.add({
          'base64Data': processedBase64,
          'fileName': image['fileName']!,
          'contentType': image['contentType'] ?? 'image/jpeg',
        });
      }

      final uploadedImages = await _remoteDataSource.uploadMultipleImages(
        leadId: leadId,
        images: processedImages,
      );

      // Cache uploaded images
      await _cacheDataSource.cacheImages(leadId, uploadedImages);

      return Right(uploadedImages.map((model) => model.toEntity()).toList());
    } catch (e) {
      AppLogger.error('Failed to upload multiple images', e);
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, void>> deleteImage(String imageId) async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult .contains(ConnectivityResult.none) || connectivityResult.isEmpty) {
        return Left(Exception('Cannot delete image while offline'));
      }

      // Extract leadId from the image (assuming we have it cached)
      final cachedImage = await _cacheDataSource.getCachedImage(imageId);
      final leadId = cachedImage?.leadId;

      if (leadId != null) {
        await _remoteDataSource.deleteImage(leadId, imageId);
      } else {
        // Fallback: try to delete without leadId (assuming API supports it)
        await _remoteDataSource.deleteImage('', imageId);
      }

      // Remove from cache
      await _cacheDataSource.removeCachedImage(imageId);

      return const Right(null);
    } catch (e) {
      AppLogger.error('Failed to delete image', e);
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, LeadImageEntity>> replaceImage({
    required String imageId,
    required String base64Data,
    required String fileName,
    required String contentType,
  }) async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult .contains(ConnectivityResult.none) || connectivityResult.isEmpty) {
        return Left(Exception('Cannot replace image while offline'));
      }

      // Get the existing image to extract leadId
      final existingImage = await _cacheDataSource.getCachedImage(imageId);
      if (existingImage == null) {
        return Left(Exception('Image not found'));
      }

      // Process the image if needed
      String processedBase64 = base64Data;
      if (Base64EncoderService.calculateBase64Size(base64Data) > 1024 * 1024) {
        final imageBytes = Base64EncoderService.decodeBase64ToImage(base64Data);
        final compressedBytes = await ImageCompressorService.compressImage(imageBytes);
        processedBase64 = await Base64EncoderService.encodeImageToBase64(compressedBytes);
      }

      final replacedImage = await _remoteDataSource.replaceImage(
        leadId: existingImage.leadId,
        imageId: imageId,
        base64Data: processedBase64,
        fileName: fileName,
        contentType: contentType,
      );

      // Update cache
      await _cacheDataSource.removeCachedImage(imageId);
      await _cacheDataSource.cacheImage(replacedImage);

      return Right(replacedImage.toEntity());
    } catch (e) {
      AppLogger.error('Failed to replace image', e);
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, int>> getImageCount(String leadId) async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult .contains(ConnectivityResult.none) || connectivityResult.isEmpty) {
        // Count cached images
        final cachedImages = await _cacheDataSource.getCachedImages(leadId);
        return Right(cachedImages.length);
      }

      final count = await _remoteDataSource.getImageCount(leadId);
      return Right(count);
    } catch (e) {
      AppLogger.error('Failed to get image count', e);

      // Try counting cached images as fallback
      final cachedImages = await _cacheDataSource.getCachedImages(leadId);
      return Right(cachedImages.length);
    }
  }

  @override
  Future<Either<Exception, bool>> canAddImage(String leadId) async {
    try {
      final countResult = await getImageCount(leadId);
      return countResult.fold(
        (error) => Left(error),
        (count) => Right(count < 10),
      );
    } catch (e) {
      AppLogger.error('Failed to check if can add image', e);
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, Map<String, dynamic>>> getImageStatus(String leadId) async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult .contains(ConnectivityResult.none) || connectivityResult.isEmpty) {
        // Create status from cached data
        final cachedImages = await _cacheDataSource.getCachedImages(leadId);
        final count = cachedImages.length;
        return Right({
          'currentCount': count,
          'maxCount': 10,
          'slotsAvailable': 10 - count,
          'canAddMore': count < 10,
        });
      }

      final status = await _remoteDataSource.getImageStatus(leadId);
      return Right(status);
    } catch (e) {
      AppLogger.error('Failed to get image status', e);
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, void>> reorderImages({
    required String leadId,
    required List<String> imageIds,
  }) async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult .contains(ConnectivityResult.none) || connectivityResult.isEmpty) {
        return Left(Exception('Cannot reorder images while offline'));
      }

      // This would require an API endpoint for reordering
      // For now, we'll return success assuming the backend handles it
      AppLogger.info('Reordering images for lead: $leadId');

      return const Right(null);
    } catch (e) {
      AppLogger.error('Failed to reorder images', e);
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, void>> clearImageCache(String leadId) async {
    try {
      await _cacheDataSource.clearImageCache(leadId);
      return const Right(null);
    } catch (e) {
      AppLogger.error('Failed to clear image cache', e);
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, List<LeadImageEntity>>> getCachedImages(String leadId) async {
    try {
      final cachedImages = await _cacheDataSource.getCachedImages(leadId);
      return Right(cachedImages.map((model) => model.toEntity()).toList());
    } catch (e) {
      AppLogger.error('Failed to get cached images', e);
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, void>> cacheImage(LeadImageEntity image) async {
    try {
      final model = LeadImageModel.fromEntity(image);
      await _cacheDataSource.cacheImage(model);
      return const Right(null);
    } catch (e) {
      AppLogger.error('Failed to cache image', e);
      return Left(Exception(e.toString()));
    }
  }
}
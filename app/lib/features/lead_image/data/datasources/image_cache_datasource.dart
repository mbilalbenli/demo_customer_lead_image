import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lead_image_model.dart';
import '../../domain/constants/image_constants.dart';
import '../../../../core/utils/app_logger.dart';

abstract class ImageCacheDataSource {
  Future<void> cacheImage(LeadImageModel image);
  Future<void> cacheImages(String leadId, List<LeadImageModel> images);
  Future<List<LeadImageModel>> getCachedImages(String leadId);
  Future<LeadImageModel?> getCachedImage(String imageId);
  Future<void> removeCachedImage(String imageId);
  Future<void> clearImageCache(String leadId);
  Future<void> clearAllCache();
  Future<int> getCacheSize();
  Future<void> performCacheMaintenance();
}

class ImageCacheDataSourceImpl implements ImageCacheDataSource {
  final SharedPreferences _sharedPreferences;

  static const String _imagePrefix = 'cached_image_';
  static const String _leadImagesPrefix = 'cached_lead_images_';
  static const String _cacheIndexKey = 'image_cache_index';
  static const String _cacheAccessKey = 'image_cache_access_';
  static const int _maxCacheSizeBytes = ImageConstants.maxCacheSizeMB * 1024 * 1024;
  static const Duration _cacheValidity = Duration(hours: 24);

  ImageCacheDataSourceImpl({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  @override
  Future<void> cacheImage(LeadImageModel image) async {
    try {
      AppLogger.info('Caching image: ${image.id}');

      // Check cache size before adding
      await _ensureCacheSpace(image.sizeInBytes);

      // Save image data
      final jsonString = json.encode(image.toJson());
      await _sharedPreferences.setString('$_imagePrefix${image.id}', jsonString);

      // Update cache index
      _updateCacheIndex(image.id);

      // Update access time
      await _updateAccessTime(image.id);

      AppLogger.info('Successfully cached image: ${image.id}');
    } catch (e) {
      AppLogger.error('Failed to cache image', e);
    }
  }

  @override
  Future<void> cacheImages(String leadId, List<LeadImageModel> images) async {
    try {
      AppLogger.info('Caching ${images.length} images for lead: $leadId');

      // Calculate total size
      final totalSize = images.fold<int>(
        0,
        (sum, image) => sum + image.sizeInBytes,
      );

      // Ensure we have space
      await _ensureCacheSpace(totalSize);

      // Cache individual images
      for (final image in images) {
        await cacheImage(image);
      }

      // Save the image list for the lead
      final imageIds = images.map((img) => img.id).toList();
      await _sharedPreferences.setStringList(
        '$_leadImagesPrefix$leadId',
        imageIds,
      );

      AppLogger.info('Successfully cached ${images.length} images for lead: $leadId');
    } catch (e) {
      AppLogger.error('Failed to cache images for lead', e);
    }
  }

  @override
  Future<List<LeadImageModel>> getCachedImages(String leadId) async {
    try {
      AppLogger.info('Fetching cached images for lead: $leadId');

      final imageIds = _sharedPreferences.getStringList('$_leadImagesPrefix$leadId');
      if (imageIds == null || imageIds.isEmpty) {
        return [];
      }

      final images = <LeadImageModel>[];
      for (final imageId in imageIds) {
        final image = await getCachedImage(imageId);
        if (image != null) {
          images.add(image);
        }
      }

      AppLogger.info('Retrieved ${images.length} cached images for lead: $leadId');
      return images;
    } catch (e) {
      AppLogger.error('Failed to get cached images', e);
      return [];
    }
  }

  @override
  Future<LeadImageModel?> getCachedImage(String imageId) async {
    try {
      AppLogger.info('Fetching cached image: $imageId');

      final jsonString = _sharedPreferences.getString('$_imagePrefix$imageId');
      if (jsonString == null) {
        return null;
      }

      // Update access time (for LRU)
      await _updateAccessTime(imageId);

      final jsonMap = json.decode(jsonString);
      return LeadImageModel.fromJson(jsonMap);
    } catch (e) {
      AppLogger.error('Failed to get cached image', e);
      return null;
    }
  }

  @override
  Future<void> removeCachedImage(String imageId) async {
    try {
      AppLogger.info('Removing cached image: $imageId');

      await _sharedPreferences.remove('$_imagePrefix$imageId');
      await _sharedPreferences.remove('$_cacheAccessKey$imageId');

      // Update cache index
      final index = _getCacheIndex();
      index.remove(imageId);
      await _saveCacheIndex(index);

      AppLogger.info('Successfully removed cached image: $imageId');
    } catch (e) {
      AppLogger.error('Failed to remove cached image', e);
    }
  }

  @override
  Future<void> clearImageCache(String leadId) async {
    try {
      AppLogger.info('Clearing image cache for lead: $leadId');

      final imageIds = _sharedPreferences.getStringList('$_leadImagesPrefix$leadId');
      if (imageIds != null) {
        for (final imageId in imageIds) {
          await removeCachedImage(imageId);
        }
      }

      await _sharedPreferences.remove('$_leadImagesPrefix$leadId');

      AppLogger.info('Successfully cleared image cache for lead: $leadId');
    } catch (e) {
      AppLogger.error('Failed to clear image cache for lead', e);
    }
  }

  @override
  Future<void> clearAllCache() async {
    try {
      AppLogger.info('Clearing all image cache');

      final keys = _sharedPreferences.getKeys();
      for (final key in keys) {
        if (key.startsWith(_imagePrefix) ||
            key.startsWith(_leadImagesPrefix) ||
            key.startsWith(_cacheAccessKey) ||
            key == _cacheIndexKey) {
          await _sharedPreferences.remove(key);
        }
      }

      AppLogger.info('Successfully cleared all image cache');
    } catch (e) {
      AppLogger.error('Failed to clear all cache', e);
    }
  }

  @override
  Future<int> getCacheSize() async {
    try {
      int totalSize = 0;
      final index = _getCacheIndex();

      for (final imageId in index) {
        final jsonString = _sharedPreferences.getString('$_imagePrefix$imageId');
        if (jsonString != null) {
          // Approximate size of cached data
          totalSize += jsonString.length;
        }
      }

      return totalSize;
    } catch (e) {
      AppLogger.error('Failed to calculate cache size', e);
      return 0;
    }
  }

  @override
  Future<void> performCacheMaintenance() async {
    try {
      AppLogger.info('Performing cache maintenance');

      // Remove expired items
      await _removeExpiredItems();

      // Ensure cache size is within limits
      await _enforeCacheSizeLimit();

      AppLogger.info('Cache maintenance completed');
    } catch (e) {
      AppLogger.error('Failed to perform cache maintenance', e);
    }
  }

  Future<void> _ensureCacheSpace(int requiredBytes) async {
    final currentSize = await getCacheSize();

    if (currentSize + requiredBytes > _maxCacheSizeBytes) {
      AppLogger.info('Cache limit exceeded, performing LRU eviction');

      // Get all cached images with access times
      final accessTimes = <String, int>{};
      final index = _getCacheIndex();

      for (final imageId in index) {
        final accessTime = _sharedPreferences.getInt('$_cacheAccessKey$imageId') ?? 0;
        accessTimes[imageId] = accessTime;
      }

      // Sort by access time (oldest first)
      final sortedIds = accessTimes.keys.toList()
        ..sort((a, b) => accessTimes[a]!.compareTo(accessTimes[b]!));

      // Remove oldest items until we have enough space
      int freedSpace = 0;
      for (final imageId in sortedIds) {
        if (currentSize - freedSpace + requiredBytes <= _maxCacheSizeBytes) {
          break;
        }

        final jsonString = _sharedPreferences.getString('$_imagePrefix$imageId');
        if (jsonString != null) {
          freedSpace += jsonString.length;
          await removeCachedImage(imageId);
        }
      }
    }
  }

  void _updateCacheIndex(String imageId) {
    final index = _getCacheIndex();
    if (!index.contains(imageId)) {
      index.add(imageId);
      _saveCacheIndex(index);
    }
  }

  List<String> _getCacheIndex() {
    return _sharedPreferences.getStringList(_cacheIndexKey) ?? [];
  }

  Future<void> _saveCacheIndex(List<String> index) async {
    await _sharedPreferences.setStringList(_cacheIndexKey, index);
  }

  Future<void> _updateAccessTime(String imageId) async {
    await _sharedPreferences.setInt(
      '$_cacheAccessKey$imageId',
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<void> _removeExpiredItems() async {
    final index = _getCacheIndex();
    final now = DateTime.now().millisecondsSinceEpoch;
    final expirationTime = _cacheValidity.inMilliseconds;

    for (final imageId in List.from(index)) {
      final accessTime = _sharedPreferences.getInt('$_cacheAccessKey$imageId') ?? 0;
      if (now - accessTime > expirationTime) {
        await removeCachedImage(imageId);
      }
    }
  }

  Future<void> _enforeCacheSizeLimit() async {
    final currentSize = await getCacheSize();
    if (currentSize > _maxCacheSizeBytes) {
      await _ensureCacheSpace(0);
    }
  }
}
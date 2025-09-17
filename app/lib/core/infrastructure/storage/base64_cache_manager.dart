import 'dart:collection';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_logger.dart';

class Base64CacheManager {
  static const String _cacheKeyPrefix = 'base64_cache_';
  static const String _cacheKeysListKey = 'base64_cache_keys';
  static const int _maxCacheSizeMB = 50; // Maximum cache size in MB
  static const int _maxCacheItems = 100; // Maximum number of cached items

  final SharedPreferences _prefs;
  final LinkedHashMap<String, String> _memoryCache = LinkedHashMap();

  Base64CacheManager({required SharedPreferences prefs}) : _prefs = prefs;

  Future<void> cacheBase64Image(String key, String base64String) async {
    try {
      AppLogger.info('Caching Base64 image with key: $key');

      // Check cache size limit
      if (await _isCacheFull(base64String)) {
        await _evictOldestEntry();
      }

      // Store in memory cache
      _memoryCache[key] = base64String;

      // Store in persistent cache
      final cacheKey = '$_cacheKeyPrefix$key';
      await _prefs.setString(cacheKey, base64String);

      // Update cache keys list
      await _updateCacheKeysList(key);

      AppLogger.info('Base64 image cached successfully');
    } catch (e) {
      AppLogger.error('Failed to cache Base64 image', e);
    }
  }

  Future<String?> getCachedBase64Image(String key) async {
    try {
      // Check memory cache first
      if (_memoryCache.containsKey(key)) {
        AppLogger.info('Base64 image found in memory cache');
        // Move to end (LRU)
        final value = _memoryCache.remove(key)!;
        _memoryCache[key] = value;
        return value;
      }

      // Check persistent cache
      final cacheKey = '$_cacheKeyPrefix$key';
      final base64String = _prefs.getString(cacheKey);

      if (base64String != null) {
        AppLogger.info('Base64 image found in persistent cache');
        // Add to memory cache
        _memoryCache[key] = base64String;
        // Limit memory cache size
        if (_memoryCache.length > 10) {
          _memoryCache.remove(_memoryCache.keys.first);
        }
      }

      return base64String;
    } catch (e) {
      AppLogger.error('Failed to get cached Base64 image', e);
      return null;
    }
  }

  Future<void> removeCachedImage(String key) async {
    try {
      AppLogger.info('Removing cached Base64 image with key: $key');

      // Remove from memory cache
      _memoryCache.remove(key);

      // Remove from persistent cache
      final cacheKey = '$_cacheKeyPrefix$key';
      await _prefs.remove(cacheKey);

      // Update cache keys list
      final keys = _prefs.getStringList(_cacheKeysListKey) ?? [];
      keys.remove(key);
      await _prefs.setStringList(_cacheKeysListKey, keys);

      AppLogger.info('Cached Base64 image removed');
    } catch (e) {
      AppLogger.error('Failed to remove cached Base64 image', e);
    }
  }

  Future<void> clearCache() async {
    try {
      AppLogger.info('Clearing all cached Base64 images');

      // Clear memory cache
      _memoryCache.clear();

      // Get all cache keys
      final keys = _prefs.getStringList(_cacheKeysListKey) ?? [];

      // Remove all cached images
      for (final key in keys) {
        final cacheKey = '$_cacheKeyPrefix$key';
        await _prefs.remove(cacheKey);
      }

      // Clear cache keys list
      await _prefs.remove(_cacheKeysListKey);

      AppLogger.info('Cache cleared successfully');
    } catch (e) {
      AppLogger.error('Failed to clear cache', e);
    }
  }

  Future<int> getCacheSize() async {
    try {
      final keys = _prefs.getStringList(_cacheKeysListKey) ?? [];
      int totalSize = 0;

      for (final key in keys) {
        final cacheKey = '$_cacheKeyPrefix$key';
        final base64String = _prefs.getString(cacheKey);
        if (base64String != null) {
          totalSize += base64String.length;
        }
      }

      // Convert to MB
      return (totalSize / (1024 * 1024)).round();
    } catch (e) {
      AppLogger.error('Failed to calculate cache size', e);
      return 0;
    }
  }

  Future<int> getCacheItemCount() async {
    try {
      final keys = _prefs.getStringList(_cacheKeysListKey) ?? [];
      return keys.length;
    } catch (e) {
      AppLogger.error('Failed to get cache item count', e);
      return 0;
    }
  }

  Future<bool> _isCacheFull(String newBase64String) async {
    final currentSizeMB = await getCacheSize();
    final newSizeMB = newBase64String.length / (1024 * 1024);
    final itemCount = await getCacheItemCount();

    return (currentSizeMB + newSizeMB > _maxCacheSizeMB) ||
           (itemCount >= _maxCacheItems);
  }

  Future<void> _evictOldestEntry() async {
    try {
      AppLogger.info('Evicting oldest cache entry (LRU)');

      final keys = _prefs.getStringList(_cacheKeysListKey) ?? [];
      if (keys.isNotEmpty) {
        final oldestKey = keys.first;
        await removeCachedImage(oldestKey);
      }
    } catch (e) {
      AppLogger.error('Failed to evict oldest cache entry', e);
    }
  }

  Future<void> _updateCacheKeysList(String key) async {
    try {
      final keys = _prefs.getStringList(_cacheKeysListKey) ?? [];

      // Remove if exists (to move to end)
      keys.remove(key);

      // Add to end (most recent)
      keys.add(key);

      await _prefs.setStringList(_cacheKeysListKey, keys);
    } catch (e) {
      AppLogger.error('Failed to update cache keys list', e);
    }
  }

  Future<void> preloadImages(List<String> keys) async {
    try {
      AppLogger.info('Preloading ${keys.length} images to cache');

      for (final key in keys) {
        final base64String = await getCachedBase64Image(key);
        if (base64String != null) {
          _memoryCache[key] = base64String;

          // Limit memory cache size
          if (_memoryCache.length > 10) {
            _memoryCache.remove(_memoryCache.keys.first);
          }
        }
      }

      AppLogger.info('Preloading completed');
    } catch (e) {
      AppLogger.error('Failed to preload images', e);
    }
  }

  bool isInMemoryCache(String key) {
    return _memoryCache.containsKey(key);
  }

  void clearMemoryCache() {
    _memoryCache.clear();
    AppLogger.info('Memory cache cleared');
  }
}
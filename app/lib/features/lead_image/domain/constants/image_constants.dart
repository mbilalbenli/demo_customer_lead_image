class ImageConstants {
  static const int maxImageSizeBytes = 5242880; // 5MB
  static const int maxImagesPerLead = 10;
  static const List<String> supportedFormats = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
  static const String base64ImagePrefix = 'data:image/';
  static const int thumbnailSize = 150;
  static const int compressionQuality = 85;
  static const int maxCacheSizeMB = 50;

  const ImageConstants._();
}
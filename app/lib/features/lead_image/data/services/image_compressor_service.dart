import 'dart:typed_data';
import 'package:image/image.dart' as img;
import '../../domain/constants/image_constants.dart';
import '../../../../core/utils/app_logger.dart';

class ImageCompressorService {
  static Future<Uint8List> compressImage(
    Uint8List imageBytes, {
    int quality = ImageConstants.compressionQuality,
    int? maxWidth,
    int? maxHeight,
    bool maintainAspectRatio = true,
  }) async {
    try {
      AppLogger.info('Starting image compression, original size: ${imageBytes.length} bytes');

      // Decode the image
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        throw Exception('Failed to decode image for compression');
      }

      AppLogger.info('Original dimensions: ${image.width}x${image.height}');

      // Resize if needed
      img.Image processedImage = image;
      if ((maxWidth != null && image.width > maxWidth) ||
          (maxHeight != null && image.height > maxHeight)) {
        processedImage = _resizeImage(
          image,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          maintainAspectRatio: maintainAspectRatio,
        );
        AppLogger.info('Resized to: ${processedImage.width}x${processedImage.height}');
      }

      // Determine format and compress
      Uint8List compressedBytes;
      final format = _detectImageFormat(imageBytes);

      if (format == ImageFormat.png) {
        compressedBytes = Uint8List.fromList(
          img.encodePng(processedImage, level: 6),
        );
      } else {
        compressedBytes = Uint8List.fromList(
          img.encodeJpg(processedImage, quality: quality),
        );
      }

      AppLogger.info('Compressed size: ${compressedBytes.length} bytes');

      // Check if still too large
      if (compressedBytes.length > ImageConstants.maxImageSizeBytes) {
        AppLogger.info('Still too large, applying aggressive compression');
        return _aggressiveCompress(processedImage);
      }

      return compressedBytes;
    } catch (e) {
      AppLogger.error('Failed to compress image', e);
      throw Exception('Image compression failed: $e');
    }
  }

  static img.Image _resizeImage(
    img.Image image, {
    int? maxWidth,
    int? maxHeight,
    bool maintainAspectRatio = true,
  }) {
    if (!maintainAspectRatio) {
      return img.copyResize(
        image,
        width: maxWidth ?? image.width,
        height: maxHeight ?? image.height,
      );
    }

    // Calculate dimensions maintaining aspect ratio
    double aspectRatio = image.width / image.height;
    int newWidth = image.width;
    int newHeight = image.height;

    if (maxWidth != null && image.width > maxWidth) {
      newWidth = maxWidth;
      newHeight = (maxWidth / aspectRatio).round();
    }

    if (maxHeight != null && newHeight > maxHeight) {
      newHeight = maxHeight;
      newWidth = (maxHeight * aspectRatio).round();
    }

    return img.copyResize(
      image,
      width: newWidth,
      height: newHeight,
      interpolation: img.Interpolation.linear,
    );
  }

  static Uint8List _aggressiveCompress(img.Image image) {
    // Try progressively lower quality settings
    for (int quality = 60; quality >= 30; quality -= 10) {
      final compressed = Uint8List.fromList(
        img.encodeJpg(image, quality: quality),
      );

      if (compressed.length <= ImageConstants.maxImageSizeBytes) {
        AppLogger.info('Aggressive compression succeeded at quality: $quality');
        return compressed;
      }
    }

    // If still too large, resize and compress
    final resized = img.copyResize(
      image,
      width: image.width ~/ 2,
      height: image.height ~/ 2,
    );

    return Uint8List.fromList(
      img.encodeJpg(resized, quality: 30),
    );
  }

  static ImageFormat _detectImageFormat(Uint8List bytes) {
    if (bytes.length < 4) return ImageFormat.unknown;

    // Check PNG signature
    if (bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return ImageFormat.png;
    }

    // Check JPEG signature
    if (bytes[0] == 0xFF && bytes[1] == 0xD8) {
      return ImageFormat.jpeg;
    }

    // Check GIF signature
    if (bytes[0] == 0x47 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46) {
      return ImageFormat.gif;
    }

    // Check WebP signature
    if (bytes.length > 12 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50) {
      return ImageFormat.webp;
    }

    return ImageFormat.unknown;
  }

  static Future<Map<String, dynamic>> getImageInfo(Uint8List imageBytes) async {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      return {
        'width': image.width,
        'height': image.height,
        'sizeInBytes': imageBytes.length,
        'format': _detectImageFormat(imageBytes).name,
      };
    } catch (e) {
      AppLogger.error('Failed to get image info', e);
      throw Exception('Failed to get image info: $e');
    }
  }
}

enum ImageFormat {
  jpeg,
  png,
  gif,
  webp,
  unknown,
}
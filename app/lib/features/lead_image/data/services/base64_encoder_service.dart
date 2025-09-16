import 'dart:convert';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import '../../domain/constants/image_constants.dart';
import '../../../../core/utils/app_logger.dart';

class Base64EncoderService {
  static Future<String> encodeImageToBase64(Uint8List imageBytes, {
    String? mimeType,
    bool includeDataUri = false,
  }) async {
    try {
      AppLogger.info('Encoding image to Base64, size: ${imageBytes.length} bytes');

      final base64String = base64.encode(imageBytes);

      if (includeDataUri && mimeType != null) {
        return 'data:$mimeType;base64,$base64String';
      }

      return base64String;
    } catch (e) {
      AppLogger.error('Failed to encode image to Base64', e);
      throw Exception('Failed to encode image: $e');
    }
  }

  static Uint8List decodeBase64ToImage(String base64String) {
    try {
      AppLogger.info('Decoding Base64 to image');

      String cleanBase64 = base64String;

      // Remove data URI prefix if present
      if (base64String.contains('base64,')) {
        cleanBase64 = base64String.split('base64,').last;
      }

      return base64.decode(cleanBase64);
    } catch (e) {
      AppLogger.error('Failed to decode Base64 to image', e);
      throw Exception('Failed to decode image: $e');
    }
  }

  static Future<String> compressAndEncodeImage(
    Uint8List imageBytes, {
    int maxWidth = 1920,
    int maxHeight = 1080,
    int quality = ImageConstants.compressionQuality,
    String? mimeType,
    bool includeDataUri = false,
  }) async {
    try {
      AppLogger.info('Compressing and encoding image, original size: ${imageBytes.length} bytes');

      // Decode the image
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Check if resizing is needed
      img.Image processedImage = image;
      if (image.width > maxWidth || image.height > maxHeight) {
        AppLogger.info('Resizing image from ${image.width}x${image.height}');

        // Calculate new dimensions while maintaining aspect ratio
        double aspectRatio = image.width / image.height;
        int newWidth = maxWidth;
        int newHeight = (maxWidth / aspectRatio).round();

        if (newHeight > maxHeight) {
          newHeight = maxHeight;
          newWidth = (maxHeight * aspectRatio).round();
        }

        processedImage = img.copyResize(
          image,
          width: newWidth,
          height: newHeight,
          interpolation: img.Interpolation.linear,
        );

        AppLogger.info('Image resized to ${processedImage.width}x${processedImage.height}');
      }

      // Encode back to bytes with compression
      Uint8List compressedBytes;
      if (mimeType?.contains('png') == true) {
        compressedBytes = Uint8List.fromList(
          img.encodePng(processedImage, level: 6),
        );
      } else {
        compressedBytes = Uint8List.fromList(
          img.encodeJpg(processedImage, quality: quality),
        );
      }

      AppLogger.info('Image compressed to ${compressedBytes.length} bytes');

      // Check if compressed size exceeds limit
      if (compressedBytes.length > ImageConstants.maxImageSizeBytes) {
        // Try more aggressive compression
        AppLogger.info('Image still too large, applying more compression');
        compressedBytes = Uint8List.fromList(
          img.encodeJpg(processedImage, quality: quality ~/ 2),
        );
      }

      return encodeImageToBase64(
        compressedBytes,
        mimeType: mimeType,
        includeDataUri: includeDataUri,
      );
    } catch (e) {
      AppLogger.error('Failed to compress and encode image', e);
      throw Exception('Failed to process image: $e');
    }
  }

  static String extractMimeType(String base64String) {
    if (base64String.startsWith('data:')) {
      final match = RegExp(r'data:([^;]+);base64,').firstMatch(base64String);
      if (match != null) {
        return match.group(1) ?? 'image/jpeg';
      }
    }
    return 'image/jpeg';
  }

  static int calculateBase64Size(String base64String) {
    String cleanBase64 = base64String;
    if (base64String.contains('base64,')) {
      cleanBase64 = base64String.split('base64,').last;
    }

    // Approximate size in bytes (3/4 of base64 string length)
    return (cleanBase64.length * 3 / 4).round();
  }

  static bool isValidBase64Image(String base64String) {
    try {
      decodeBase64ToImage(base64String);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<Uint8List> createThumbnail(
    Uint8List imageBytes, {
    int size = ImageConstants.thumbnailSize,
  }) async {
    try {
      AppLogger.info('Creating thumbnail');

      final image = img.decodeImage(imageBytes);
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      final thumbnail = img.copyResize(
        image,
        width: size,
        height: size,
        interpolation: img.Interpolation.linear,
      );

      return Uint8List.fromList(
        img.encodeJpg(thumbnail, quality: 70),
      );
    } catch (e) {
      AppLogger.error('Failed to create thumbnail', e);
      throw Exception('Failed to create thumbnail: $e');
    }
  }
}
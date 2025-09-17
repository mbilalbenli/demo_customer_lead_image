import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import '../../../../core/utils/app_logger.dart';

class Base64Converter {
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int compressionQuality = 85;
  static const int maxDimension = 1920;

  static Future<String> encodeImageFile(File file) async {
    try {
      AppLogger.info('Encoding image file: ${file.path}');

      final bytes = await file.readAsBytes();
      final compressedBytes = await _compressImage(bytes);

      final base64String = base64Encode(compressedBytes);
      AppLogger.info('Image encoded, Base64 length: ${base64String.length}');

      return base64String;
    } catch (e) {
      AppLogger.error('Error encoding image file: $e');
      rethrow;
    }
  }

  static Future<String> encodeXFile(XFile file) async {
    try {
      AppLogger.info('Encoding XFile: ${file.path}');

      final bytes = await file.readAsBytes();
      final compressedBytes = await _compressImage(bytes);

      final base64String = base64Encode(compressedBytes);
      AppLogger.info('XFile encoded, Base64 length: ${base64String.length}');

      return base64String;
    } catch (e) {
      AppLogger.error('Error encoding XFile: $e');
      rethrow;
    }
  }

  static Uint8List decodeBase64(String base64String) {
    try {
      AppLogger.debug('Decoding Base64 string, length: ${base64String.length}');

      String cleanBase64 = base64String;
      if (base64String.contains(',')) {
        cleanBase64 = base64String.split(',').last;
      }

      final bytes = base64Decode(cleanBase64);
      AppLogger.debug('Decoded ${bytes.length} bytes');

      return bytes;
    } catch (e) {
      AppLogger.error('Error decoding Base64: $e');
      rethrow;
    }
  }

  static Future<Uint8List> _compressImage(Uint8List bytes) async {
    try {
      AppLogger.info('Compressing image, original size: ${bytes.length} bytes');

      if (bytes.length <= maxImageSize) {
        AppLogger.info('Image size is acceptable, no compression needed');
        return bytes;
      }

      final decodedImage = await compute(_decodeImageInIsolate, bytes);
      if (decodedImage == null) {
        AppLogger.warning('Failed to decode image for compression');
        return bytes;
      }

      img.Image resizedImage = decodedImage;

      if (decodedImage.width > maxDimension || decodedImage.height > maxDimension) {
        if (decodedImage.width > decodedImage.height) {
          resizedImage = img.copyResize(decodedImage, width: maxDimension);
        } else {
          resizedImage = img.copyResize(decodedImage, height: maxDimension);
        }
        AppLogger.info('Image resized from ${decodedImage.width}x${decodedImage.height} to ${resizedImage.width}x${resizedImage.height}');
      }

      final compressedBytes = await compute(
        _encodeImageInIsolate,
        _ImageEncodeParams(resizedImage, compressionQuality),
      );

      AppLogger.info('Image compressed, new size: ${compressedBytes.length} bytes');

      return compressedBytes;
    } catch (e) {
      AppLogger.error('Error compressing image: $e');
      return bytes;
    }
  }

  static img.Image? _decodeImageInIsolate(Uint8List bytes) {
    return img.decodeImage(bytes);
  }

  static Uint8List _encodeImageInIsolate(_ImageEncodeParams params) {
    return Uint8List.fromList(
      img.encodeJpg(params.image, quality: params.quality),
    );
  }

  static String addDataUriPrefix(String base64String, {String mimeType = 'image/jpeg'}) {
    if (base64String.startsWith('data:')) {
      return base64String;
    }
    return 'data:$mimeType;base64,$base64String';
  }

  static String removeDataUriPrefix(String base64String) {
    if (base64String.contains(',')) {
      return base64String.split(',').last;
    }
    return base64String;
  }

  static bool isValidBase64(String base64String) {
    try {
      final cleanBase64 = removeDataUriPrefix(base64String);
      base64Decode(cleanBase64);
      return true;
    } catch (e) {
      return false;
    }
  }

  static int getBase64Size(String base64String) {
    final cleanBase64 = removeDataUriPrefix(base64String);
    return (cleanBase64.length * 3 / 4).round();
  }
}

class _ImageEncodeParams {
  final img.Image image;
  final int quality;

  _ImageEncodeParams(this.image, this.quality);
}
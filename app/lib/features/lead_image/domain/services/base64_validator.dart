import 'dart:convert';
import '../constants/image_constants.dart';

class Base64Validator {
  static bool isValidBase64(String input) {
    if (input.isEmpty) return false;

    String base64Data = input;

    // Handle data URI format
    if (input.startsWith(ImageConstants.base64ImagePrefix)) {
      final dataUriPattern = RegExp(r'data:([^;]+);base64,(.+)');
      final match = dataUriPattern.firstMatch(input);
      if (match != null) {
        base64Data = match.group(2)!;
      }
    }

    final base64Pattern = RegExp(r'^[A-Za-z0-9+/]*={0,2}$');
    if (!base64Pattern.hasMatch(base64Data)) return false;

    try {
      base64.decode(base64Data);
      return true;
    } catch (e) {
      return false;
    }
  }

  static String? extractMimeType(String base64String) {
    if (!base64String.startsWith(ImageConstants.base64ImagePrefix)) {
      return null;
    }

    final dataUriPattern = RegExp(r'data:([^;]+);base64,');
    final match = dataUriPattern.firstMatch(base64String);
    return match?.group(1);
  }

  static String extractBase64Data(String input) {
    if (!input.startsWith(ImageConstants.base64ImagePrefix)) {
      return input;
    }

    final dataUriPattern = RegExp(r'data:[^;]+;base64,(.+)');
    final match = dataUriPattern.firstMatch(input);
    return match?.group(1) ?? input;
  }

  static int calculateSize(String base64String) {
    final data = extractBase64Data(base64String);
    try {
      final bytes = base64.decode(data);
      return bytes.length;
    } catch (e) {
      return 0;
    }
  }

  static bool isWithinSizeLimit(String base64String) {
    final size = calculateSize(base64String);
    return size > 0 && size <= ImageConstants.maxImageSizeBytes;
  }

  static String? validateImageFormat(String mimeType) {
    final formatMatch = RegExp(r'image/(jpeg|jpg|png|gif|webp)').firstMatch(mimeType);
    if (formatMatch != null) {
      final format = formatMatch.group(1);
      if (format != null && ImageConstants.supportedFormats.contains(format)) {
        return null; // Valid format
      }
    }
    return 'Unsupported image format. Supported formats: ${ImageConstants.supportedFormats.join(", ")}';
  }
}
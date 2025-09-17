import 'dart:convert';
import 'dart:typed_data';

import '../../features/lead_image/domain/constants/image_constants.dart';

/// Security validator for Base64 image data
class Base64Validator {
  static const List<String> _allowedMimeTypes = [
    'image/jpeg',
    'image/jpg',
    'image/png',
    'image/gif',
    'image/webp',
  ];

  static const List<String> _allowedFileSignatures = [
    'FFD8FF', // JPEG
    '89504E47', // PNG
    '47494638', // GIF
    '52494646', // WebP (RIFF)
  ];

  /// Validate Base64 string format and content
  static ValidationResult validateBase64Image(String base64Data) {
    try {
      // Check if string is empty
      if (base64Data.isEmpty) {
        return ValidationResult.failure('Base64 data is empty');
      }

      // Remove data URL prefix if present
      String cleanBase64 = _cleanBase64String(base64Data);

      // Validate Base64 format
      if (!_isValidBase64Format(cleanBase64)) {
        return ValidationResult.failure('Invalid Base64 format');
      }

      // Decode to validate integrity
      final Uint8List bytes;
      try {
        bytes = base64Decode(cleanBase64);
      } catch (e) {
        return ValidationResult.failure('Failed to decode Base64: ${e.toString()}');
      }

      // Check file size
      if (bytes.length > ImageConstants.maxImageSizeBytes) {
        final sizeInMB = (bytes.length / 1048576).toStringAsFixed(1);
        final maxSizeInMB = (ImageConstants.maxImageSizeBytes / 1048576).toStringAsFixed(0);
        return ValidationResult.failure(
          'Image size ${sizeInMB}MB exceeds maximum of ${maxSizeInMB}MB'
        );
      }

      // Validate file signature
      final fileSignature = _getFileSignature(bytes);
      if (!_isAllowedFileType(fileSignature)) {
        return ValidationResult.failure('Unsupported file type');
      }

      // Extract and validate MIME type
      final mimeType = _extractMimeTypeFromBase64(base64Data);
      if (mimeType != null && !_allowedMimeTypes.contains(mimeType.toLowerCase())) {
        return ValidationResult.failure('Unsupported MIME type: $mimeType');
      }

      // Validate image structure
      if (!_isValidImageStructure(bytes)) {
        return ValidationResult.failure('Invalid image structure or corrupted data');
      }

      // Check for embedded scripts or malicious content
      if (_containsSuspiciousContent(bytes)) {
        return ValidationResult.failure('Suspicious content detected in image');
      }

      return ValidationResult.success(
        cleanBase64: cleanBase64,
        bytes: bytes,
        mimeType: mimeType,
        sizeInBytes: bytes.length,
      );

    } catch (e) {
      return ValidationResult.failure('Validation error: ${e.toString()}');
    }
  }

  /// Clean Base64 string by removing data URL prefix
  static String _cleanBase64String(String base64Data) {
    // Remove data:image/...;base64, prefix if present
    if (base64Data.startsWith('data:')) {
      final commaIndex = base64Data.indexOf(',');
      if (commaIndex != -1) {
        return base64Data.substring(commaIndex + 1);
      }
    }
    return base64Data;
  }

  /// Check if string is valid Base64 format
  static bool _isValidBase64Format(String base64String) {
    // Base64 should only contain valid characters
    final base64Regex = RegExp(r'^[A-Za-z0-9+/]*={0,2}$');
    if (!base64Regex.hasMatch(base64String)) {
      return false;
    }

    // Check padding
    final paddingCount = base64String.split('=').length - 1;
    if (paddingCount > 2) {
      return false;
    }

    // Check length (should be multiple of 4)
    if (base64String.length % 4 != 0) {
      return false;
    }

    return true;
  }

  /// Extract MIME type from data URL
  static String? _extractMimeTypeFromBase64(String base64Data) {
    if (base64Data.startsWith('data:')) {
      final semicolonIndex = base64Data.indexOf(';');
      if (semicolonIndex != -1) {
        return base64Data.substring(5, semicolonIndex);
      }
    }
    return null;
  }

  /// Get file signature (magic bytes) from binary data
  static String _getFileSignature(Uint8List bytes) {
    if (bytes.length < 4) return '';

    final signature = bytes.take(8).map((byte) =>
      byte.toRadixString(16).padLeft(2, '0').toUpperCase()
    ).join('');

    return signature;
  }

  /// Check if file type is allowed based on signature
  static bool _isAllowedFileType(String signature) {
    return _allowedFileSignatures.any((allowed) =>
      signature.startsWith(allowed)
    );
  }

  /// Validate basic image structure
  static bool _isValidImageStructure(Uint8List bytes) {
    if (bytes.length < 10) return false;

    final signature = _getFileSignature(bytes);

    // JPEG validation
    if (signature.startsWith('FFD8FF')) {
      return _validateJpegStructure(bytes);
    }

    // PNG validation
    if (signature.startsWith('89504E47')) {
      return _validatePngStructure(bytes);
    }

    // GIF validation
    if (signature.startsWith('47494638')) {
      return _validateGifStructure(bytes);
    }

    // WebP validation
    if (signature.startsWith('52494646')) {
      return _validateWebpStructure(bytes);
    }

    return false;
  }

  /// Validate JPEG structure
  static bool _validateJpegStructure(Uint8List bytes) {
    if (bytes.length < 10) return false;

    // Check for JPEG markers
    if (bytes[0] != 0xFF || bytes[1] != 0xD8) return false;

    // Look for End of Image marker
    for (int i = bytes.length - 2; i >= 0; i--) {
      if (bytes[i] == 0xFF && bytes[i + 1] == 0xD9) {
        return true;
      }
    }

    return false;
  }

  /// Validate PNG structure
  static bool _validatePngStructure(Uint8List bytes) {
    if (bytes.length < 25) return false;

    // Check PNG signature
    const pngSignature = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];
    for (int i = 0; i < pngSignature.length; i++) {
      if (bytes[i] != pngSignature[i]) return false;
    }

    // Check for IHDR chunk
    final ihdrSignature = String.fromCharCodes(bytes.sublist(12, 16));
    return ihdrSignature == 'IHDR';
  }

  /// Validate GIF structure
  static bool _validateGifStructure(Uint8List bytes) {
    if (bytes.length < 13) return false;

    // Check GIF signature
    final signature = String.fromCharCodes(bytes.sublist(0, 6));
    return signature == 'GIF87a' || signature == 'GIF89a';
  }

  /// Validate WebP structure
  static bool _validateWebpStructure(Uint8List bytes) {
    if (bytes.length < 16) return false;

    // Check RIFF header
    final riff = String.fromCharCodes(bytes.sublist(0, 4));
    if (riff != 'RIFF') return false;

    // Check WebP signature
    final webp = String.fromCharCodes(bytes.sublist(8, 12));
    return webp == 'WEBP';
  }

  /// Check for suspicious content that might indicate embedded scripts
  static bool _containsSuspiciousContent(Uint8List bytes) {
    final content = String.fromCharCodes(bytes).toLowerCase();

    // Check for script tags or suspicious strings
    const suspiciousPatterns = [
      '<script',
      'javascript:',
      'data:text/html',
      'eval(',
      'function(',
      'var ',
      'let ',
      'const ',
      '<?php',
      '<%',
      'document.',
      'window.',
      'alert(',
      'confirm(',
      'prompt(',
    ];

    return suspiciousPatterns.any((pattern) => content.contains(pattern));
  }

  /// Sanitize Base64 string by removing potentially harmful content
  static String sanitizeBase64(String base64Data) {
    // Remove any non-Base64 characters except valid padding
    return base64Data.replaceAll(RegExp(r'[^A-Za-z0-9+/=]'), '');
  }

  /// Generate secure hash for Base64 content integrity
  static String generateContentHash(Uint8List bytes) {
    // Simple hash for content integrity (in production, use crypto library)
    int hash = 0;
    for (int byte in bytes) {
      hash = ((hash << 5) - hash + byte) & 0xFFFFFFFF;
    }
    return hash.toString();
  }
}

/// Result of Base64 validation
class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  final String? cleanBase64;
  final Uint8List? bytes;
  final String? mimeType;
  final int? sizeInBytes;

  const ValidationResult._({
    required this.isValid,
    this.errorMessage,
    this.cleanBase64,
    this.bytes,
    this.mimeType,
    this.sizeInBytes,
  });

  factory ValidationResult.success({
    required String cleanBase64,
    required Uint8List bytes,
    String? mimeType,
    required int sizeInBytes,
  }) {
    return ValidationResult._(
      isValid: true,
      cleanBase64: cleanBase64,
      bytes: bytes,
      mimeType: mimeType,
      sizeInBytes: sizeInBytes,
    );
  }

  factory ValidationResult.failure(String errorMessage) {
    return ValidationResult._(
      isValid: false,
      errorMessage: errorMessage,
    );
  }
}
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../constants/image_constants.dart';

@immutable
class Base64ImageData {
  final String value;
  final int sizeInBytes;
  final String? mimeType;

  const Base64ImageData._({
    required this.value,
    required this.sizeInBytes,
    this.mimeType,
  });

  factory Base64ImageData(String input) {
    if (input.isEmpty) {
      throw ArgumentError('Base64 image data cannot be empty');
    }

    String base64Data = input;
    String? detectedMimeType;

    // Handle data URI format
    if (input.startsWith(ImageConstants.base64ImagePrefix)) {
      final dataUriPattern = RegExp(r'data:([^;]+);base64,(.+)');
      final match = dataUriPattern.firstMatch(input);
      if (match != null) {
        detectedMimeType = match.group(1);
        base64Data = match.group(2)!;
      }
    }

    // Validate Base64 format
    if (!_isValidBase64(base64Data)) {
      throw ArgumentError('Invalid Base64 format');
    }

    // Calculate size
    final decodedBytes = base64.decode(base64Data);
    final sizeInBytes = decodedBytes.length;

    if (sizeInBytes > ImageConstants.maxImageSizeBytes) {
      throw ArgumentError(
        'Image size exceeds maximum allowed size of ${ImageConstants.maxImageSizeBytes / 1048576}MB',
      );
    }

    return Base64ImageData._(
      value: base64Data,
      sizeInBytes: sizeInBytes,
      mimeType: detectedMimeType,
    );
  }

  static bool _isValidBase64(String input) {
    if (input.isEmpty) return false;

    final base64Pattern = RegExp(r'^[A-Za-z0-9+/]*={0,2}$');
    if (!base64Pattern.hasMatch(input)) return false;

    try {
      base64.decode(input);
      return true;
    } catch (e) {
      return false;
    }
  }

  String toDataUri() {
    if (mimeType != null) {
      return 'data:$mimeType;base64,$value';
    }
    return 'data:image/png;base64,$value';
  }

  Uint8List toBytes() => base64.decode(value);

  double get sizeInMB => sizeInBytes / 1048576;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Base64ImageData &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}
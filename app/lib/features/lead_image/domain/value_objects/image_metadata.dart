import 'package:flutter/foundation.dart';

@immutable
class ImageMetadata {
  final String fileName;
  final String contentType;
  final int sizeInBytes;
  final DateTime uploadedAt;
  final int? width;
  final int? height;

  const ImageMetadata({
    required this.fileName,
    required this.contentType,
    required this.sizeInBytes,
    required this.uploadedAt,
    this.width,
    this.height,
  });

  double get sizeInMB => sizeInBytes / 1048576;

  String get sizeDisplay {
    if (sizeInMB >= 1) {
      return '${sizeInMB.toStringAsFixed(2)} MB';
    }
    final sizeInKB = sizeInBytes / 1024;
    if (sizeInKB >= 1) {
      return '${sizeInKB.toStringAsFixed(2)} KB';
    }
    return '$sizeInBytes bytes';
  }

  String get dimensionsDisplay {
    if (width != null && height != null) {
      return '${width}x$height';
    }
    return 'Unknown';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageMetadata &&
          runtimeType == other.runtimeType &&
          fileName == other.fileName &&
          contentType == other.contentType &&
          sizeInBytes == other.sizeInBytes &&
          uploadedAt == other.uploadedAt;

  @override
  int get hashCode =>
      fileName.hashCode ^
      contentType.hashCode ^
      sizeInBytes.hashCode ^
      uploadedAt.hashCode;
}
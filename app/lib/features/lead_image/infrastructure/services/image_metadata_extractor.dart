class ImageMetadataExtractor {
  Map<String, dynamic> extractBasic(String fileName, String contentType, int sizeBytes) {
    return {
      'fileName': fileName,
      'contentType': contentType,
      'sizeBytes': sizeBytes,
    };
  }
}


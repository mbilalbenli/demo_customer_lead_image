class ImageValidationService {
  bool isSupportedContentType(String contentType) {
    const allowed = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
    return allowed.contains(contentType.toLowerCase());
  }

  bool isUnderSizeLimit(int sizeBytes, {int maxBytes = 5 * 1024 * 1024}) => sizeBytes <= maxBytes;
}


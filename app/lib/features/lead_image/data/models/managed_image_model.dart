/// Data model for managed images
class ManagedImage {
  final String id;
  final String? base64Data;
  final String? url;
  final String fileName;
  final int sizeInBytes;
  final DateTime uploadedAt;
  final bool isMain;

  const ManagedImage({
    required this.id,
    this.base64Data,
    this.url,
    required this.fileName,
    required this.sizeInBytes,
    required this.uploadedAt,
    this.isMain = false,
  });
}
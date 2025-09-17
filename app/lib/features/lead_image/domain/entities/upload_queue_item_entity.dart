enum UploadStatus { ready, uploading, paused, complete, failed }

class UploadQueueItemEntity {
  final String id;
  final String leadId;
  final String fileName;
  final String base64Data;
  final String contentType;
  final int sizeBytes;
  final double progress; // 0.0 - 1.0
  final UploadStatus status;
  final String? error;

  const UploadQueueItemEntity({
    required this.id,
    required this.leadId,
    required this.fileName,
    required this.base64Data,
    required this.contentType,
    required this.sizeBytes,
    this.progress = 0.0,
    this.status = UploadStatus.ready,
    this.error,
  });

  UploadQueueItemEntity copyWith({
    double? progress,
    UploadStatus? status,
    String? error,
  }) {
    return UploadQueueItemEntity(
      id: id,
      leadId: leadId,
      fileName: fileName,
      base64Data: base64Data,
      contentType: contentType,
      sizeBytes: sizeBytes,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}


class UploadOptionsEntity {
  final bool autoRotate;
  final bool addWatermark;
  final bool compress;
  final int quality; // 1-100
  final bool backgroundUpload;

  const UploadOptionsEntity({
    this.autoRotate = true,
    this.addWatermark = false,
    this.compress = true,
    this.quality = 85,
    this.backgroundUpload = true,
  });

  UploadOptionsEntity copyWith({
    bool? autoRotate,
    bool? addWatermark,
    bool? compress,
    int? quality,
    bool? backgroundUpload,
  }) {
    return UploadOptionsEntity(
      autoRotate: autoRotate ?? this.autoRotate,
      addWatermark: addWatermark ?? this.addWatermark,
      compress: compress ?? this.compress,
      quality: quality ?? this.quality,
      backgroundUpload: backgroundUpload ?? this.backgroundUpload,
    );
  }
}


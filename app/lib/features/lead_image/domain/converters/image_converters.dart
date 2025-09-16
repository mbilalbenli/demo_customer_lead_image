import 'package:freezed_annotation/freezed_annotation.dart';
import '../value_objects/base64_image_data.dart';
import '../value_objects/image_metadata.dart';

class Base64ImageDataConverter implements JsonConverter<Base64ImageData, String> {
  const Base64ImageDataConverter();

  @override
  Base64ImageData fromJson(String json) => Base64ImageData(json);

  @override
  String toJson(Base64ImageData object) => object.value;
}

class ImageMetadataConverter implements JsonConverter<ImageMetadata, Map<String, dynamic>> {
  const ImageMetadataConverter();

  @override
  ImageMetadata fromJson(Map<String, dynamic> json) => ImageMetadata(
    fileName: json['fileName'] as String,
    contentType: json['contentType'] as String,
    sizeInBytes: json['sizeInBytes'] as int,
    uploadedAt: DateTime.parse(json['uploadedAt'] as String),
    width: json['width'] as int?,
    height: json['height'] as int?,
  );

  @override
  Map<String, dynamic> toJson(ImageMetadata object) => {
    'fileName': object.fileName,
    'contentType': object.contentType,
    'sizeInBytes': object.sizeInBytes,
    'uploadedAt': object.uploadedAt.toIso8601String(),
    if (object.width != null) 'width': object.width,
    if (object.height != null) 'height': object.height,
  };
}
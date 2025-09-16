import 'package:freezed_annotation/freezed_annotation.dart';
import '../value_objects/base64_image_data.dart';
import '../value_objects/image_metadata.dart';
import '../converters/image_converters.dart';

part 'lead_image_entity.freezed.dart';
part 'lead_image_entity.g.dart';

@freezed
abstract class LeadImageEntity with _$LeadImageEntity {
  const LeadImageEntity._();

  const factory LeadImageEntity({
    required String id,
    required String leadId,
    @Base64ImageDataConverter() required Base64ImageData base64Data,
    @ImageMetadataConverter() required ImageMetadata metadata,
    required int orderIndex,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _LeadImageEntity;

  factory LeadImageEntity.fromJson(Map<String, dynamic> json) =>
      _$LeadImageEntityFromJson(json);

  bool get isValidBase64 {
    try {
      base64Data.toBytes();
      return true;
    } catch (e) {
      return false;
    }
  }

  String get displayName => metadata.fileName;

  String get sizeDisplay => metadata.sizeDisplay;

  factory LeadImageEntity.create({
    required String id,
    required String leadId,
    required String base64String,
    required String fileName,
    required String contentType,
    int orderIndex = 0,
  }) {
    final base64Data = Base64ImageData(base64String);

    final metadata = ImageMetadata(
      fileName: fileName,
      contentType: contentType,
      sizeInBytes: base64Data.sizeInBytes,
      uploadedAt: DateTime.now(),
    );

    return LeadImageEntity(
      id: id,
      leadId: leadId,
      base64Data: base64Data,
      metadata: metadata,
      orderIndex: orderIndex,
      createdAt: DateTime.now(),
    );
  }
}
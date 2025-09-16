import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/lead_image_entity.dart';
import '../../domain/value_objects/base64_image_data.dart';
import '../../domain/value_objects/image_metadata.dart';

part 'lead_image_model.freezed.dart';
part 'lead_image_model.g.dart';

@freezed
abstract class LeadImageModel with _$LeadImageModel {
  const LeadImageModel._();

  const factory LeadImageModel({
    required String id,
    required String leadId,
    required String base64Data,
    required String fileName,
    required String contentType,
    required int sizeInBytes,
    required int orderIndex,
    required DateTime uploadedAt,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _LeadImageModel;

  factory LeadImageModel.fromJson(Map<String, dynamic> json) =>
      _$LeadImageModelFromJson(json);

  LeadImageEntity toEntity() {
    return LeadImageEntity(
      id: id,
      leadId: leadId,
      base64Data: Base64ImageData(base64Data),
      metadata: ImageMetadata(
        fileName: fileName,
        contentType: contentType,
        sizeInBytes: sizeInBytes,
        uploadedAt: uploadedAt,
      ),
      orderIndex: orderIndex,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory LeadImageModel.fromEntity(LeadImageEntity entity) {
    return LeadImageModel(
      id: entity.id,
      leadId: entity.leadId,
      base64Data: entity.base64Data.value,
      fileName: entity.metadata.fileName,
      contentType: entity.metadata.contentType,
      sizeInBytes: entity.metadata.sizeInBytes,
      uploadedAt: entity.metadata.uploadedAt,
      orderIndex: entity.orderIndex,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory LeadImageModel.fromBase64({
    required String id,
    required String leadId,
    required String base64String,
    required String fileName,
    String contentType = 'image/jpeg',
    int orderIndex = 0,
  }) {
    final base64Data = Base64ImageData(base64String);

    return LeadImageModel(
      id: id,
      leadId: leadId,
      base64Data: base64Data.value,
      fileName: fileName,
      contentType: contentType,
      sizeInBytes: base64Data.sizeInBytes,
      uploadedAt: DateTime.now(),
      orderIndex: orderIndex,
      createdAt: DateTime.now(),
    );
  }
}
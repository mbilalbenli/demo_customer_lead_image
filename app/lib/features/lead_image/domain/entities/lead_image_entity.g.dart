// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lead_image_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeadImageEntity _$LeadImageEntityFromJson(Map<String, dynamic> json) =>
    _LeadImageEntity(
      id: json['id'] as String,
      leadId: json['leadId'] as String,
      base64Data: const Base64ImageDataConverter().fromJson(
        json['base64Data'] as String,
      ),
      metadata: const ImageMetadataConverter().fromJson(
        json['metadata'] as Map<String, dynamic>,
      ),
      orderIndex: (json['orderIndex'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$LeadImageEntityToJson(
  _LeadImageEntity instance,
) => <String, dynamic>{
  'id': instance.id,
  'leadId': instance.leadId,
  'base64Data': const Base64ImageDataConverter().toJson(instance.base64Data),
  'metadata': const ImageMetadataConverter().toJson(instance.metadata),
  'orderIndex': instance.orderIndex,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

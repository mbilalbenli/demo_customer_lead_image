// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lead_image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeadImageModel _$LeadImageModelFromJson(Map<String, dynamic> json) =>
    _LeadImageModel(
      id: json['id'] as String,
      leadId: json['leadId'] as String,
      base64Data: json['base64Data'] as String,
      fileName: json['fileName'] as String,
      contentType: json['contentType'] as String,
      sizeInBytes: (json['sizeInBytes'] as num).toInt(),
      orderIndex: (json['orderIndex'] as num).toInt(),
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$LeadImageModelToJson(_LeadImageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'leadId': instance.leadId,
      'base64Data': instance.base64Data,
      'fileName': instance.fileName,
      'contentType': instance.contentType,
      'sizeInBytes': instance.sizeInBytes,
      'orderIndex': instance.orderIndex,
      'uploadedAt': instance.uploadedAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

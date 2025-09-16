// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lead_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeadModel _$LeadModelFromJson(Map<String, dynamic> json) => _LeadModel(
  id: json['id'] as String,
  customerName: json['customerName'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  description: json['description'] as String,
  status: $enumDecode(_$LeadStatusEnumMap, json['status']),
  imageCount: (json['imageCount'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$LeadModelToJson(_LeadModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerName': instance.customerName,
      'email': instance.email,
      'phone': instance.phone,
      'description': instance.description,
      'status': _$LeadStatusEnumMap[instance.status]!,
      'imageCount': instance.imageCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$LeadStatusEnumMap = {
  LeadStatus.active: 'active',
  LeadStatus.inactive: 'inactive',
  LeadStatus.converted: 'converted',
  LeadStatus.lost: 'lost',
};

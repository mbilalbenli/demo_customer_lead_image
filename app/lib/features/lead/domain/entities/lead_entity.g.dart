// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lead_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeadEntity _$LeadEntityFromJson(Map<String, dynamic> json) => _LeadEntity(
  id: json['id'] as String,
  customerName: const CustomerNameConverter().fromJson(
    json['customerName'] as String,
  ),
  email: const EmailAddressConverter().fromJson(json['email'] as String),
  phone: const PhoneNumberConverter().fromJson(json['phone'] as String),
  description: json['description'] as String,
  status: $enumDecode(_$LeadStatusEnumMap, json['status']),
  imageCount: (json['imageCount'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$LeadEntityToJson(
  _LeadEntity instance,
) => <String, dynamic>{
  'id': instance.id,
  'customerName': const CustomerNameConverter().toJson(instance.customerName),
  'email': const EmailAddressConverter().toJson(instance.email),
  'phone': const PhoneNumberConverter().toJson(instance.phone),
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_check_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HealthCheckModel _$HealthCheckModelFromJson(Map<String, dynamic> json) =>
    _HealthCheckModel(
      status: json['status'] as String,
      version: json['version'] as String?,
      totalDuration: json['totalDuration'] as String?,
      results: json['results'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$HealthCheckModelToJson(_HealthCheckModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'version': instance.version,
      'totalDuration': instance.totalDuration,
      'results': instance.results,
    };

import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_check_model.freezed.dart';
part 'health_check_model.g.dart';

@freezed
abstract class HealthCheckModel with _$HealthCheckModel {
  const factory HealthCheckModel({
    required String status,
    String? version,
    String? totalDuration,
    Map<String, dynamic>? results,
  }) = _HealthCheckModel;

  factory HealthCheckModel.fromJson(Map<String, dynamic> json) => _$HealthCheckModelFromJson(json);
}

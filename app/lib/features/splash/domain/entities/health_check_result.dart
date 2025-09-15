import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_check_result.freezed.dart';

@freezed
abstract class HealthCheckResult with _$HealthCheckResult {
  const factory HealthCheckResult({
    required bool ok,
    String? message,
  }) = _HealthCheckResult;
}

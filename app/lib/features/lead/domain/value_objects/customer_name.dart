import 'package:flutter/foundation.dart';
import '../constants/lead_constants.dart';

@immutable
class CustomerName {
  final String value;

  const CustomerName._(this.value);

  factory CustomerName(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Customer name cannot be empty');
    }
    if (trimmed.length > LeadConstants.maxNameLength) {
      throw ArgumentError(
        'Customer name cannot exceed ${LeadConstants.maxNameLength} characters',
      );
    }
    return CustomerName._(trimmed);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerName &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
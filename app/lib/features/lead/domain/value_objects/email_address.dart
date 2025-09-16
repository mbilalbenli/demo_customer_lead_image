import 'package:flutter/foundation.dart';
import '../constants/lead_constants.dart';

@immutable
class EmailAddress {
  final String value;
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  const EmailAddress._(this.value);

  factory EmailAddress(String input) {
    final trimmed = input.trim().toLowerCase();
    if (trimmed.isEmpty) {
      throw ArgumentError('Email address cannot be empty');
    }
    if (trimmed.length > LeadConstants.maxEmailLength) {
      throw ArgumentError(
        'Email address cannot exceed ${LeadConstants.maxEmailLength} characters',
      );
    }
    if (!_emailRegex.hasMatch(trimmed)) {
      throw ArgumentError('Invalid email address format');
    }
    return EmailAddress._(trimmed);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmailAddress &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
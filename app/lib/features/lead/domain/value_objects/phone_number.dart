import 'package:flutter/foundation.dart';
import '../constants/lead_constants.dart';

@immutable
class PhoneNumber {
  final String value;
  static final RegExp _phoneRegex = RegExp(
    r'^\+?[1-9]\d{0,19}$',
  );

  const PhoneNumber._(this.value);

  factory PhoneNumber(String input) {
    final cleaned = input.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (cleaned.isEmpty) {
      throw ArgumentError('Phone number cannot be empty');
    }
    if (cleaned.length > LeadConstants.maxPhoneLength) {
      throw ArgumentError(
        'Phone number cannot exceed ${LeadConstants.maxPhoneLength} characters',
      );
    }
    if (!_phoneRegex.hasMatch(cleaned)) {
      throw ArgumentError('Invalid phone number format');
    }
    return PhoneNumber._(cleaned);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhoneNumber &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
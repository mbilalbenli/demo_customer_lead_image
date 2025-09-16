import 'package:freezed_annotation/freezed_annotation.dart';
import '../value_objects/customer_name.dart';
import '../value_objects/email_address.dart';
import '../value_objects/phone_number.dart';

class CustomerNameConverter implements JsonConverter<CustomerName, String> {
  const CustomerNameConverter();

  @override
  CustomerName fromJson(String json) => CustomerName(json);

  @override
  String toJson(CustomerName object) => object.value;
}

class EmailAddressConverter implements JsonConverter<EmailAddress, String> {
  const EmailAddressConverter();

  @override
  EmailAddress fromJson(String json) => EmailAddress(json);

  @override
  String toJson(EmailAddress object) => object.value;
}

class PhoneNumberConverter implements JsonConverter<PhoneNumber, String> {
  const PhoneNumberConverter();

  @override
  PhoneNumber fromJson(String json) => PhoneNumber(json);

  @override
  String toJson(PhoneNumber object) => object.value;
}
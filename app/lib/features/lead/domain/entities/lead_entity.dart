import 'package:freezed_annotation/freezed_annotation.dart';

import '../constants/lead_constants.dart';
import '../converters/lead_converters.dart';
import '../value_objects/customer_name.dart';
import '../value_objects/email_address.dart';
import '../value_objects/phone_number.dart';

part 'lead_entity.freezed.dart';
part 'lead_entity.g.dart';

@freezed
abstract class LeadEntity with _$LeadEntity {
  const LeadEntity._();

  const factory LeadEntity({
    required String id,
    @CustomerNameConverter() required CustomerName customerName,
    @EmailAddressConverter() required EmailAddress email,
    @PhoneNumberConverter() required PhoneNumber phone,
    String? description,
    required LeadStatus status,
    required int imageCount,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _LeadEntity;

  factory LeadEntity.fromJson(Map<String, dynamic> json) =>
      _$LeadEntityFromJson(json);

  bool get canAddImage => imageCount < LeadConstants.maxImagesPerLead;

  int get remainingImageSlots => LeadConstants.maxImagesPerLead - imageCount;

  double get imageCapacityPercentage =>
      (imageCount / LeadConstants.maxImagesPerLead) * 100;

  bool get isAtImageLimit => imageCount >= LeadConstants.maxImagesPerLead;

  String get imageStatusText =>
      '$imageCount of ${LeadConstants.maxImagesPerLead} images';

  factory LeadEntity.create({
    required String id,
    required String customerName,
    required String email,
    required String phone,
    String? description,
    LeadStatus status = LeadStatus.newLead,
    int imageCount = 0,
  }) {
    if (imageCount < 0 || imageCount > LeadConstants.maxImagesPerLead) {
      throw ArgumentError(
        'Image count must be between 0 and ${LeadConstants.maxImagesPerLead}',
      );
    }

    return LeadEntity(
      id: id,
      customerName: CustomerName(customerName),
      email: EmailAddress(email),
      phone: PhoneNumber(phone),
      description: description ?? '',
      status: status,
      imageCount: imageCount,
      createdAt: DateTime.now(),
    );
  }
}

enum LeadStatus {
  @JsonValue(1)
  newLead,
  @JsonValue(2)
  contacted,
  @JsonValue(3)
  qualified,
  @JsonValue(4)
  proposal,
  @JsonValue(5)
  negotiation,
  @JsonValue(6)
  closed,
  @JsonValue(7)
  lost,
}

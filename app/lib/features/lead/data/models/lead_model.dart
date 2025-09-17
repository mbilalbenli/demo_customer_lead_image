import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/lead_entity.dart';
import '../../domain/value_objects/customer_name.dart';
import '../../domain/value_objects/email_address.dart';
import '../../domain/value_objects/phone_number.dart';

part 'lead_model.freezed.dart';
part 'lead_model.g.dart';

@freezed
abstract class LeadModel with _$LeadModel {
  const LeadModel._();

  const factory LeadModel({
    required String id,
    @JsonKey(name: 'name') // ignore: invalid_annotation_target
    required String customerName,
    required String email,
    required String phone,
    @Default('') String description,
    required LeadStatus status,
    required int imageCount,
    @Default(10) int availableImageSlots,
    @Default(true) bool canAddMoreImages,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _LeadModel;

  factory LeadModel.fromJson(Map<String, dynamic> json) =>
      _$LeadModelFromJson(json);

  LeadEntity toEntity() {
    return LeadEntity(
      id: id,
      customerName: CustomerName(customerName),
      email: EmailAddress(email),
      phone: PhoneNumber(phone),
      description: description.isEmpty ? '' : description,
      status: status,
      imageCount: imageCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory LeadModel.fromEntity(LeadEntity entity) {
    return LeadModel(
      id: entity.id,
      customerName: entity.customerName.value,
      email: entity.email.value,
      phone: entity.phone.value,
      description: entity.description ?? '',
      status: entity.status,
      imageCount: entity.imageCount,
      availableImageSlots: entity.remainingImageSlots,
      canAddMoreImages: entity.canAddImage,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // Create JSON for API requests with proper casing
  Map<String, dynamic> toApiJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'Name': customerName,
      'Email': email,
      'Phone': phone,
      'Status': status.index + 1, // Backend expects 1-based enum values
      if (description.isNotEmpty) 'Description': description,
    };
  }
}

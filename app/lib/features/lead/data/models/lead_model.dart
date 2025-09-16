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
    required String customerName,
    required String email,
    required String phone,
    required String description,
    required LeadStatus status,
    required int imageCount,
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
      description: description,
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
      description: entity.description,
      status: entity.status,
      imageCount: entity.imageCount,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
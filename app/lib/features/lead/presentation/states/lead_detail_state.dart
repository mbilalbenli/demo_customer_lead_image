import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/base/base_state.dart';
import '../../domain/entities/lead_entity.dart';

part 'lead_detail_state.freezed.dart';

@freezed
abstract class LeadDetailState with _$LeadDetailState implements BaseState {
  const LeadDetailState._();

  const factory LeadDetailState({
    @Default(CoreState()) CoreState core,
    LeadEntity? lead,
    @Default(false) bool canAddImage,
    @Default(0) int imageCount,
    @Default(10) int maxImages,
    String? errorMessage,
  }) = _LeadDetailState;

  @override
  bool get isBusy => core.isBusy;

  @override
  bool get showAppBar => core.showAppBar;

  @override
  String get busyOperation => core.busyOperation;

  @override
  String get title => lead?.customerName.value ?? 'Lead Details';

  @override
  GlobalKey? get widgetKeyForLoadingPosition => core.widgetKeyForLoadingPosition;

  int get remainingImageSlots => maxImages - imageCount;

  String get imageStatusText => '$imageCount of $maxImages images';

  bool get isAtImageLimit => imageCount >= maxImages;
}
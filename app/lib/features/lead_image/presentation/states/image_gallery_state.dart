import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/base/base_state.dart';
import '../../domain/entities/lead_image_entity.dart';
import '../providers/image_limit_providers.dart';

part 'image_gallery_state.freezed.dart';

@freezed
abstract class ImageGalleryState with _$ImageGalleryState implements BaseState {
  const ImageGalleryState._();

  const factory ImageGalleryState({
    @Default(CoreState()) CoreState core,
    required String leadId,
    @Default([]) List<LeadImageEntity> images,
    @Default(0) int currentCount,
    @Default(10) int maxCount,
    @Default(0) int selectedIndex,
    @Default(false) bool isUploading,
    @Default(false) bool isDeleting,
    double? uploadProgress,
    String? errorMessage,
    @Default(false) bool showLimitWarning,
    LeadImageEntity? imageBeingReplaced,
    @Default(ImageAction.none) ImageAction lastAction,
  }) = _ImageGalleryState;

  @override
  bool get isBusy => core.isBusy || isUploading || isDeleting;

  @override
  bool get showAppBar => core.showAppBar;

  @override
  String get busyOperation => core.busyOperation;

  @override
  String get title => '$currentCount of $maxCount Images';

  @override
  GlobalKey? get widgetKeyForLoadingPosition => core.widgetKeyForLoadingPosition;

  int get slotsAvailable => maxCount - currentCount;

  bool get canAddMore => currentCount < maxCount;

  bool get isAtLimit => currentCount >= maxCount;

  bool get isNearLimit => currentCount >= (maxCount - 2);

  String get limitStatusMessage {
    if (isAtLimit) {
      return 'Image limit reached. Delete an image to add more.';
    } else if (isNearLimit) {
      return 'You can add $slotsAvailable more image(s).';
    } else {
      return '$slotsAvailable slots available';
    }
  }

  double get capacityPercentage => (currentCount / maxCount) * 100;

  String get imageStatusText => '$currentCount of $maxCount images';
}
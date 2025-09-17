import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import '../../l10n/app_localizations.dart';
import '../../features/lead_image/domain/constants/image_constants.dart';

/// Specialized accessibility announcements for image count and limits
class ImageCountAnnouncements {
  /// Announce when image is added
  static void announceImageAdded({
    required BuildContext context,
    required int newCount,
    required String? imageName,
  }) {
    final remaining = ImageConstants.maxImagesPerLead - newCount;

    String message;
    if (imageName != null) {
      message = 'Image $imageName added. $newCount of ${ImageConstants.maxImagesPerLead} images. $remaining slots remaining.';
    } else {
      message = 'Image added. $newCount of ${ImageConstants.maxImagesPerLead} images. $remaining slots remaining.';
    }

    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Announce when approaching limit
  static void announceApproachingLimit({
    required BuildContext context,
    required int currentCount,
  }) {
    final remaining = ImageConstants.maxImagesPerLead - currentCount;
    final message = 'Approaching image limit. Only $remaining slots remaining.';

    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Announce limit reached
  static void announceLimitReached({
    required BuildContext context,
  }) {
    final l10n = AppLocalizations.of(context);
    final message = l10n?.maximumImagesReached ??
        'Maximum ${ImageConstants.maxImagesPerLead} images reached. Delete one to continue.';

    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Announce image removed/deleted
  static void announceImageRemoved({
    required BuildContext context,
    required int newCount,
    required String? imageName,
  }) {
    final remaining = ImageConstants.maxImagesPerLead - newCount;

    String message;
    if (imageName != null) {
      message = 'Image $imageName removed. $newCount of ${ImageConstants.maxImagesPerLead} images remaining. $remaining slots available.';
    } else {
      message = 'Image removed. $newCount of ${ImageConstants.maxImagesPerLead} images remaining. $remaining slots available.';
    }

    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Announce image replaced
  static void announceImageReplaced({
    required BuildContext context,
    required String? oldImageName,
    required String? newImageName,
    required int count,
  }) {
    String message;
    if (oldImageName != null && newImageName != null) {
      message = 'Image $oldImageName replaced with $newImageName. $count of ${ImageConstants.maxImagesPerLead} images.';
    } else {
      message = 'Image replaced. $count of ${ImageConstants.maxImagesPerLead} images.';
    }

    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Announce slot availability
  static void announceSlotAvailability({
    required BuildContext context,
    required int currentCount,
  }) {
    final l10n = AppLocalizations.of(context);
    final available = ImageConstants.maxImagesPerLead - currentCount;

    final message = l10n?.slotsAvailable(available) ?? '$available slots available';
    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Announce gallery state
  static void announceGalleryState({
    required BuildContext context,
    required int imageCount,
  }) {
    final l10n = AppLocalizations.of(context);
    final message = l10n?.imageGalleryAccessibility(
      imageCount,
      ImageConstants.maxImagesPerLead
    ) ?? 'Image gallery with $imageCount images. Maximum ${ImageConstants.maxImagesPerLead} images allowed';

    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Announce batch upload result
  static void announceBatchUploadResult({
    required BuildContext context,
    required int successCount,
    required int failedCount,
    required int newTotalCount,
  }) {
    String message;
    if (failedCount > 0) {
      message = 'Batch upload completed. $successCount images uploaded, $failedCount failed. $newTotalCount of ${ImageConstants.maxImagesPerLead} images total.';
    } else {
      message = 'Batch upload completed. $successCount images uploaded successfully. $newTotalCount of ${ImageConstants.maxImagesPerLead} images total.';
    }

    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Announce upload queue status
  static void announceUploadQueueStatus({
    required BuildContext context,
    required int pendingCount,
    required int completedCount,
    required int failedCount,
  }) {
    String message = 'Upload queue status: ';
    if (pendingCount > 0) {
      message += '$pendingCount pending, ';
    }
    if (completedCount > 0) {
      message += '$completedCount completed, ';
    }
    if (failedCount > 0) {
      message += '$failedCount failed';
    } else {
      message = message.replaceAll(RegExp(r', $'), '');
    }

    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Announce image view navigation
  static void announceImageViewNavigation({
    required BuildContext context,
    required int currentIndex,
    required int totalCount,
    required String? imageName,
  }) {
    final l10n = AppLocalizations.of(context);
    final position = l10n?.imageCountAnnouncement(currentIndex + 1, totalCount) ??
        'Image ${currentIndex + 1} of $totalCount';

    String message = position;
    if (imageName != null) {
      message += '. Image name: $imageName';
    }

    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Announce upload limit reached with suggestions
  static void announceUploadLimitWithSuggestions({
    required BuildContext context,
  }) {
    final l10n = AppLocalizations.of(context);
    final baseMessage = l10n?.maximumImagesReached ??
        'Maximum ${ImageConstants.maxImagesPerLead} images reached.';

    final suggestions = l10n?.deleteImageToAddMore ?? 'Delete an image to add more';
    final fullMessage = '$baseMessage $suggestions';

    SemanticsService.announce(fullMessage, TextDirection.ltr);
  }

  /// Announce compression status
  static void announceCompressionStatus({
    required BuildContext context,
    required String status, // 'starting', 'progress', 'completed', 'failed'
    double? progress,
  }) {
    String message;
    switch (status) {
      case 'starting':
        message = 'Compressing image to reduce size';
        break;
      case 'progress':
        final percentage = progress != null ? (progress * 100).round() : 0;
        message = 'Compressing image, $percentage percent complete';
        break;
      case 'completed':
        message = 'Image compression completed';
        break;
      case 'failed':
        message = 'Image compression failed';
        break;
      default:
        message = 'Image compression $status';
    }

    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Announce validation errors for image uploads
  static void announceImageValidationError({
    required BuildContext context,
    required String errorType, // 'size', 'format', 'limit', 'network'
    String? details,
  }) {
    final l10n = AppLocalizations.of(context);
    String message;

    switch (errorType) {
      case 'size':
        message = l10n?.imageTooLarge ?? 'Image too large';
        break;
      case 'format':
        message = 'Unsupported image format';
        break;
      case 'limit':
        message = l10n?.maximumImagesReached ??
            'Maximum ${ImageConstants.maxImagesPerLead} images reached';
        break;
      case 'network':
        message = l10n?.networkError ?? 'Network error';
        break;
      default:
        message = 'Image validation error';
    }

    if (details != null) {
      message += ': $details';
    }

    SemanticsService.announce(message, TextDirection.ltr);
  }
}
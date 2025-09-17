import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import '../../l10n/app_localizations.dart';

/// Helper class for managing screen reader announcements
class ScreenReaderAnnouncements {
  /// Announce image count changes
  static void announceImageCount({
    required BuildContext context,
    required int current,
    required int total,
  }) {
    final l10n = AppLocalizations.of(context);
    final message = l10n?.imageCountAnnouncement(current, total) ??
        'Image $current of $total';

    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Announce image limit status
  static void announceImageLimitStatus({
    required BuildContext context,
    required int current,
    required int max,
  }) {
    final l10n = AppLocalizations.of(context);
    final message = l10n?.imageLimitStatus(current, max) ??
        '$current of $max images used';

    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Announce upload progress
  static void announceUploadProgress({
    required BuildContext context,
    required double progress,
  }) {
    final percentage = (progress * 100).round();
    SemanticsService.announce(
      'Upload $percentage percent complete',
      TextDirection.ltr,
    );
  }

  /// Announce upload completion
  static void announceUploadComplete({
    required BuildContext context,
    required String imageName,
  }) {
    final l10n = AppLocalizations.of(context);
    final message = '${l10n?.uploadComplete ?? "Upload complete"}: $imageName';

    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Announce upload failure
  static void announceUploadFailure({
    required BuildContext context,
    required String imageName,
    String? errorMessage,
  }) {
    final l10n = AppLocalizations.of(context);
    final baseMessage = '${l10n?.uploadFailed ?? "Upload failed"}: $imageName';
    final message = errorMessage != null ? '$baseMessage. $errorMessage' : baseMessage;

    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Announce image deletion
  static void announceImageDeleted({
    required BuildContext context,
    required String imageName,
    required int remainingCount,
    required int maxCount,
  }) {
    final message = 'Image $imageName deleted. $remainingCount of $maxCount images remaining';

    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Announce limit reached
  static void announceLimitReached({
    required BuildContext context,
    required int maxCount,
  }) {
    final l10n = AppLocalizations.of(context);
    final message = l10n?.maximumImagesReached ??
        'Maximum $maxCount images reached. Delete one to continue.';

    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Announce network status change
  static void announceNetworkStatus({
    required BuildContext context,
    required bool isOnline,
  }) {
    final l10n = AppLocalizations.of(context);
    final message = isOnline
        ? (l10n?.onlineMode ?? 'Online mode')
        : (l10n?.offlineMode ?? 'Offline mode');

    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Announce retry attempt
  static void announceRetryAttempt({
    required BuildContext context,
    required int attempt,
    required int maxAttempts,
  }) {
    final message = 'Retry attempt $attempt of $maxAttempts';
    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Generic announcement with fallback
  static void announce({
    required BuildContext context,
    required String message,
    String? fallback,
  }) {
    SemanticsService.announce(
      message.isNotEmpty ? message : (fallback ?? 'Action completed'),
      TextDirection.ltr,
    );
  }

  /// Announce page navigation
  static void announcePageNavigation({
    required BuildContext context,
    required String pageName,
  }) {
    SemanticsService.announce(
      'Navigated to $pageName',
      TextDirection.ltr,
    );
  }

  /// Announce form validation errors
  static void announceValidationError({
    required BuildContext context,
    required String fieldName,
    required String errorMessage,
  }) {
    SemanticsService.announce(
      '$fieldName error: $errorMessage',
      TextDirection.ltr,
    );
  }

  /// Announce loading state
  static void announceLoading({
    required BuildContext context,
    required String operation,
  }) {
    final l10n = AppLocalizations.of(context);
    final message = '${l10n?.loading ?? "Loading"} $operation';

    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Announce completion of operation
  static void announceCompletion({
    required BuildContext context,
    required String operation,
  }) {
    SemanticsService.announce(
      '$operation completed',
      TextDirection.ltr,
    );
  }
}
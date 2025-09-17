import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../utils/app_logger.dart';
import '../../l10n/app_localizations.dart';
import '../../features/lead_image/domain/constants/image_constants.dart';
import '../../app/router/route_names.dart';

/// Specialized error handler for image limit violations
class ImageLimitErrorHandler {
  /// Handle when user tries to add more than 10 images
  static Future<void> handleLimitReached({
    required BuildContext context,
    required WidgetRef ref,
    required String leadId,
    required int currentCount,
    VoidCallback? onReplaceSelected,
    VoidCallback? onDeleteSelected,
  }) async {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    AppLogger.info(
      'Image limit reached for lead $leadId: $currentCount/${ImageConstants.maxImagesPerLead}',
    );

    final result = await showDialog<ImageLimitAction>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: theme.colorScheme.tertiary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n?.imageLimitReached ?? 'Image Limit Reached',
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n?.imageLimitReachedMessage(ImageConstants.maxImagesPerLead, currentCount) ?? 'You have reached the maximum of ${ImageConstants.maxImagesPerLead} images for this lead. You currently have $currentCount images.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n?.yourOptions ?? 'Your Options',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildOption(
                      icon: Icons.swap_horiz,
                      text: 'Replace an existing image',
                      theme: theme,
                    ),
                    const SizedBox(height: 4),
                    _buildOption(
                      icon: Icons.delete_outline,
                      text: 'Delete an image to make space',
                      theme: theme,
                    ),
                    const SizedBox(height: 4),
                    _buildOption(
                      icon: Icons.close,
                      text: 'Cancel upload',
                      theme: theme,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(ImageLimitAction.cancel),
              child: Text('Cancel'),
            ),
            TextButton.icon(
              onPressed: () => Navigator.of(dialogContext).pop(ImageLimitAction.delete),
              icon: const Icon(Icons.delete_outline, size: 20),
              label: Text('Delete Image'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.of(dialogContext).pop(ImageLimitAction.replace),
              icon: const Icon(Icons.swap_horiz, size: 20),
              label: Text('Replace Image'),
            ),
          ],
        );
      },
    );

    // Handle user selection
    if (result != null) {
      switch (result) {
        case ImageLimitAction.replace:
          AppLogger.info('User selected to replace an image');
          if (context.mounted) {
            if (onReplaceSelected != null) {
              onReplaceSelected();
            } else {
              _navigateToReplaceFlow(context, leadId);
            }
          }
          break;

        case ImageLimitAction.delete:
          AppLogger.info('User selected to delete an image');
          if (context.mounted) {
            if (onDeleteSelected != null) {
              onDeleteSelected();
            } else {
              _navigateToGalleryForDeletion(context, leadId);
            }
          }
          break;

        case ImageLimitAction.cancel:
          AppLogger.info('User cancelled image upload');
          break;
      }
    }
  }

  /// Build option widget
  static Widget _buildOption({
    required IconData icon,
    required String text,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onPrimaryContainer,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
      ],
    );
  }

  /// Navigate to replacement flow
  static void _navigateToReplaceFlow(BuildContext context, String leadId) {
    context.go(RouteNames.getLeadDetailPath(leadId));
  }

  /// Navigate to gallery for deletion
  static void _navigateToGalleryForDeletion(BuildContext context, String leadId) {
    context.go(RouteNames.getLeadDetailPath(leadId));
  }

  /// Show near-limit warning
  static void showNearLimitWarning({
    required BuildContext context,
    required int currentCount,
    required int slotsRemaining,
  }) {
    final theme = Theme.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: theme.colorScheme.onTertiaryContainer,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Only $slotsRemaining image slots remaining',
                style: TextStyle(
                  color: theme.colorScheme.onTertiaryContainer,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: theme.colorScheme.tertiaryContainer,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Got It',
          textColor: theme.colorScheme.tertiary,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Handle image size limit exceeded
  static Future<void> handleSizeLimitExceeded({
    required BuildContext context,
    required int imageSize,
    required int maxSize,
    VoidCallback? onCompress,
  }) async {
    final theme = Theme.of(context);

    final sizeInMB = (imageSize / 1048576).toStringAsFixed(1);
    final maxSizeInMB = (maxSize / 1048576).toStringAsFixed(0);

    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.photo_size_select_large,
                color: theme.colorScheme.error,
              ),
              const SizedBox(width: 12),
              Text('Image Too Large'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Image is ${sizeInMB}MB but max size is ${maxSizeInMB}MB',
              ),
              if (onCompress != null) ...[
                const SizedBox(height: 16),
                Text(
                  'We can compress the image for you',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text('Cancel'),
            ),
            if (onCompress != null)
              FilledButton.icon(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                icon: const Icon(Icons.compress, size: 20),
                label: Text('Compress & Upload'),
              ),
          ],
        );
      },
    );

    if (result == true && onCompress != null) {
      onCompress();
    }
  }
}

/// Actions user can take when limit is reached
enum ImageLimitAction {
  replace,
  delete,
  cancel,
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/atoms/app_button_atom.dart';
import '../../../../app/router/route_names.dart';
import '../../domain/constants/image_constants.dart';

/// Widget for recovering from image limit errors
class LimitErrorRecoveryWidget extends ConsumerWidget {
  final String leadId;
  final int currentCount;
  final VoidCallback? onRetry;
  final VoidCallback? onCancel;

  const LimitErrorRecoveryWidget({
    super.key,
    required this.leadId,
    required this.currentCount,
    this.onRetry,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error icon with limit indicator
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.errorContainer.withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    Icons.photo_library_outlined,
                    size: 60,
                    color: colorScheme.error,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${ImageConstants.maxImagesPerLead}',
                      style: TextStyle(
                        color: colorScheme.onError,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Error title
            Text(
              l10n?.imageLimitReached ?? 'Image Limit Reached',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Error message
            Text(
              l10n?.imageLimitReachedMessage(ImageConstants.maxImagesPerLead, currentCount) ?? 'You have reached the maximum of ${ImageConstants.maxImagesPerLead} images for this lead. You currently have $currentCount images.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Recovery options
            _buildRecoveryOptions(context, ref, l10n, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildRecoveryOptions(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations? l10n,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n?.whatWouldYouLikeToDo ?? 'What would you like to do?',
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Replace image option
          AppButtonAtom.primary(
            onPressed: () => _handleReplaceImage(context),
            text: l10n?.replaceExistingImage ?? 'Replace Existing Image',
            icon: Icons.swap_horiz,
          ),
          const SizedBox(height: 12),

          // View gallery option
          AppButtonAtom.secondary(
            onPressed: () => _handleViewGallery(context),
            text: l10n?.viewImageGallery ?? 'View Image Gallery',
            icon: Icons.photo_library_outlined,
          ),
          const SizedBox(height: 12),

          // Cancel option
          AppTextButtonAtom(
            onPressed: onCancel ?? () => Navigator.of(context).pop(),
            text: l10n?.cancel ?? 'Cancel',
          ),
        ],
      ),
    );
  }

  void _handleReplaceImage(BuildContext context) {
    context.go(RouteNames.getLeadDetailPath(leadId));
  }

  void _handleViewGallery(BuildContext context) {
    context.go(RouteNames.getLeadDetailPath(leadId));
  }
}

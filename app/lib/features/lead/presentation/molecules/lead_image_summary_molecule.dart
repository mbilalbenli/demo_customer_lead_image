import 'package:flutter/material.dart';
import '../atoms/lead_image_count_badge_atom.dart';
import '../../../../core/widgets/molecules/app_limit_indicator_molecule.dart';
import '../../../../core/widgets/atoms/app_button_atom.dart';
import '../../../../core/widgets/atoms/app_icon_button_atom.dart';

/// A feature-specific molecule for displaying lead image summary
/// Shows image count, slots available, and manage action
/// Following atomic design principles - composed from atoms
class LeadImageSummaryMolecule extends StatelessWidget {
  final int currentImageCount;
  final int maxImageCount;
  final VoidCallback? onManageImages;
  final VoidCallback? onAddImage;
  final bool showAddButton;
  final bool detailed;

  const LeadImageSummaryMolecule({
    super.key,
    required this.currentImageCount,
    this.maxImageCount = 10, // Project requirement
    this.onManageImages,
    this.onAddImage,
    this.showAddButton = true,
    this.detailed = false,
  });

  @override
  Widget build(BuildContext context) {
    if (detailed) {
      return _buildDetailedView(context);
    } else {
      return _buildCompactView(context);
    }
  }

  Widget _buildCompactView(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final canAddMore = currentImageCount < maxImageCount;
    final slotsRemaining = maxImageCount - currentImageCount;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: currentImageCount >= maxImageCount
              ? colorScheme.error.withValues(alpha: 0.3)
              : colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.photo_library_outlined,
            color: colorScheme.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Images',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '$currentImageCount of $maxImageCount ($slotsRemaining slots left)',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: currentImageCount >= maxImageCount
                        ? colorScheme.error
                        : colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          if (showAddButton && canAddMore)
            AppIconButtonAtom(
              icon: Icons.add_photo_alternate,
              onPressed: onAddImage,
              tooltip: 'Add image',
              size: 20,
            )
          else if (onManageImages != null)
            AppTextButtonAtom(
              text: 'Manage',
              onPressed: onManageImages,
            ),
        ],
      ),
    );
  }

  Widget _buildDetailedView(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final canAddMore = currentImageCount < maxImageCount;
    final slotsRemaining = maxImageCount - currentImageCount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer.withValues(alpha: 0.1),
            colorScheme.primaryContainer.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: currentImageCount >= maxImageCount
              ? colorScheme.error.withValues(alpha: 0.3)
              : colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.photo_library,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Image Storage',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              LeadImageCountBadgeAtom(
                currentCount: currentImageCount,
                maxCount: maxImageCount,
                style: BadgeStyle.standard,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress Indicator
          AppLimitIndicatorMolecule(
            current: currentImageCount,
            max: maxImageCount,
            style: LimitIndicatorStyle.progress,
            label: 'Usage',
          ),

          const SizedBox(height: 12),

          // Status Text
          RichText(
            text: TextSpan(
              style: theme.textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: 'You have ',
                  style: TextStyle(color: colorScheme.onSurface),
                ),
                TextSpan(
                  text: '$currentImageCount',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' images stored with ',
                  style: TextStyle(color: colorScheme.onSurface),
                ),
                TextSpan(
                  text: '$slotsRemaining',
                  style: TextStyle(
                    color: canAddMore ? colorScheme.primary : colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' slots remaining.',
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Visual Slots
          LeadImageSlotsIndicatorAtom(
            filledSlots: currentImageCount,
            totalSlots: maxImageCount,
            onTap: onManageImages,
          ),

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              if (canAddMore && showAddButton && onAddImage != null)
                Expanded(
                  child: AppButtonAtom(
                    text: 'Add Images',
                    onPressed: onAddImage,
                    icon: Icon(Icons.add_photo_alternate, size: 18),
                  ),
                ),
              if (canAddMore && onManageImages != null)
                const SizedBox(width: 8),
              if (onManageImages != null)
                Expanded(
                  child: AppOutlinedButtonAtom(
                    text: 'Manage Images',
                    onPressed: onManageImages,
                    icon: Icon(Icons.settings, size: 18),
                  ),
                ),
            ],
          ),

          if (!canAddMore) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: colorScheme.error,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Storage limit reached. Delete existing images to add new ones.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A mini summary widget for image count
class LeadImageMiniSummaryMolecule extends StatelessWidget {
  final int imageCount;
  final VoidCallback? onTap;

  const LeadImageMiniSummaryMolecule({
    super.key,
    required this.imageCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasImages = imageCount > 0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: hasImages
              ? colorScheme.primaryContainer.withValues(alpha: 0.3)
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasImages ? Icons.photo : Icons.add_photo_alternate,
              size: 14,
              color: hasImages
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              hasImages ? '$imageCount images' : 'No images',
              style: theme.textTheme.bodySmall?.copyWith(
                color: hasImages
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                fontWeight: hasImages ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../atoms/slot_indicator_atom.dart';
import '../atoms/limit_warning_atom.dart';

/// Simple organism showing image limit info and status
/// No replacement flow - just counts and delete functionality
class ImageLimitInfoOrganism extends StatelessWidget {
  final int currentCount;
  final int maxCount;
  final VoidCallback? onManageImages;

  const ImageLimitInfoOrganism({
    super.key,
    required this.currentCount,
    required this.maxCount,
    this.onManageImages,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAtLimit = currentCount >= maxCount;
    final slotsAvailable = maxCount - currentCount;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Image Storage',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isAtLimit
                        ? colorScheme.errorContainer
                        : colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$currentCount / $maxCount',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: isAtLimit
                          ? colorScheme.onErrorContainer
                          : colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Visual slot indicator
            SlotIndicatorAtom.bar(
              filled: currentCount,
              total: maxCount,
            ),
            const SizedBox(height: 8),

            // Status text
            Text(
              isAtLimit
                  ? 'Storage full - Delete images to add more'
                  : '$slotsAvailable ${slotsAvailable == 1 ? 'slot' : 'slots'} available',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isAtLimit
                    ? colorScheme.error
                    : colorScheme.onSurfaceVariant,
              ),
            ),

            // Warning at limit
            if (isAtLimit) ...[
              const SizedBox(height: 12),
              LimitWarningAtom(
                currentCount: currentCount,
                maxCount: maxCount,
                level: WarningLevel.atLimit,
              ),
            ] else if (currentCount >= maxCount - 2) ...[
              const SizedBox(height: 12),
              LimitWarningAtom(
                currentCount: currentCount,
                maxCount: maxCount,
                level: WarningLevel.approaching,
              ),
            ],

            // Manage button
            if (onManageImages != null && currentCount > 0) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onManageImages,
                  icon: const Icon(Icons.photo_library, size: 18),
                  label: const Text('Manage Images'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
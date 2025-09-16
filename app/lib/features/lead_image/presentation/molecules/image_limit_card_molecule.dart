import 'package:flutter/material.dart';
import '../atoms/slot_indicator_atom.dart';
import '../atoms/limit_warning_atom.dart';
import '../atoms/image_count_badge_atom.dart';
import '../../../../core/widgets/atoms/app_button_atom.dart';

/// A molecule for displaying image limit status in a card
/// Following atomic design principles - composed from atoms  
class ImageLimitCardMolecule extends StatelessWidget {
  final int currentCount;
  final int maxCount;
  final VoidCallback? onManageImages;
  final VoidCallback? onAddImage;
  final bool showActions;
  final CardStyle style;

  const ImageLimitCardMolecule({
    super.key,
    required this.currentCount,
    this.maxCount = 10,
    this.onManageImages,
    this.onAddImage,
    this.showActions = true,
    this.style = CardStyle.standard,
  });

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case CardStyle.standard:
        return _buildStandardCard(context);
      case CardStyle.compact:
        return _buildCompactCard(context);
      case CardStyle.detailed:
        return _buildDetailedCard(context);
    }
  }

  Widget _buildStandardCard(BuildContext context) {
    final theme = Theme.of(context);
    final isAtLimit = currentCount >= maxCount;
    final isNearLimit = currentCount >= maxCount - 2;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Image Storage',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ImageCountBadgeAtom.standard(
                  count: currentCount,
                  maxCount: maxCount,
                ),
              ],
            ),
            const SizedBox(height: 12),
            SlotIndicatorAtom.bar(
              filled: currentCount,
              total: maxCount,
            ),
            if (isNearLimit || isAtLimit) ...[
              const SizedBox(height: 12),
              LimitWarningAtom(
                currentCount: currentCount,
                maxCount: maxCount,
                compact: true,
              ),
            ],
            if (showActions) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  if (!isAtLimit && onAddImage != null)
                    Expanded(
                      child: AppButtonAtom(
                        text: 'Add Image',
                        onPressed: onAddImage,
                        icon: const Icon(Icons.add_photo_alternate, size: 18),
                      ),
                    ),
                  if (!isAtLimit && onManageImages != null)
                    const SizedBox(width: 8),
                  if (onManageImages != null)
                    Expanded(
                      child: AppOutlinedButtonAtom(
                        text: 'Manage',
                        onPressed: onManageImages,
                        icon: const Icon(Icons.settings, size: 18),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompactCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAtLimit = currentCount >= maxCount;
    final slotsRemaining = maxCount - currentCount;

    return Card(
      child: InkWell(
        onTap: onManageImages,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isAtLimit
                      ? colorScheme.errorContainer
                      : colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isAtLimit ? Icons.folder_off : Icons.folder_special,
                  color: isAtLimit
                      ? colorScheme.onErrorContainer
                      : colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isAtLimit ? 'Storage Full' : '$slotsRemaining slots left',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    CompactSlotIndicatorAtom(
                      filledSlots: currentCount,
                      totalSlots: maxCount,
                    ),
                  ],
                ),
              ),
              ImageCountBadgeAtom.minimal(
                count: currentCount,
                maxCount: maxCount,
              ),
              if (onManageImages != null)
                const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailedCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final slotsRemaining = maxCount - currentCount;
    final isAtLimit = currentCount >= maxCount;
    final storageUsed = currentCount * 2; // Assuming 2MB average per image

    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isAtLimit
                    ? [
                        colorScheme.errorContainer,
                        colorScheme.errorContainer.withValues(alpha: 0.5),
                      ]
                    : [
                        colorScheme.primaryContainer,
                        colorScheme.primaryContainer.withValues(alpha: 0.5),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                ImageCountBadgeAtom.prominent(
                  count: currentCount,
                  maxCount: maxCount,
                ),
                const SizedBox(height: 8),
                Text(
                  isAtLimit
                      ? 'No more images can be added'
                      : '$slotsRemaining more ${slotsRemaining == 1 ? 'image' : 'images'} can be added',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SlotIndicatorAtom(
                  filledSlots: currentCount,
                  totalSlots: maxCount,
                  style: SlotStyle.numbered,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      context,
                      'Used',
                      '$currentCount',
                      Icons.photo,
                      colorScheme.primary,
                    ),
                    _buildStatItem(
                      context,
                      'Available',
                      '$slotsRemaining',
                      Icons.add_photo_alternate,
                      isAtLimit ? colorScheme.error : colorScheme.primary,
                    ),
                    _buildStatItem(
                      context,
                      'Storage',
                      '${storageUsed}MB',
                      Icons.storage,
                      colorScheme.secondary,
                    ),
                  ],
                ),
                if (currentCount >= maxCount - 2) ...[
                  const SizedBox(height: 16),
                  AnimatedLimitWarningAtom(
                    currentCount: currentCount,
                    maxCount: maxCount,
                  ),
                ],
                if (showActions) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (!isAtLimit && onAddImage != null)
                        Expanded(
                          child: AppButtonAtom(
                            text: slotsRemaining == 1
                                ? 'Add Last Image'
                                : 'Add Images',
                            onPressed: onAddImage,
                            icon: const Icon(Icons.add_photo_alternate, size: 18),
                          ),
                        ),
                      if (!isAtLimit && onManageImages != null)
                        const SizedBox(width: 8),
                      if (onManageImages != null)
                        Expanded(
                          child: AppOutlinedButtonAtom(
                            text: 'View All',
                            onPressed: onManageImages,
                            icon: const Icon(Icons.photo_library, size: 18),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

enum CardStyle {
  standard,
  compact,
  detailed,
}
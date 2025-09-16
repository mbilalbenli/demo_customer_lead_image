import 'package:flutter/material.dart';
import '../atoms/add_image_button_atom.dart';
import '../atoms/limit_warning_atom.dart';

/// A molecule for displaying slot availability as a bar
/// Following atomic design principles - composed from atoms
class SlotAvailabilityBarMolecule extends StatelessWidget {
  final int filledSlots;
  final int totalSlots;
  final VoidCallback? onAddImage;
  final VoidCallback? onManageImages;
  final bool showActions;
  final bool alwaysShowWarning;

  const SlotAvailabilityBarMolecule({
    super.key,
    required this.filledSlots,
    this.totalSlots = 10,
    this.onAddImage,
    this.onManageImages,
    this.showActions = true,
    this.alwaysShowWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final availableSlots = totalSlots - filledSlots;
    final percentage = (filledSlots / totalSlots * 100).round();
    final isAtLimit = filledSlots >= totalSlots;
    final isNearLimit = filledSlots >= totalSlots - 2;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.surface,
            colorScheme.surface.withValues(alpha: 0.95),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAtLimit
              ? colorScheme.error.withValues(alpha: 0.3)
              : isNearLimit
                  ? colorScheme.tertiary.withValues(alpha: 0.3)
                  : colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: (isAtLimit
                    ? colorScheme.error
                    : isNearLimit
                        ? colorScheme.tertiary
                        : colorScheme.primary)
                .withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isAtLimit
                        ? Icons.storage_rounded
                        : Icons.photo_size_select_actual,
                    color: isAtLimit
                        ? colorScheme.error
                        : isNearLimit
                            ? colorScheme.tertiary
                            : colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Image Slots',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isAtLimit
                      ? colorScheme.errorContainer
                      : isNearLimit
                          ? colorScheme.tertiaryContainer
                          : colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isAtLimit
                      ? 'FULL'
                      : availableSlots == 1
                          ? '1 LEFT'
                          : '$availableSlots LEFT',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: isAtLimit
                        ? colorScheme.onErrorContainer
                        : isNearLimit
                            ? colorScheme.onTertiaryContainer
                            : colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Visual progress bar with segments
          _buildSegmentedProgressBar(context),

          const SizedBox(height: 8),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$filledSlots of $totalSlots used',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '$percentage%',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isAtLimit
                      ? colorScheme.error
                      : isNearLimit
                          ? colorScheme.tertiary
                          : colorScheme.primary,
                ),
              ),
            ],
          ),

          // Warning message
          if ((isNearLimit || isAtLimit) || alwaysShowWarning) ...[
            const SizedBox(height: 12),
            AnimatedLimitWarningAtom(
              currentCount: filledSlots,
              maxCount: totalSlots,
            ),
          ],

          // Actions
          if (showActions && (onAddImage != null || onManageImages != null)) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                if (onAddImage != null && !isAtLimit)
                  Expanded(
                    child: AddImageButtonAtom(
                      onAdd: onAddImage,
                      currentCount: filledSlots,
                      maxCount: totalSlots,
                      variant: ButtonVariant.outlined,
                      showCount: false,
                      size: 16,
                    ),
                  ),
                if (onAddImage != null && !isAtLimit && onManageImages != null)
                  const SizedBox(width: 8),
                if (onManageImages != null)
                  if (isAtLimit || onAddImage == null)
                    Expanded(
                      child: TextButton.icon(
                        onPressed: onManageImages,
                        icon: const Icon(Icons.settings, size: 16),
                        label: const Text('Manage'),
                      ),
                    )
                  else
                    TextButton(
                      onPressed: onManageImages,
                      child: const Text('Manage'),
                    ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSegmentedProgressBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 24,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        children: [
          // Background segments
          Row(
            children: List.generate(totalSlots, (index) {
              final isLast = index == totalSlots - 1;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: isLast ? 0 : 1),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.horizontal(
                      left: index == 0 ? const Radius.circular(4) : Radius.zero,
                      right: isLast ? const Radius.circular(4) : Radius.zero,
                    ),
                  ),
                ),
              );
            }),
          ),
          // Filled segments
          Row(
            children: List.generate(totalSlots, (index) {
              final isFilled = index < filledSlots;
              final isLast = index == totalSlots - 1;
              final isLastFilled = index == filledSlots - 1;

              Color segmentColor;
              if (isFilled) {
                if (index >= totalSlots - 2) {
                  segmentColor = colorScheme.error;
                } else if (index >= totalSlots - 4) {
                  segmentColor = colorScheme.tertiary;
                } else {
                  segmentColor = colorScheme.primary;
                }
              } else {
                segmentColor = Colors.transparent;
              }

              return Expanded(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200 + (index * 50)),
                  margin: EdgeInsets.only(right: isLast ? 0 : 1),
                  decoration: BoxDecoration(
                    color: segmentColor,
                    borderRadius: BorderRadius.horizontal(
                      left: index == 0 ? const Radius.circular(4) : Radius.zero,
                      right: isLast || isLastFilled
                          ? const Radius.circular(4)
                          : Radius.zero,
                    ),
                  ),
                  child: isFilled
                      ? Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        )
                      : null,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// A minimal slot availability indicator
class MinimalSlotBarMolecule extends StatelessWidget {
  final int filledSlots;
  final int totalSlots;
  final VoidCallback? onTap;

  const MinimalSlotBarMolecule({
    super.key,
    required this.filledSlots,
    this.totalSlots = 10,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAtLimit = filledSlots >= totalSlots;
    final availableSlots = totalSlots - filledSlots;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 60,
              height: 4,
              child: LinearProgressIndicator(
                value: filledSlots / totalSlots,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isAtLimit ? colorScheme.error : colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isAtLimit ? 'Full' : '$availableSlots left',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 11,
                color: isAtLimit ? colorScheme.error : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
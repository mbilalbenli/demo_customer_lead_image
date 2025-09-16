import 'package:flutter/material.dart';

/// An atom for visually showing available image slots
/// Displays filled and empty slots to indicate capacity
/// Following atomic design principles - smallest UI component
class SlotIndicatorAtom extends StatelessWidget {
  final int filledSlots;
  final int totalSlots;
  final SlotStyle style;
  final double size;
  final double spacing;
  final bool interactive;
  final ValueChanged<int>? onSlotTap;

  const SlotIndicatorAtom({
    super.key,
    required this.filledSlots,
    this.totalSlots = 10,
    this.style = SlotStyle.dots,
    this.size = 8,
    this.spacing = 4,
    this.interactive = false,
    this.onSlotTap,
  });

  /// Factory for dots style
  factory SlotIndicatorAtom.dots({
    Key? key,
    required int filled,
    int total = 10,
  }) {
    return SlotIndicatorAtom(
      key: key,
      filledSlots: filled,
      totalSlots: total,
      style: SlotStyle.dots,
    );
  }

  /// Factory for squares style
  factory SlotIndicatorAtom.squares({
    Key? key,
    required int filled,
    int total = 10,
  }) {
    return SlotIndicatorAtom(
      key: key,
      filledSlots: filled,
      totalSlots: total,
      style: SlotStyle.squares,
    );
  }

  /// Factory for bar style
  factory SlotIndicatorAtom.bar({
    Key? key,
    required int filled,
    int total = 10,
  }) {
    return SlotIndicatorAtom(
      key: key,
      filledSlots: filled,
      totalSlots: total,
      style: SlotStyle.bar,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case SlotStyle.dots:
        return _buildDots(context);
      case SlotStyle.squares:
        return _buildSquares(context);
      case SlotStyle.bar:
        return _buildBar(context);
      case SlotStyle.numbered:
        return _buildNumbered(context);
    }
  }

  Widget _buildDots(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isAtLimit = filledSlots >= totalSlots;
    final isNearLimit = filledSlots >= 8;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: List.generate(totalSlots, (index) {
        final isFilled = index < filledSlots;
        final slotWidget = AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled
                ? (isAtLimit
                    ? colorScheme.error
                    : isNearLimit && index >= 8
                        ? colorScheme.tertiary
                        : colorScheme.primary)
                : colorScheme.surfaceContainerHighest,
            border: Border.all(
              color: isFilled
                  ? Colors.transparent
                  : colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
        );

        if (interactive && onSlotTap != null) {
          return InkWell(
            onTap: () => onSlotTap!(index),
            borderRadius: BorderRadius.circular(size / 2),
            child: slotWidget,
          );
        }
        return slotWidget;
      }),
    );
  }

  Widget _buildSquares(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isAtLimit = filledSlots >= totalSlots;
    final isNearLimit = filledSlots >= 8;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: List.generate(totalSlots, (index) {
        final isFilled = index < filledSlots;
        final slotWidget = AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: size * 1.5,
          height: size * 1.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: isFilled
                ? (isAtLimit
                    ? colorScheme.error
                    : isNearLimit && index >= 8
                        ? colorScheme.tertiary
                        : colorScheme.primary)
                : colorScheme.surfaceContainerHighest,
            border: Border.all(
              color: isFilled
                  ? Colors.transparent
                  : colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: isFilled
              ? Icon(
                  Icons.photo,
                  size: size,
                  color: colorScheme.onPrimary,
                )
              : null,
        );

        if (interactive && onSlotTap != null) {
          return InkWell(
            onTap: () => onSlotTap!(index),
            borderRadius: BorderRadius.circular(2),
            child: slotWidget,
          );
        }
        return slotWidget;
      }),
    );
  }

  Widget _buildBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAtLimit = filledSlots >= totalSlots;
    final isNearLimit = filledSlots >= 8;
    final percentage = (filledSlots / totalSlots * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size / 2),
            color: colorScheme.surfaceContainerHighest,
          ),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: size,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size / 2),
                  color: colorScheme.surfaceContainerHighest,
                ),
              ),
              AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 300),
                widthFactor: filledSlots / totalSlots,
                child: Container(
                  height: size,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size / 2),
                    gradient: LinearGradient(
                      colors: isAtLimit
                          ? [colorScheme.error, colorScheme.error.withValues(alpha: 0.8)]
                          : isNearLimit
                              ? [
                                  colorScheme.tertiary,
                                  colorScheme.tertiary.withValues(alpha: 0.8)
                                ]
                              : [
                                  colorScheme.primary,
                                  colorScheme.primary.withValues(alpha: 0.8)
                                ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$filledSlots of $totalSlots slots used',
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
      ],
    );
  }

  Widget _buildNumbered(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAtLimit = filledSlots >= totalSlots;
    final isNearLimit = filledSlots >= 8;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: List.generate(totalSlots, (index) {
        final isFilled = index < filledSlots;
        final slotWidget = AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: size * 3,
          height: size * 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isFilled
                ? (isAtLimit
                    ? colorScheme.errorContainer
                    : isNearLimit && index >= 8
                        ? colorScheme.tertiaryContainer
                        : colorScheme.primaryContainer)
                : colorScheme.surfaceContainerHighest,
            border: Border.all(
              color: isFilled
                  ? (isAtLimit
                      ? colorScheme.error
                      : isNearLimit && index >= 8
                          ? colorScheme.tertiary
                          : colorScheme.primary)
                  : colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isFilled
                    ? (isAtLimit
                        ? colorScheme.onErrorContainer
                        : isNearLimit && index >= 8
                            ? colorScheme.onTertiaryContainer
                            : colorScheme.onPrimaryContainer)
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );

        if (interactive && onSlotTap != null) {
          return InkWell(
            onTap: () => onSlotTap!(index),
            borderRadius: BorderRadius.circular(4),
            child: slotWidget,
          );
        }
        return slotWidget;
      }),
    );
  }
}

enum SlotStyle {
  dots,
  squares,
  bar,
  numbered,
}

/// A compact slot indicator for inline use
class CompactSlotIndicatorAtom extends StatelessWidget {
  final int filledSlots;
  final int totalSlots;

  const CompactSlotIndicatorAtom({
    super.key,
    required this.filledSlots,
    this.totalSlots = 10,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAtLimit = filledSlots >= totalSlots;
    final emptySlots = totalSlots - filledSlots;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isAtLimit
            ? colorScheme.errorContainer.withValues(alpha: 0.3)
            : colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(filledSlots.clamp(0, totalSlots), (_) => '●'),
          ...List.generate(emptySlots.clamp(0, totalSlots), (_) => '○'),
        ]
            .map((dot) => Text(
                  dot,
                  style: TextStyle(
                    fontSize: 8,
                    color: isAtLimit ? colorScheme.error : colorScheme.primary,
                  ),
                ))
            .toList(),
      ),
    );
  }
}
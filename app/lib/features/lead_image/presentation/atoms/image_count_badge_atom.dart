import 'package:flutter/material.dart';

/// An atom for displaying image count in X/10 format
/// Shows visual warnings when approaching limit
/// Following atomic design principles - smallest UI component
class ImageCountBadgeAtom extends StatelessWidget {
  final int currentCount;
  final int maxCount;
  final BadgeStyle style;
  final bool showWarning;
  final double? fontSize;

  const ImageCountBadgeAtom({
    super.key,
    required this.currentCount,
    this.maxCount = 10,
    this.style = BadgeStyle.standard,
    this.showWarning = true,
    this.fontSize,
  });

  /// Factory for standard count display
  factory ImageCountBadgeAtom.standard({
    Key? key,
    required int count,
    int maxCount = 10,
  }) {
    return ImageCountBadgeAtom(
      key: key,
      currentCount: count,
      maxCount: maxCount,
      style: BadgeStyle.standard,
    );
  }

  /// Factory for prominent display
  factory ImageCountBadgeAtom.prominent({
    Key? key,
    required int count,
    int maxCount = 10,
  }) {
    return ImageCountBadgeAtom(
      key: key,
      currentCount: count,
      maxCount: maxCount,
      style: BadgeStyle.prominent,
    );
  }

  /// Factory for minimal display
  factory ImageCountBadgeAtom.minimal({
    Key? key,
    required int count,
    int maxCount = 10,
  }) {
    return ImageCountBadgeAtom(
      key: key,
      currentCount: count,
      maxCount: maxCount,
      style: BadgeStyle.minimal,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case BadgeStyle.standard:
        return _buildStandardBadge(context);
      case BadgeStyle.prominent:
        return _buildProminentBadge(context);
      case BadgeStyle.minimal:
        return _buildMinimalBadge(context);
    }
  }

  Widget _buildStandardBadge(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAtLimit = currentCount >= maxCount;
    final isNearLimit = currentCount >= 8;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isAtLimit
            ? colorScheme.errorContainer
            : isNearLimit
                ? colorScheme.tertiaryContainer
                : colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAtLimit
              ? colorScheme.error.withValues(alpha: 0.3)
              : isNearLimit
                  ? colorScheme.tertiary.withValues(alpha: 0.3)
                  : colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.photo_library,
            size: 14,
            color: isAtLimit
                ? colorScheme.onErrorContainer
                : isNearLimit
                    ? colorScheme.onTertiaryContainer
                    : colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 4),
          Text(
            '$currentCount/$maxCount',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              color: isAtLimit
                  ? colorScheme.onErrorContainer
                  : isNearLimit
                      ? colorScheme.onTertiaryContainer
                      : colorScheme.onPrimaryContainer,
            ),
          ),
          if (showWarning && isAtLimit) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.warning,
              size: 14,
              color: colorScheme.error,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProminentBadge(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAtLimit = currentCount >= maxCount;
    final isNearLimit = currentCount >= 8;
    final percentage = (currentCount / maxCount * 100).round();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isAtLimit
              ? [
                  colorScheme.errorContainer,
                  colorScheme.errorContainer.withValues(alpha: 0.8),
                ]
              : isNearLimit
                  ? [
                      colorScheme.tertiaryContainer,
                      colorScheme.tertiaryContainer.withValues(alpha: 0.8),
                    ]
                  : [
                      colorScheme.primaryContainer,
                      colorScheme.primaryContainer.withValues(alpha: 0.8),
                    ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isAtLimit
                    ? colorScheme.error
                    : isNearLimit
                        ? colorScheme.tertiary
                        : colorScheme.primary)
                .withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.photo_library,
                size: 24,
                color: isAtLimit
                    ? colorScheme.error
                    : isNearLimit
                        ? colorScheme.tertiary
                        : colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '$currentCount',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isAtLimit
                      ? colorScheme.error
                      : isNearLimit
                          ? colorScheme.tertiary
                          : colorScheme.primary,
                ),
              ),
              Text(
                ' / $maxCount',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            isAtLimit
                ? 'Storage Full'
                : isNearLimit
                    ? '${maxCount - currentCount} slots left'
                    : '$percentage% used',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isAtLimit
                  ? colorScheme.error
                  : isNearLimit
                      ? colorScheme.tertiary
                      : colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinimalBadge(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAtLimit = currentCount >= maxCount;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isAtLimit
            ? colorScheme.error.withValues(alpha: 0.2)
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$currentCount/$maxCount',
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: fontSize ?? 11,
          fontWeight: FontWeight.bold,
          color: isAtLimit ? colorScheme.error : colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

enum BadgeStyle {
  standard,
  prominent,
  minimal,
}
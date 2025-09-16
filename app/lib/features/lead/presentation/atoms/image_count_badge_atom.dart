import 'package:flutter/material.dart';

class ImageCountBadgeAtom extends StatelessWidget {
  final int count;
  final int maxCount;
  final ImageCountStyle style;

  const ImageCountBadgeAtom({
    super.key,
    required this.count,
    required this.maxCount,
    this.style = ImageCountStyle.compact,
  });

  factory ImageCountBadgeAtom.compact({
    required int count,
    required int maxCount,
    Key? key,
  }) {
    return ImageCountBadgeAtom(
      key: key,
      count: count,
      maxCount: maxCount,
      style: ImageCountStyle.compact,
    );
  }

  factory ImageCountBadgeAtom.prominent({
    required int count,
    required int maxCount,
    Key? key,
  }) {
    return ImageCountBadgeAtom(
      key: key,
      count: count,
      maxCount: maxCount,
      style: ImageCountStyle.prominent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAtLimit = count >= maxCount;
    final isNearLimit = count >= (maxCount * 0.8);

    final badgeColor = isAtLimit
        ? colorScheme.error
        : isNearLimit
            ? Colors.orange
            : colorScheme.primary;

    final backgroundColor = isAtLimit
        ? colorScheme.errorContainer
        : isNearLimit
            ? Colors.orange.shade50
            : colorScheme.primaryContainer;

    final textColor = isAtLimit
        ? colorScheme.onErrorContainer
        : isNearLimit
            ? Colors.orange.shade800
            : colorScheme.onPrimaryContainer;

    switch (style) {
      case ImageCountStyle.compact:
        return _buildCompactBadge(theme, badgeColor, backgroundColor, textColor);
      case ImageCountStyle.prominent:
        return _buildProminentBadge(theme, badgeColor, backgroundColor, textColor);
    }
  }

  Widget _buildCompactBadge(
    ThemeData theme,
    Color badgeColor,
    Color backgroundColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.photo_library,
            size: 12,
            color: badgeColor,
          ),
          const SizedBox(width: 4),
          Text(
            '$count/$maxCount',
            style: theme.textTheme.bodySmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProminentBadge(
    ThemeData theme,
    Color badgeColor,
    Color backgroundColor,
    Color textColor,
  ) {
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withValues(alpha: 0.1),
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
                size: 20,
                color: badgeColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Images',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$count of $maxCount',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (count >= maxCount) ...[
            const SizedBox(height: 4),
            Text(
              'Storage Full',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ] else if (count >= (maxCount * 0.8)) ...[
            const SizedBox(height: 4),
            Text(
              '${maxCount - count} remaining',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.orange.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

enum ImageCountStyle {
  compact,
  prominent,
}
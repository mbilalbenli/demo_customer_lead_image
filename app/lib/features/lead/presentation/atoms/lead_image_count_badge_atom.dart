import 'package:flutter/material.dart';
import '../../../../core/widgets/atoms/app_badge_atom.dart';

/// A feature-specific atom for displaying lead image count with maximum
/// Shows count in format "X/10" with visual warning when near or at limit
/// Following atomic design principles - smallest lead-specific image count component
class LeadImageCountBadgeAtom extends StatelessWidget {
  final int currentCount;
  final int maxCount;
  final VoidCallback? onTap;
  final BadgeStyle style;
  final bool showIcon;
  final bool animated;

  const LeadImageCountBadgeAtom({
    super.key,
    required this.currentCount,
    this.maxCount = 10, // Project requirement: max 10 images per lead
    this.onTap,
    this.style = BadgeStyle.standard,
    this.showIcon = true,
    this.animated = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isAtLimit = currentCount >= maxCount;
    final isNearLimit = currentCount >= (maxCount * 0.8).round();
    final hasImages = currentCount > 0;

    // Determine colors based on count status
    Color backgroundColor;
    Color textColor;
    IconData? icon;

    if (isAtLimit) {
      backgroundColor = colorScheme.errorContainer;
      textColor = colorScheme.onErrorContainer;
      icon = Icons.warning;
    } else if (isNearLimit) {
      backgroundColor = colorScheme.tertiaryContainer;
      textColor = colorScheme.onTertiaryContainer;
      icon = Icons.info_outline;
    } else if (hasImages) {
      backgroundColor = colorScheme.primaryContainer;
      textColor = colorScheme.onPrimaryContainer;
      icon = Icons.photo_library_outlined;
    } else {
      backgroundColor = colorScheme.surfaceContainerHighest;
      textColor = colorScheme.onSurfaceVariant;
      icon = Icons.add_photo_alternate_outlined;
    }

    Widget badge;

    switch (style) {
      case BadgeStyle.standard:
        badge = _buildStandardBadge(
          backgroundColor: backgroundColor,
          textColor: textColor,
          icon: showIcon ? icon : null,
        );
        break;
      case BadgeStyle.compact:
        badge = _buildCompactBadge(
          backgroundColor: backgroundColor,
          textColor: textColor,
        );
        break;
      case BadgeStyle.detailed:
        badge = _buildDetailedBadge(
          backgroundColor: backgroundColor,
          textColor: textColor,
          icon: showIcon ? icon : null,
          colorScheme: colorScheme,
        );
        break;
      case BadgeStyle.minimal:
        badge = _buildMinimalBadge(textColor: textColor);
        break;
    }

    if (animated && currentCount > 0) {
      badge = TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 300),
        tween: Tween(begin: 0.8, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: badge,
      );
    }

    if (onTap != null) {
      badge = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: badge,
      );
    }

    return badge;
  }

  Widget _buildStandardBadge({
    required Color backgroundColor,
    required Color textColor,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: textColor,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            '$currentCount/$maxCount',
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactBadge({
    required Color backgroundColor,
    required Color textColor,
  }) {
    return AppBadgeAtom.count(
      current: currentCount,
      max: maxCount,
      backgroundColor: backgroundColor,
      textColor: textColor,
      showWarning: currentCount >= maxCount,
    );
  }

  Widget _buildDetailedBadge({
    required Color backgroundColor,
    required Color textColor,
    required ColorScheme colorScheme,
    IconData? icon,
  }) {
    final slotsRemaining = maxCount - currentCount;
    final percentage = (currentCount / maxCount * 100).round();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: backgroundColor,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 18,
                  color: textColor,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                'Images',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '$currentCount of $maxCount',
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            slotsRemaining > 0
                ? '$slotsRemaining slots left'
                : 'Storage full',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: currentCount / maxCount,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                currentCount >= maxCount
                    ? colorScheme.error
                    : colorScheme.primary,
              ),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinimalBadge({
    required Color textColor,
  }) {
    return Text(
      '$currentCount/$maxCount',
      style: TextStyle(
        color: textColor,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// Enum for badge styles
enum BadgeStyle {
  standard,
  compact,
  detailed,
  minimal,
}

/// A visual indicator showing image slots as dots
class LeadImageSlotsIndicatorAtom extends StatelessWidget {
  final int filledSlots;
  final int totalSlots;
  final double dotSize;
  final double spacing;
  final VoidCallback? onTap;

  const LeadImageSlotsIndicatorAtom({
    super.key,
    required this.filledSlots,
    this.totalSlots = 10,
    this.dotSize = 8,
    this.spacing = 4,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isAtLimit = filledSlots >= totalSlots;

    Widget dots = Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalSlots, (index) {
        final isFilled = index < filledSlots;
        final isLastFilled = index == filledSlots - 1;

        Color dotColor;
        if (isFilled) {
          if (isAtLimit) {
            dotColor = colorScheme.error;
          } else if (filledSlots >= (totalSlots * 0.8)) {
            dotColor = colorScheme.tertiary;
          } else {
            dotColor = colorScheme.primary;
          }
        } else {
          dotColor = colorScheme.surfaceContainerHighest;
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          width: dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
            border: !isFilled
                ? Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                    width: 1,
                  )
                : null,
          ),
        );
      }),
    );

    if (onTap != null) {
      dots = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: dots,
        ),
      );
    }

    return dots;
  }
}

/// A clickable image count chip for navigation
class LeadImageCountChipAtom extends StatelessWidget {
  final int count;
  final VoidCallback? onTap;
  final bool highlighted;

  const LeadImageCountChipAtom({
    super.key,
    required this.count,
    this.onTap,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: highlighted
          ? colorScheme.primaryContainer
          : colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.photo,
                size: 16,
                color: highlighted
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                count.toString(),
                style: TextStyle(
                  color: highlighted
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../atoms/app_badge_atom.dart';
import '../atoms/app_icon_button_atom.dart';

/// A reusable limit indicator molecule for showing "X of Y" format
/// Especially useful for showing image count limits
/// Following atomic design principles - composed from atoms
class AppLimitIndicatorMolecule extends StatelessWidget {
  final int current;
  final int max;
  final String? label;
  final LimitIndicatorStyle style;
  final Color? primaryColor;
  final Color? warningColor;
  final Color? errorColor;
  final VoidCallback? onTap;
  final bool showWarning;
  final double? size;

  const AppLimitIndicatorMolecule({
    super.key,
    required this.current,
    required this.max,
    this.label,
    this.style = LimitIndicatorStyle.badge,
    this.primaryColor,
    this.warningColor,
    this.errorColor,
    this.onTap,
    this.showWarning = true,
    this.size,
  });

  /// Factory constructor for image limit indicator
  factory AppLimitIndicatorMolecule.images({
    Key? key,
    required int current,
    required int max,
    LimitIndicatorStyle style = LimitIndicatorStyle.badge,
    VoidCallback? onTap,
  }) {
    return AppLimitIndicatorMolecule(
      key: key,
      current: current,
      max: max,
      label: 'Images',
      style: style,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case LimitIndicatorStyle.badge:
        return _buildBadgeStyle(context);
      case LimitIndicatorStyle.progress:
        return _buildProgressStyle(context);
      case LimitIndicatorStyle.dots:
        return _buildDotsStyle(context);
      case LimitIndicatorStyle.text:
        return _buildTextStyle(context);
      case LimitIndicatorStyle.compact:
        return _buildCompactStyle(context);
    }
  }

  Widget _buildBadgeStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isAtLimit = current >= max;
    final isNearLimit = current >= (max * 0.8);

    Color backgroundColor;
    if (isAtLimit) {
      backgroundColor = errorColor ?? colorScheme.errorContainer;
    } else if (showWarning && isNearLimit) {
      backgroundColor = warningColor ?? colorScheme.tertiaryContainer;
    } else {
      backgroundColor = primaryColor ?? colorScheme.primaryContainer;
    }

    final badge = AppBadgeAtom.count(
      current: current,
      max: max,
      backgroundColor: backgroundColor,
      showWarning: showWarning && isNearLimit,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: badge,
      );
    }

    return badge;
  }

  Widget _buildProgressStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progress = current / max;
    final isAtLimit = current >= max;
    final isNearLimit = current >= (max * 0.8);

    Color progressColor;
    if (isAtLimit) {
      progressColor = errorColor ?? colorScheme.error;
    } else if (showWarning && isNearLimit) {
      progressColor = warningColor ?? colorScheme.tertiary;
    } else {
      progressColor = primaryColor ?? colorScheme.primary;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '$current / $max',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: progressColor,
                ),
              ),
            ],
          ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            minHeight: 8,
          ),
        ),
        if (isAtLimit) ...[
          const SizedBox(height: 4),
          Text(
            'Limit reached',
            style: theme.textTheme.bodySmall?.copyWith(
              color: errorColor ?? colorScheme.error,
              fontSize: 11,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDotsStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dotSize = size ?? 12.0;

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: List.generate(max, (index) {
        final isFilled = index < current;
        final isLast = index == current - 1;
        final isAtLimit = current >= max;

        Color dotColor;
        if (isFilled) {
          if (isAtLimit) {
            dotColor = errorColor ?? colorScheme.error;
          } else if (showWarning && current >= (max * 0.8)) {
            dotColor = warningColor ?? colorScheme.tertiary;
          } else {
            dotColor = primaryColor ?? colorScheme.primary;
          }
        } else {
          dotColor = colorScheme.surfaceContainerHighest;
        }

        Widget dot = Container(
          width: dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor,
            border: Border.all(
              color: isFilled ? dotColor : colorScheme.outline,
              width: 1,
            ),
          ),
        );

        if (isLast && isFilled && onTap != null) {
          dot = InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(dotSize / 2),
            child: dot,
          );
        }

        return dot;
      }),
    );
  }

  Widget _buildTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAtLimit = current >= max;
    final isNearLimit = current >= (max * 0.8);

    Color textColor;
    if (isAtLimit) {
      textColor = errorColor ?? colorScheme.error;
    } else if (showWarning && isNearLimit) {
      textColor = warningColor ?? colorScheme.tertiary;
    } else {
      textColor = primaryColor ?? colorScheme.onSurface;
    }

    final text = RichText(
      text: TextSpan(
        style: theme.textTheme.bodyMedium,
        children: [
          if (label != null) ...[
            TextSpan(
              text: '$label: ',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ],
          TextSpan(
            text: '$current',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: ' / ',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
          TextSpan(
            text: '$max',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isAtLimit) ...[
            TextSpan(
              text: ' (Full)',
              style: TextStyle(
                color: textColor,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        child: text,
      );
    }

    return text;
  }

  Widget _buildCompactStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAtLimit = current >= max;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isAtLimit
            ? colorScheme.errorContainer
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$current/$max',
        style: theme.textTheme.bodySmall?.copyWith(
          color: isAtLimit ? colorScheme.onErrorContainer : colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

enum LimitIndicatorStyle {
  badge,
  progress,
  dots,
  text,
  compact,
}

/// A limit indicator with action button
class AppLimitIndicatorWithActionMolecule extends StatelessWidget {
  final int current;
  final int max;
  final String label;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;
  final VoidCallback? onManage;
  final bool canAdd;
  final bool canRemove;

  const AppLimitIndicatorWithActionMolecule({
    super.key,
    required this.current,
    required this.max,
    required this.label,
    this.onAdd,
    this.onRemove,
    this.onManage,
    this.canAdd = true,
    this.canRemove = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAtLimit = current >= max;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isAtLimit ? colorScheme.error : colorScheme.outline,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                AppLimitIndicatorMolecule(
                  current: current,
                  max: max,
                  style: LimitIndicatorStyle.progress,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (isAtLimit && onManage != null)
            AppIconButtonAtom(
              icon: Icons.settings,
              onPressed: onManage,
              tooltip: 'Manage $label',
            )
          else ...[
            if (canRemove && current > 0)
              AppIconButtonAtom(
                icon: Icons.remove,
                onPressed: onRemove,
                isDisabled: current <= 0,
              ),
            if (canAdd)
              AppIconButtonAtom(
                icon: Icons.add,
                onPressed: onAdd,
                isDisabled: isAtLimit,
              ),
          ],
        ],
      ),
    );
  }
}

/// A visual slot indicator showing filled and empty slots
class AppSlotIndicatorMolecule extends StatelessWidget {
  final int filled;
  final int total;
  final double slotSize;
  final double spacing;
  final Color? filledColor;
  final Color? emptyColor;
  final Widget? filledWidget;
  final Widget? emptyWidget;
  final bool showNumbers;

  const AppSlotIndicatorMolecule({
    super.key,
    required this.filled,
    required this.total,
    this.slotSize = 24,
    this.spacing = 8,
    this.filledColor,
    this.emptyColor,
    this.filledWidget,
    this.emptyWidget,
    this.showNumbers = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveFilledColor = filledColor ?? colorScheme.primary;
    final effectiveEmptyColor = emptyColor ?? colorScheme.surfaceContainerHighest;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: List.generate(total, (index) {
        final isFilled = index < filled;

        Widget slot;
        if (filledWidget != null && isFilled) {
          slot = filledWidget!;
        } else if (emptyWidget != null && !isFilled) {
          slot = emptyWidget!;
        } else {
          slot = Container(
            width: slotSize,
            height: slotSize,
            decoration: BoxDecoration(
              color: isFilled ? effectiveFilledColor : effectiveEmptyColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: isFilled
                    ? effectiveFilledColor
                    : colorScheme.outline,
                width: 1,
              ),
            ),
            child: showNumbers
                ? Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isFilled
                            ? colorScheme.onPrimary
                            : colorScheme.onSurfaceVariant,
                        fontSize: slotSize * 0.4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : null,
          );
        }

        return slot;
      }),
    );
  }
}
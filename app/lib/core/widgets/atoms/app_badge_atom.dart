import 'package:flutter/material.dart';

/// A reusable badge atom for displaying counts, status indicators, or labels
/// Following atomic design principles - this is the smallest badge component
/// Perfect for showing image count (e.g., "7/10")
class AppBadgeAtom extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Border? border;
  final BadgeShape shape;
  final Widget? icon;
  final bool showDot;

  const AppBadgeAtom({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.padding,
    this.borderRadius,
    this.border,
    this.shape = BadgeShape.standard,
    this.icon,
    this.showDot = false,
  });

  /// Factory constructor for count badges (e.g., "7/10" for image counts)
  factory AppBadgeAtom.count({
    Key? key,
    required int current,
    required int max,
    Color? backgroundColor,
    Color? textColor,
    double? fontSize,
    bool showWarning = false,
  }) {
    return AppBadgeAtom(
      key: key,
      text: '$current/$max',
      backgroundColor: backgroundColor ?? (showWarning && current >= max ? null : null),
      textColor: textColor,
      fontSize: fontSize,
      shape: BadgeShape.rounded,
    );
  }

  /// Factory constructor for simple number badges
  factory AppBadgeAtom.number({
    Key? key,
    required int count,
    Color? backgroundColor,
    Color? textColor,
    double? fontSize,
    int? maxCount,
  }) {
    final displayText = maxCount != null && count > maxCount ? '$maxCount+' : count.toString();
    return AppBadgeAtom(
      key: key,
      text: displayText,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
      shape: BadgeShape.circle,
    );
  }

  /// Factory constructor for status badges
  factory AppBadgeAtom.status({
    Key? key,
    required String status,
    Color? backgroundColor,
    Color? textColor,
    Widget? icon,
  }) {
    return AppBadgeAtom(
      key: key,
      text: status,
      backgroundColor: backgroundColor,
      textColor: textColor,
      shape: BadgeShape.rounded,
      icon: icon,
    );
  }

  /// Factory constructor for dot indicator
  factory AppBadgeAtom.dot({
    Key? key,
    Color? color,
    double size = 8,
  }) {
    return AppBadgeAtom(
      key: key,
      text: '',
      backgroundColor: color,
      shape: BadgeShape.circle,
      showDot: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine colors based on context
    final effectiveBackgroundColor = backgroundColor ??
        (text.contains('/') && _isAtLimit(text)
            ? colorScheme.errorContainer
            : colorScheme.primaryContainer);

    final effectiveTextColor = textColor ??
        (text.contains('/') && _isAtLimit(text)
            ? colorScheme.onErrorContainer
            : colorScheme.onPrimaryContainer);

    if (showDot) {
      return Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          shape: BoxShape.circle,
        ),
      );
    }

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          icon!,
          if (text.isNotEmpty) const SizedBox(width: 4),
        ],
        if (text.isNotEmpty)
          Text(
            text,
            style: TextStyle(
              color: effectiveTextColor,
              fontSize: fontSize ?? 12,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );

    return Container(
      padding: padding ?? _getPadding(),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: _getBorderRadius(),
        border: border,
      ),
      child: content,
    );
  }

  EdgeInsets _getPadding() {
    switch (shape) {
      case BadgeShape.circle:
        return const EdgeInsets.all(6);
      case BadgeShape.rounded:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case BadgeShape.standard:
        return const EdgeInsets.symmetric(horizontal: 6, vertical: 2);
    }
  }

  BorderRadius? _getBorderRadius() {
    if (borderRadius != null) return borderRadius;

    switch (shape) {
      case BadgeShape.circle:
        return BorderRadius.circular(100);
      case BadgeShape.rounded:
        return BorderRadius.circular(12);
      case BadgeShape.standard:
        return BorderRadius.circular(4);
    }
  }

  bool _isAtLimit(String text) {
    if (!text.contains('/')) return false;
    final parts = text.split('/');
    if (parts.length != 2) return false;

    try {
      final current = int.parse(parts[0]);
      final max = int.parse(parts[1]);
      return current >= max;
    } catch (_) {
      return false;
    }
  }
}

enum BadgeShape {
  standard,
  rounded,
  circle,
}

/// A widget that adds a badge to another widget
class AppBadgeWrapperAtom extends StatelessWidget {
  final Widget child;
  final Widget badge;
  final BadgePosition position;
  final Offset? offset;
  final bool showBadge;

  const AppBadgeWrapperAtom({
    super.key,
    required this.child,
    required this.badge,
    this.position = BadgePosition.topRight,
    this.offset,
    this.showBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!showBadge) return child;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: _getTop(),
          right: _getRight(),
          bottom: _getBottom(),
          left: _getLeft(),
          child: badge,
        ),
      ],
    );
  }

  double? _getTop() {
    final dy = offset?.dy ?? 0;
    switch (position) {
      case BadgePosition.topLeft:
      case BadgePosition.topRight:
        return dy;
      default:
        return null;
    }
  }

  double? _getBottom() {
    final dy = offset?.dy ?? 0;
    switch (position) {
      case BadgePosition.bottomLeft:
      case BadgePosition.bottomRight:
        return dy;
      default:
        return null;
    }
  }

  double? _getLeft() {
    final dx = offset?.dx ?? 0;
    switch (position) {
      case BadgePosition.topLeft:
      case BadgePosition.bottomLeft:
        return dx;
      default:
        return null;
    }
  }

  double? _getRight() {
    final dx = offset?.dx ?? 0;
    switch (position) {
      case BadgePosition.topRight:
      case BadgePosition.bottomRight:
        return dx;
      default:
        return null;
    }
  }
}

enum BadgePosition {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}
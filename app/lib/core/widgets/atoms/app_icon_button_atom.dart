import 'package:flutter/material.dart';

/// A reusable icon button atom with consistent styling
/// Following atomic design principles - this is the smallest icon button component
class AppIconButtonAtom extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool isDisabled;
  final bool isLoading;
  final double? size;
  final Color? color;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final ButtonStyle? style;
  final BoxConstraints? constraints;

  const AppIconButtonAtom({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.isDisabled = false,
    this.isLoading = false,
    this.size,
    this.color,
    this.backgroundColor,
    this.padding,
    this.style,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveOnPressed = (isDisabled || isLoading) ? null : onPressed;
    final effectiveColor = color ?? colorScheme.onSurface;
    final effectiveSize = size ?? 24.0;

    Widget iconWidget;
    if (isLoading) {
      iconWidget = SizedBox(
        width: effectiveSize,
        height: effectiveSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
        ),
      );
    } else {
      iconWidget = Icon(
        icon,
        size: effectiveSize,
        color: effectiveOnPressed != null
            ? effectiveColor
            : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
      );
    }

    final defaultStyle = IconButton.styleFrom(
      padding: padding,
      backgroundColor: backgroundColor,
      disabledBackgroundColor: backgroundColor?.withValues(alpha: 0.12),
    );

    final button = IconButton(
      icon: iconWidget,
      onPressed: effectiveOnPressed,
      tooltip: tooltip,
      style: style ?? defaultStyle,
      constraints: constraints ??
          BoxConstraints(
            minWidth: 48,
            minHeight: 48,
          ),
    );

    return button;
  }
}

/// Filled variant of the icon button atom
class AppFilledIconButtonAtom extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool isDisabled;
  final bool isLoading;
  final double? size;
  final Color? iconColor;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;

  const AppFilledIconButtonAtom({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.isDisabled = false,
    this.isLoading = false,
    this.size,
    this.iconColor,
    this.backgroundColor,
    this.padding,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveOnPressed = (isDisabled || isLoading) ? null : onPressed;
    final effectiveIconColor = iconColor ?? colorScheme.onPrimary;
    final effectiveBackgroundColor = backgroundColor ?? colorScheme.primary;
    final effectiveSize = size ?? 24.0;

    Widget iconWidget;
    if (isLoading) {
      iconWidget = SizedBox(
        width: effectiveSize,
        height: effectiveSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(effectiveIconColor),
        ),
      );
    } else {
      iconWidget = Icon(
        icon,
        size: effectiveSize,
        color: effectiveOnPressed != null
            ? effectiveIconColor
            : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
      );
    }

    return IconButton.filled(
      icon: iconWidget,
      onPressed: effectiveOnPressed,
      tooltip: tooltip,
      style: IconButton.styleFrom(
        padding: padding,
        backgroundColor: effectiveBackgroundColor,
        disabledBackgroundColor: colorScheme.surfaceContainerHighest,
      ),
      constraints: constraints ??
          BoxConstraints(
            minWidth: 48,
            minHeight: 48,
          ),
    );
  }
}

/// Outlined variant of the icon button atom
class AppOutlinedIconButtonAtom extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool isDisabled;
  final bool isLoading;
  final double? size;
  final Color? iconColor;
  final Color? borderColor;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;

  const AppOutlinedIconButtonAtom({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.isDisabled = false,
    this.isLoading = false,
    this.size,
    this.iconColor,
    this.borderColor,
    this.padding,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveOnPressed = (isDisabled || isLoading) ? null : onPressed;
    final effectiveIconColor = iconColor ?? colorScheme.onSurface;
    final effectiveBorderColor = borderColor ?? colorScheme.outline;
    final effectiveSize = size ?? 24.0;

    Widget iconWidget;
    if (isLoading) {
      iconWidget = SizedBox(
        width: effectiveSize,
        height: effectiveSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(effectiveIconColor),
        ),
      );
    } else {
      iconWidget = Icon(
        icon,
        size: effectiveSize,
        color: effectiveOnPressed != null
            ? effectiveIconColor
            : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
      );
    }

    return IconButton.outlined(
      icon: iconWidget,
      onPressed: effectiveOnPressed,
      tooltip: tooltip,
      style: IconButton.styleFrom(
        padding: padding,
        side: BorderSide(
          color: effectiveOnPressed != null
              ? effectiveBorderColor
              : colorScheme.outline.withValues(alpha: 0.12),
        ),
      ),
      constraints: constraints ??
          BoxConstraints(
            minWidth: 48,
            minHeight: 48,
          ),
    );
  }
}
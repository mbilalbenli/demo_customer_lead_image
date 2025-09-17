import 'package:flutter/material.dart';

/// A reusable button atom that supports various styles and states
/// Following atomic design principles - this is the smallest button component
class AppButtonAtom extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final ButtonStyle? style;
  final Widget? icon;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? borderRadius;
  final String? semanticLabel;
  final String? tooltip;

  const AppButtonAtom({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.style,
    this.icon,
    this.padding,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.semanticLabel,
    this.tooltip,
  });

  /// Primary button factory
  factory AppButtonAtom.primary({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? semanticLabel,
    String? tooltip,
  }) {
    return AppButtonAtom(
      key: key,
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon != null ? Icon(icon, size: 18) : null,
    );
  }

  /// Secondary button factory
  factory AppButtonAtom.secondary({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
  }) {
    return AppButtonAtom(
      key: key,
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon != null ? Icon(icon, size: 18) : null,
      backgroundColor: Colors.transparent,
      style: OutlinedButton.styleFrom().copyWith(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }

  /// Danger button factory
  factory AppButtonAtom.danger({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
  }) {
    return AppButtonAtom(
      key: key,
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon != null ? Icon(icon, size: 18) : null,
      backgroundColor: Colors.red.shade600,
      foregroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveOnPressed = (isDisabled || isLoading) ? null : onPressed;

    final defaultStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? colorScheme.primary,
      foregroundColor: foregroundColor ?? colorScheme.onPrimary,
      disabledBackgroundColor: colorScheme.surfaceContainerHighest,
      disabledForegroundColor: colorScheme.onSurfaceVariant,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
      ),
    );

    final buttonContent = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                foregroundColor ?? colorScheme.onPrimary,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    final button = ElevatedButton(
      onPressed: effectiveOnPressed,
      style: style ?? defaultStyle,
      child: buttonContent,
    );

    if (width != null || height != null) {
      return SizedBox(
        width: width,
        height: height,
        child: button,
      );
    }

    return button;
  }
}

/// Outlined variant of the button atom
class AppOutlinedButtonAtom extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final ButtonStyle? style;
  final Widget? icon;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final Color? borderColor;
  final Color? foregroundColor;
  final double? borderRadius;

  const AppOutlinedButtonAtom({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.style,
    this.icon,
    this.padding,
    this.width,
    this.height,
    this.borderColor,
    this.foregroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveOnPressed = (isDisabled || isLoading) ? null : onPressed;

    final defaultStyle = OutlinedButton.styleFrom(
      foregroundColor: foregroundColor ?? colorScheme.primary,
      side: BorderSide(
        color: borderColor ?? colorScheme.outline,
        width: 1,
      ),
      disabledForegroundColor: colorScheme.onSurfaceVariant,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
      ),
    );

    final buttonContent = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                foregroundColor ?? colorScheme.primary,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    final button = OutlinedButton(
      onPressed: effectiveOnPressed,
      style: style ?? defaultStyle,
      child: buttonContent,
    );

    if (width != null || height != null) {
      return SizedBox(
        width: width,
        height: height,
        child: button,
      );
    }

    return button;
  }
}

/// Text variant of the button atom
class AppTextButtonAtom extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final ButtonStyle? style;
  final Widget? icon;
  final EdgeInsets? padding;
  final Color? foregroundColor;

  const AppTextButtonAtom({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.style,
    this.icon,
    this.padding,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveOnPressed = (isDisabled || isLoading) ? null : onPressed;

    final defaultStyle = TextButton.styleFrom(
      foregroundColor: foregroundColor ?? colorScheme.primary,
      disabledForegroundColor: colorScheme.onSurfaceVariant,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );

    final buttonContent = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                foregroundColor ?? colorScheme.primary,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Text(text),
            ],
          );

    return TextButton(
      onPressed: effectiveOnPressed,
      style: style ?? defaultStyle,
      child: buttonContent,
    );
  }
}
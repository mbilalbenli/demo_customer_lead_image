import 'package:flutter/material.dart';
import '../atoms/app_button_atom.dart';
import '../atoms/app_icon_button_atom.dart';

/// A reusable error message molecule for displaying error states
/// Following atomic design principles - composed from atoms
class AppErrorMessageMolecule extends StatelessWidget {
  final String error;
  final String? details;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;
  final ErrorType type;
  final bool showIcon;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderRadius? borderRadius;

  const AppErrorMessageMolecule({
    super.key,
    required this.error,
    this.details,
    this.onRetry,
    this.onDismiss,
    this.type = ErrorType.error,
    this.showIcon = true,
    this.padding,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
  });

  /// Factory constructor for connection error
  factory AppErrorMessageMolecule.connection({
    Key? key,
    String? message,
    VoidCallback? onRetry,
  }) {
    return AppErrorMessageMolecule(
      key: key,
      error: message ?? 'Connection error',
      details: 'Please check your internet connection and try again.',
      onRetry: onRetry,
      type: ErrorType.warning,
    );
  }

  /// Factory constructor for validation error
  factory AppErrorMessageMolecule.validation({
    Key? key,
    required String message,
    String? details,
    VoidCallback? onDismiss,
  }) {
    return AppErrorMessageMolecule(
      key: key,
      error: message,
      details: details,
      onDismiss: onDismiss,
      type: ErrorType.warning,
    );
  }

  /// Factory constructor for critical error
  factory AppErrorMessageMolecule.critical({
    Key? key,
    required String message,
    String? details,
    VoidCallback? onRetry,
  }) {
    return AppErrorMessageMolecule(
      key: key,
      error: message,
      details: details,
      onRetry: onRetry,
      type: ErrorType.critical,
    );
  }

  /// Factory constructor for image limit error (specific to this project)
  factory AppErrorMessageMolecule.imageLimit({
    Key? key,
    required int currentCount,
    required int maxCount,
    VoidCallback? onManageImages,
  }) {
    return AppErrorMessageMolecule(
      key: key,
      error: 'Cannot add more images',
      details: 'You have reached the maximum of $maxCount images. Delete some images to add new ones.',
      onRetry: onManageImages,
      type: ErrorType.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final colors = _getColors(colorScheme);
    final icon = _getIcon();

    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.background,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        border: Border.all(
          color: colors.border,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showIcon) ...[
                Icon(
                  icon,
                  color: colors.icon,
                  size: 24,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      error,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: textColor ?? colors.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (details != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        details!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: (textColor ?? colors.text).withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onDismiss != null)
                AppIconButtonAtom(
                  icon: Icons.close,
                  onPressed: onDismiss,
                  size: 20,
                  color: colors.icon,
                ),
            ],
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            AppTextButtonAtom(
              text: _getRetryText(),
              onPressed: onRetry,
              icon: Icon(
                Icons.refresh,
                size: 18,
              ),
              foregroundColor: colors.icon,
            ),
          ],
        ],
      ),
    );
  }

  String _getRetryText() {
    switch (type) {
      case ErrorType.info:
        return 'Manage';
      case ErrorType.warning:
      case ErrorType.error:
      case ErrorType.critical:
        return 'Retry';
    }
  }

  IconData _getIcon() {
    switch (type) {
      case ErrorType.info:
        return Icons.info_outline;
      case ErrorType.warning:
        return Icons.warning_amber_outlined;
      case ErrorType.error:
        return Icons.error_outline;
      case ErrorType.critical:
        return Icons.dangerous_outlined;
    }
  }

  _ErrorColors _getColors(ColorScheme colorScheme) {
    switch (type) {
      case ErrorType.info:
        return _ErrorColors(
          background: colorScheme.primaryContainer,
          border: colorScheme.primary.withValues(alpha: 0.3),
          icon: colorScheme.primary,
          text: colorScheme.onPrimaryContainer,
        );
      case ErrorType.warning:
        return _ErrorColors(
          background: colorScheme.tertiaryContainer,
          border: colorScheme.tertiary.withValues(alpha: 0.3),
          icon: colorScheme.tertiary,
          text: colorScheme.onTertiaryContainer,
        );
      case ErrorType.error:
        return _ErrorColors(
          background: colorScheme.errorContainer,
          border: colorScheme.error.withValues(alpha: 0.3),
          icon: colorScheme.error,
          text: colorScheme.onErrorContainer,
        );
      case ErrorType.critical:
        return _ErrorColors(
          background: colorScheme.error,
          border: colorScheme.error,
          icon: colorScheme.onError,
          text: colorScheme.onError,
        );
    }
  }
}

enum ErrorType {
  info,
  warning,
  error,
  critical,
}

class _ErrorColors {
  final Color background;
  final Color border;
  final Color icon;
  final Color text;

  const _ErrorColors({
    required this.background,
    required this.border,
    required this.icon,
    required this.text,
  });
}

/// A compact inline error message
class AppInlineErrorMolecule extends StatelessWidget {
  final String message;
  final ErrorType type;
  final VoidCallback? onDismiss;

  const AppInlineErrorMolecule({
    super.key,
    required this.message,
    this.type = ErrorType.error,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color iconColor;
    switch (type) {
      case ErrorType.info:
        iconColor = colorScheme.primary;
        break;
      case ErrorType.warning:
        iconColor = colorScheme.tertiary;
        break;
      case ErrorType.error:
      case ErrorType.critical:
        iconColor = colorScheme.error;
        break;
    }

    return Row(
      children: [
        Icon(
          _getIcon(),
          color: iconColor,
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: theme.textTheme.bodySmall?.copyWith(
              color: iconColor,
            ),
          ),
        ),
        if (onDismiss != null)
          AppIconButtonAtom(
            icon: Icons.close,
            onPressed: onDismiss,
            size: 16,
            color: iconColor,
          ),
      ],
    );
  }

  IconData _getIcon() {
    switch (type) {
      case ErrorType.info:
        return Icons.info_outline;
      case ErrorType.warning:
        return Icons.warning_amber_outlined;
      case ErrorType.error:
        return Icons.error_outline;
      case ErrorType.critical:
        return Icons.dangerous_outlined;
    }
  }
}

/// A toast-style error message
class AppErrorToastMolecule extends StatelessWidget {
  final String message;
  final ErrorType type;
  final VoidCallback? onDismiss;
  final Duration? duration;

  const AppErrorToastMolecule({
    super.key,
    required this.message,
    this.type = ErrorType.error,
    this.onDismiss,
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final colors = _getColors(colorScheme);

    return Material(
      color: colors.background,
      borderRadius: BorderRadius.circular(8),
      elevation: 4,
      child: InkWell(
        onTap: onDismiss,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                _getIcon(),
                color: colors.icon,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.text,
                  ),
                ),
              ),
              if (onDismiss != null) ...[
                const SizedBox(width: 12),
                Icon(
                  Icons.close,
                  color: colors.icon,
                  size: 20,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (type) {
      case ErrorType.info:
        return Icons.info_outline;
      case ErrorType.warning:
        return Icons.warning_amber_outlined;
      case ErrorType.error:
        return Icons.error_outline;
      case ErrorType.critical:
        return Icons.dangerous_outlined;
    }
  }

  _ErrorColors _getColors(ColorScheme colorScheme) {
    switch (type) {
      case ErrorType.info:
        return _ErrorColors(
          background: colorScheme.primaryContainer,
          border: colorScheme.primary.withValues(alpha: 0.3),
          icon: colorScheme.primary,
          text: colorScheme.onPrimaryContainer,
        );
      case ErrorType.warning:
        return _ErrorColors(
          background: colorScheme.tertiaryContainer,
          border: colorScheme.tertiary.withValues(alpha: 0.3),
          icon: colorScheme.tertiary,
          text: colorScheme.onTertiaryContainer,
        );
      case ErrorType.error:
        return _ErrorColors(
          background: colorScheme.errorContainer,
          border: colorScheme.error.withValues(alpha: 0.3),
          icon: colorScheme.error,
          text: colorScheme.onErrorContainer,
        );
      case ErrorType.critical:
        return _ErrorColors(
          background: colorScheme.error,
          border: colorScheme.error,
          icon: colorScheme.onError,
          text: colorScheme.onError,
        );
    }
  }
}
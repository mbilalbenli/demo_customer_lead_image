import 'package:flutter/material.dart';

/// A feature-specific atom for lead action buttons
/// Following atomic design principles - smallest lead-specific button component
class LeadActionButtonAtom extends StatelessWidget {
  final LeadActionType actionType;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final ButtonSize size;
  final bool showLabel;
  final String? customLabel;
  final Color? color;

  const LeadActionButtonAtom({
    super.key,
    required this.actionType,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.size = ButtonSize.medium,
    this.showLabel = true,
    this.customLabel,
    this.color,
  });

  /// Factory constructor for call action
  factory LeadActionButtonAtom.call({
    Key? key,
    required VoidCallback? onPressed,
    bool isLoading = false,
    ButtonSize size = ButtonSize.medium,
    bool showLabel = true,
  }) {
    return LeadActionButtonAtom(
      key: key,
      actionType: LeadActionType.call,
      onPressed: onPressed,
      isLoading: isLoading,
      size: size,
      showLabel: showLabel,
    );
  }

  /// Factory constructor for email action
  factory LeadActionButtonAtom.email({
    Key? key,
    required VoidCallback? onPressed,
    bool isLoading = false,
    ButtonSize size = ButtonSize.medium,
    bool showLabel = true,
  }) {
    return LeadActionButtonAtom(
      key: key,
      actionType: LeadActionType.email,
      onPressed: onPressed,
      isLoading: isLoading,
      size: size,
      showLabel: showLabel,
    );
  }

  /// Factory constructor for message action
  factory LeadActionButtonAtom.message({
    Key? key,
    required VoidCallback? onPressed,
    bool isLoading = false,
    ButtonSize size = ButtonSize.medium,
    bool showLabel = true,
  }) {
    return LeadActionButtonAtom(
      key: key,
      actionType: LeadActionType.message,
      onPressed: onPressed,
      isLoading: isLoading,
      size: size,
      showLabel: showLabel,
    );
  }

  /// Factory constructor for manage images action (specific to this project)
  factory LeadActionButtonAtom.manageImages({
    Key? key,
    required VoidCallback? onPressed,
    bool isLoading = false,
    ButtonSize size = ButtonSize.medium,
    bool isDisabled = false,
  }) {
    return LeadActionButtonAtom(
      key: key,
      actionType: LeadActionType.manageImages,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      size: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final config = _getActionConfig(actionType, colorScheme);
    final effectiveColor = color ?? config.color;
    final dimensions = _getSizeDimensions(size);

    final effectiveOnPressed = (isDisabled || isLoading) ? null : onPressed;

    if (showLabel) {
      // Full button with label
      return SizedBox(
        height: dimensions.height,
        child: ElevatedButton.icon(
          onPressed: effectiveOnPressed,
          icon: isLoading
              ? SizedBox(
                  width: dimensions.iconSize,
                  height: dimensions.iconSize,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      colorScheme.onPrimary,
                    ),
                  ),
                )
              : Icon(
                  config.icon,
                  size: dimensions.iconSize,
                ),
          label: Text(
            customLabel ?? config.label,
            style: TextStyle(fontSize: dimensions.fontSize),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: effectiveColor,
            foregroundColor: colorScheme.onPrimary,
            disabledBackgroundColor: colorScheme.surfaceContainerHighest,
            disabledForegroundColor: colorScheme.onSurfaceVariant,
            padding: EdgeInsets.symmetric(
              horizontal: dimensions.padding,
              vertical: dimensions.padding / 2,
            ),
          ),
        ),
      );
    } else {
      // Icon-only button
      return IconButton(
        onPressed: effectiveOnPressed,
        icon: isLoading
            ? SizedBox(
                width: dimensions.iconSize,
                height: dimensions.iconSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
                ),
              )
            : Icon(config.icon),
        iconSize: dimensions.iconSize,
        color: effectiveOnPressed != null
            ? effectiveColor
            : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
        tooltip: customLabel ?? config.label,
        constraints: BoxConstraints(
          minWidth: dimensions.height,
          minHeight: dimensions.height,
        ),
      );
    }
  }

  _ActionConfig _getActionConfig(LeadActionType type, ColorScheme colorScheme) {
    switch (type) {
      case LeadActionType.call:
        return _ActionConfig(
          icon: Icons.phone,
          label: 'Call',
          color: Colors.green,
        );
      case LeadActionType.email:
        return _ActionConfig(
          icon: Icons.email,
          label: 'Email',
          color: colorScheme.primary,
        );
      case LeadActionType.message:
        return _ActionConfig(
          icon: Icons.message,
          label: 'Message',
          color: Colors.blue,
        );
      case LeadActionType.schedule:
        return _ActionConfig(
          icon: Icons.calendar_today,
          label: 'Schedule',
          color: Colors.orange,
        );
      case LeadActionType.note:
        return _ActionConfig(
          icon: Icons.note_add,
          label: 'Add Note',
          color: colorScheme.secondary,
        );
      case LeadActionType.edit:
        return _ActionConfig(
          icon: Icons.edit,
          label: 'Edit',
          color: colorScheme.tertiary,
        );
      case LeadActionType.delete:
        return _ActionConfig(
          icon: Icons.delete,
          label: 'Delete',
          color: colorScheme.error,
        );
      case LeadActionType.manageImages:
        return _ActionConfig(
          icon: Icons.photo_library,
          label: 'Manage Images',
          color: Colors.purple,
        );
    }
  }

  _SizeDimensions _getSizeDimensions(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return const _SizeDimensions(
          height: 32,
          iconSize: 16,
          fontSize: 12,
          padding: 8,
        );
      case ButtonSize.medium:
        return const _SizeDimensions(
          height: 40,
          iconSize: 20,
          fontSize: 14,
          padding: 12,
        );
      case ButtonSize.large:
        return const _SizeDimensions(
          height: 48,
          iconSize: 24,
          fontSize: 16,
          padding: 16,
        );
    }
  }
}

/// Enum for lead action types
enum LeadActionType {
  call,
  email,
  message,
  schedule,
  note,
  edit,
  delete,
  manageImages,
}

/// Enum for button sizes
enum ButtonSize {
  small,
  medium,
  large,
}

class _ActionConfig {
  final IconData icon;
  final String label;
  final Color color;

  const _ActionConfig({
    required this.icon,
    required this.label,
    required this.color,
  });
}

class _SizeDimensions {
  final double height;
  final double iconSize;
  final double fontSize;
  final double padding;

  const _SizeDimensions({
    required this.height,
    required this.iconSize,
    required this.fontSize,
    required this.padding,
  });
}

/// A floating action button variant for lead actions
class LeadFloatingActionButtonAtom extends StatelessWidget {
  final LeadActionType actionType;
  final VoidCallback? onPressed;
  final bool isExtended;
  final String? customLabel;

  const LeadFloatingActionButtonAtom({
    super.key,
    required this.actionType,
    required this.onPressed,
    this.isExtended = false,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final config = _getActionConfig(actionType, colorScheme);

    if (isExtended) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        icon: Icon(config.icon),
        label: Text(customLabel ?? config.label),
        backgroundColor: config.color,
      );
    } else {
      return FloatingActionButton(
        onPressed: onPressed,
        tooltip: customLabel ?? config.label,
        backgroundColor: config.color,
        child: Icon(config.icon),
      );
    }
  }

  _ActionConfig _getActionConfig(LeadActionType type, ColorScheme colorScheme) {
    switch (type) {
      case LeadActionType.call:
        return _ActionConfig(
          icon: Icons.phone,
          label: 'Call',
          color: Colors.green,
        );
      case LeadActionType.email:
        return _ActionConfig(
          icon: Icons.email,
          label: 'Email',
          color: colorScheme.primary,
        );
      case LeadActionType.message:
        return _ActionConfig(
          icon: Icons.message,
          label: 'Message',
          color: Colors.blue,
        );
      case LeadActionType.schedule:
        return _ActionConfig(
          icon: Icons.calendar_today,
          label: 'Schedule',
          color: Colors.orange,
        );
      case LeadActionType.note:
        return _ActionConfig(
          icon: Icons.note_add,
          label: 'Add Note',
          color: colorScheme.secondary,
        );
      case LeadActionType.edit:
        return _ActionConfig(
          icon: Icons.edit,
          label: 'Edit',
          color: colorScheme.tertiary,
        );
      case LeadActionType.delete:
        return _ActionConfig(
          icon: Icons.delete,
          label: 'Delete',
          color: colorScheme.error,
        );
      case LeadActionType.manageImages:
        return _ActionConfig(
          icon: Icons.photo_library,
          label: 'Manage Images',
          color: Colors.purple,
        );
    }
  }
}
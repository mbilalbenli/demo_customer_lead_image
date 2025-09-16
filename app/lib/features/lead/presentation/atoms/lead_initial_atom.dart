import 'package:flutter/material.dart';

/// A feature-specific atom for displaying lead initials
/// Following atomic design principles - smallest lead-specific component for initials
class LeadInitialAtom extends StatelessWidget {
  final String name;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;
  final FontWeight? fontWeight;
  final VoidCallback? onTap;
  final bool showBorder;

  const LeadInitialAtom({
    super.key,
    required this.name,
    this.size = 40,
    this.backgroundColor,
    this.textColor,
    this.fontWeight,
    this.onTap,
    this.showBorder = false,
  });

  /// Factory constructor for small variant
  factory LeadInitialAtom.small({
    Key? key,
    required String name,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return LeadInitialAtom(
      key: key,
      name: name,
      size: 24,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }

  /// Factory constructor for large variant
  factory LeadInitialAtom.large({
    Key? key,
    required String name,
    Color? backgroundColor,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return LeadInitialAtom(
      key: key,
      name: name,
      size: 64,
      backgroundColor: backgroundColor,
      textColor: textColor,
      onTap: onTap,
      showBorder: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final initials = _getInitials(name);
    final bgColor = backgroundColor ?? _generateColorFromName(name, colorScheme);
    final fgColor = textColor ?? _getContrastingColor(bgColor);

    Widget avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(
                color: colorScheme.outline.withValues(alpha: 0.2),
                width: 2,
              )
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: fgColor,
          fontSize: size * 0.4,
          fontWeight: fontWeight ?? FontWeight.bold,
        ),
      ),
    );

    if (onTap != null) {
      avatar = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size / 2),
        child: avatar,
      );
    }

    return avatar;
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';

    final words = name.trim().split(RegExp(r'\s+'));
    if (words.length >= 2) {
      // Take first letter of first and last word
      return '${words.first[0]}${words.last[0]}'.toUpperCase();
    } else if (words.first.length >= 2) {
      // Take first two letters of single word
      return words.first.substring(0, 2).toUpperCase();
    } else {
      // Take whatever we have
      return words.first[0].toUpperCase();
    }
  }

  Color _generateColorFromName(String name, ColorScheme colorScheme) {
    // Generate a consistent color based on the name
    final hash = name.hashCode;
    final colors = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      colorScheme.primaryContainer,
      colorScheme.secondaryContainer,
      colorScheme.tertiaryContainer,
    ];
    return colors[hash.abs() % colors.length];
  }

  Color _getContrastingColor(Color backgroundColor) {
    // Calculate luminance and return appropriate contrasting color
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }
}

/// A lead initial atom with status indicator
class LeadInitialWithStatusAtom extends StatelessWidget {
  final String name;
  final double size;
  final Color? statusColor;
  final bool isOnline;
  final VoidCallback? onTap;

  const LeadInitialWithStatusAtom({
    super.key,
    required this.name,
    this.size = 40,
    this.statusColor,
    this.isOnline = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        LeadInitialAtom(
          name: name,
          size: size,
          onTap: onTap,
        ),
        if (statusColor != null || isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.3,
              height: size * 0.3,
              decoration: BoxDecoration(
                color: statusColor ?? (isOnline ? Colors.green : Colors.grey),
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.surface,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
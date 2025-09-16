import 'package:flutter/material.dart';

/// A feature-specific atom for displaying lead information text
/// Following atomic design principles - smallest lead-specific text component
class LeadInfoTextAtom extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final CrossAxisAlignment alignment;
  final bool copyable;
  final VoidCallback? onTap;

  const LeadInfoTextAtom({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.labelStyle,
    this.valueStyle,
    this.alignment = CrossAxisAlignment.start,
    this.copyable = false,
    this.onTap,
  });

  /// Factory constructor for email info
  factory LeadInfoTextAtom.email({
    Key? key,
    required String email,
    VoidCallback? onTap,
  }) {
    return LeadInfoTextAtom(
      key: key,
      label: 'Email',
      value: email,
      icon: Icons.email_outlined,
      copyable: true,
      onTap: onTap,
    );
  }

  /// Factory constructor for phone info
  factory LeadInfoTextAtom.phone({
    Key? key,
    required String phone,
    VoidCallback? onTap,
  }) {
    return LeadInfoTextAtom(
      key: key,
      label: 'Phone',
      value: phone,
      icon: Icons.phone_outlined,
      copyable: true,
      onTap: onTap,
    );
  }

  /// Factory constructor for address info
  factory LeadInfoTextAtom.address({
    Key? key,
    required String address,
    VoidCallback? onTap,
  }) {
    return LeadInfoTextAtom(
      key: key,
      label: 'Address',
      value: address,
      icon: Icons.location_on_outlined,
      onTap: onTap,
    );
  }

  /// Factory constructor for company info
  factory LeadInfoTextAtom.company({
    Key? key,
    required String company,
    VoidCallback? onTap,
  }) {
    return LeadInfoTextAtom(
      key: key,
      label: 'Company',
      value: company,
      icon: Icons.business_outlined,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final defaultLabelStyle = labelStyle ??
        TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        );

    final defaultValueStyle = valueStyle ??
        TextStyle(
          color: colorScheme.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        );

    Widget content = Column(
      crossAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: defaultLabelStyle,
            ),
          ],
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                value,
                style: defaultValueStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            if (copyable) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.copy_outlined,
                size: 14,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ],
          ],
        ),
      ],
    );

    if (onTap != null || copyable) {
      content = InkWell(
        onTap: () {
          if (copyable) {
            // In a real app, you would copy to clipboard here
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Copied: $value'),
                duration: const Duration(seconds: 1),
              ),
            );
          }
          onTap?.call();
        },
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: content,
        ),
      );
    }

    return content;
  }
}

/// A horizontal variant of the lead info text
class LeadInfoTextHorizontalAtom extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final double? spacing;
  final bool highlightValue;

  const LeadInfoTextHorizontalAtom({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.labelStyle,
    this.valueStyle,
    this.spacing,
    this.highlightValue = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final defaultLabelStyle = labelStyle ??
        TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 14,
        );

    final defaultValueStyle = valueStyle ??
        TextStyle(
          color: highlightValue ? colorScheme.primary : colorScheme.onSurface,
          fontSize: 14,
          fontWeight: highlightValue ? FontWeight.bold : FontWeight.normal,
        );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 18,
            color: colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: spacing ?? 4),
        ],
        Text(
          '$label: ',
          style: defaultLabelStyle,
        ),
        Flexible(
          child: Text(
            value,
            style: defaultValueStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// A compact info badge for lead information
class LeadInfoBadgeAtom extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsets? padding;

  const LeadInfoBadgeAtom({
    super.key,
    required this.text,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 14,
              color: textColor ?? colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor ?? colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
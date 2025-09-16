import 'package:flutter/material.dart';
import '../atoms/app_avatar_atom.dart';
import '../atoms/app_badge_atom.dart';
import '../atoms/app_icon_button_atom.dart';

/// A reusable list tile molecule composed of various atoms
/// Following atomic design principles - composed from atoms
class AppListTileMolecule extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? description;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enabled;
  final bool selected;
  final Color? tileColor;
  final Color? selectedColor;
  final EdgeInsets? contentPadding;
  final bool dense;
  final ShapeBorder? shape;
  final ListTileStyle? style;

  const AppListTileMolecule({
    super.key,
    required this.title,
    this.subtitle,
    this.description,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.selected = false,
    this.tileColor,
    this.selectedColor,
    this.contentPadding,
    this.dense = false,
    this.shape,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget? subtitleWidget;
    if (subtitle != null || description != null) {
      subtitleWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (subtitle != null)
            Text(
              subtitle!,
              style: TextStyle(
                color: enabled
                    ? colorScheme.onSurfaceVariant
                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
                fontSize: 14,
              ),
            ),
          if (description != null) ...[
            const SizedBox(height: 2),
            Text(
              description!,
              style: TextStyle(
                color: enabled
                    ? colorScheme.onSurfaceVariant.withValues(alpha: 0.8)
                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      );
    }

    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: enabled
              ? colorScheme.onSurface
              : colorScheme.onSurface.withValues(alpha: 0.38),
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: subtitleWidget,
      leading: leading,
      trailing: trailing,
      onTap: enabled ? onTap : null,
      onLongPress: enabled ? onLongPress : null,
      enabled: enabled,
      selected: selected,
      tileColor: tileColor,
      selectedColor: selectedColor ?? colorScheme.primaryContainer,
      contentPadding: contentPadding,
      dense: dense,
      shape: shape,
      style: style,
    );
  }
}

/// A list tile with an avatar as leading widget
class AppAvatarListTileMolecule extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? avatarText;
  final String? avatarImageUrl;
  final IconData? avatarIcon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;

  const AppAvatarListTileMolecule({
    super.key,
    required this.title,
    this.subtitle,
    this.avatarText,
    this.avatarImageUrl,
    this.avatarIcon,
    this.trailing,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppListTileMolecule(
      title: title,
      subtitle: subtitle,
      leading: AppAvatarAtom(
        text: avatarText,
        imageUrl: avatarImageUrl,
        icon: avatarIcon ?? (avatarText == null ? Icons.person : null),
        size: 40,
      ),
      trailing: trailing,
      onTap: onTap,
      enabled: enabled,
    );
  }
}

/// A list tile with badge support
class AppBadgeListTileMolecule extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final String? badgeText;
  final int? badgeCount;
  final BadgeShape? badgeShape;
  final Color? badgeColor;
  final VoidCallback? onTap;
  final bool enabled;
  final Widget? additionalTrailing;

  const AppBadgeListTileMolecule({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.badgeText,
    this.badgeCount,
    this.badgeShape,
    this.badgeColor,
    this.onTap,
    this.enabled = true,
    this.additionalTrailing,
  });

  @override
  Widget build(BuildContext context) {
    Widget? trailing;

    if (badgeText != null || badgeCount != null) {
      Widget badge;
      if (badgeCount != null) {
        badge = AppBadgeAtom.number(
          count: badgeCount!,
          backgroundColor: badgeColor,
        );
      } else {
        badge = AppBadgeAtom(
          text: badgeText!,
          backgroundColor: badgeColor,
          shape: badgeShape ?? BadgeShape.rounded,
        );
      }

      if (additionalTrailing != null) {
        trailing = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            badge,
            const SizedBox(width: 8),
            additionalTrailing!,
          ],
        );
      } else {
        trailing = badge;
      }
    } else {
      trailing = additionalTrailing;
    }

    return AppListTileMolecule(
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
      enabled: enabled,
    );
  }
}

/// A list tile with action buttons
class AppActionListTileMolecule extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<ActionItem> actions;
  final VoidCallback? onTap;
  final bool enabled;

  const AppActionListTileMolecule({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    required this.actions,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppListTileMolecule(
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: actions.map((action) {
          return AppIconButtonAtom(
            icon: action.icon,
            onPressed: enabled ? action.onPressed : null,
            tooltip: action.tooltip,
            size: 20,
          );
        }).toList(),
      ),
      onTap: onTap,
      enabled: enabled,
    );
  }
}

class ActionItem {
  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;

  const ActionItem({
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });
}

/// A selectable list tile with checkbox or radio button
class AppSelectableListTileMolecule extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool selected;
  final ValueChanged<bool?>? onChanged;
  final SelectionType selectionType;
  final Widget? secondary;
  final bool enabled;

  const AppSelectableListTileMolecule({
    super.key,
    required this.title,
    this.subtitle,
    required this.selected,
    this.onChanged,
    this.selectionType = SelectionType.checkbox,
    this.secondary,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget control;
    switch (selectionType) {
      case SelectionType.checkbox:
        control = Checkbox(
          value: selected,
          onChanged: enabled ? onChanged : null,
        );
        break;
      case SelectionType.radio:
        // Using simplified approach for radio button visual
        control = Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline,
              width: 2,
            ),
          ),
          child: selected
              ? Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )
              : null,
        );
        break;
      case SelectionType.switch_:
        control = Switch(
          value: selected,
          onChanged: enabled ? onChanged : null,
        );
        break;
    }

    return AppListTileMolecule(
      title: title,
      subtitle: subtitle,
      leading: selectionType == SelectionType.switch_ ? secondary : control,
      trailing: selectionType == SelectionType.switch_ ? control : null,
      onTap: enabled
          ? () => onChanged?.call(!selected)
          : null,
      enabled: enabled,
    );
  }
}

enum SelectionType {
  checkbox,
  radio,
  switch_,
}
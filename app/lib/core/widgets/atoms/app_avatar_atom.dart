import 'package:flutter/material.dart';

/// A reusable avatar atom for displaying user or entity avatars
/// Following atomic design principles - this is the smallest avatar component
class AppAvatarAtom extends StatelessWidget {
  final String? imageUrl;
  final String? text;
  final IconData? icon;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onTap;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final Widget? badge;

  const AppAvatarAtom({
    super.key,
    this.imageUrl,
    this.text,
    this.icon,
    this.size = 40,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
    this.border,
    this.boxShadow,
    this.badge,
  }) : assert(
          imageUrl != null || text != null || icon != null,
          'At least one of imageUrl, text, or icon must be provided',
        );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveBackgroundColor = backgroundColor ?? colorScheme.primaryContainer;
    final effectiveForegroundColor = foregroundColor ?? colorScheme.onPrimaryContainer;

    Widget avatarContent;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      // Image avatar
      avatarContent = _ImageAvatar(
        imageUrl: imageUrl!,
        size: size,
      );
    } else if (text != null && text!.isNotEmpty) {
      // Text avatar
      avatarContent = _TextAvatar(
        text: text!,
        size: size,
        backgroundColor: effectiveBackgroundColor,
        foregroundColor: effectiveForegroundColor,
      );
    } else if (icon != null) {
      // Icon avatar
      avatarContent = _IconAvatar(
        icon: icon!,
        size: size,
        backgroundColor: effectiveBackgroundColor,
        foregroundColor: effectiveForegroundColor,
      );
    } else {
      // Fallback avatar
      avatarContent = _IconAvatar(
        icon: Icons.person,
        size: size,
        backgroundColor: effectiveBackgroundColor,
        foregroundColor: effectiveForegroundColor,
      );
    }

    // Apply decoration
    avatarContent = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: border,
        boxShadow: boxShadow,
      ),
      child: ClipOval(
        child: avatarContent,
      ),
    );

    // Add badge if provided
    if (badge != null) {
      avatarContent = Stack(
        children: [
          avatarContent,
          Positioned(
            right: 0,
            bottom: 0,
            child: badge!,
          ),
        ],
      );
    }

    // Add tap handler if provided
    if (onTap != null) {
      avatarContent = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size / 2),
        child: avatarContent,
      );
    }

    return avatarContent;
  }
}

class _ImageAvatar extends StatelessWidget {
  final String imageUrl;
  final double size;

  const _ImageAvatar({
    required this.imageUrl,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // For now, using a placeholder since we don't have network images
    // In a real app, you would use CachedNetworkImage or Image.network
    return Container(
      width: size,
      height: size,
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.image,
        size: size * 0.5,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _TextAvatar extends StatelessWidget {
  final String text;
  final double size;
  final Color backgroundColor;
  final Color foregroundColor;

  const _TextAvatar({
    required this.text,
    required this.size,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  String _getInitials(String text) {
    final words = text.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (words[0].isNotEmpty) {
      return words[0].substring(0, text.length >= 2 ? 2 : 1).toUpperCase();
    }
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: backgroundColor,
      alignment: Alignment.center,
      child: Text(
        _getInitials(text),
        style: TextStyle(
          color: foregroundColor,
          fontSize: size * 0.4,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _IconAvatar extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color backgroundColor;
  final Color foregroundColor;

  const _IconAvatar({
    required this.icon,
    required this.size,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: backgroundColor,
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: size * 0.6,
        color: foregroundColor,
      ),
    );
  }
}

/// A group of avatars overlapping each other
class AppAvatarGroupAtom extends StatelessWidget {
  final List<Widget> avatars;
  final double size;
  final double overlap;
  final int maxDisplay;
  final Color? overflowBackgroundColor;
  final Color? overflowTextColor;

  const AppAvatarGroupAtom({
    super.key,
    required this.avatars,
    this.size = 40,
    this.overlap = 0.3,
    this.maxDisplay = 3,
    this.overflowBackgroundColor,
    this.overflowTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final displayAvatars = avatars.take(maxDisplay).toList();
    final overflowCount = avatars.length - maxDisplay;

    return SizedBox(
      height: size,
      child: Stack(
        children: [
          ...displayAvatars.asMap().entries.map((entry) {
            final index = entry.key;
            final avatar = entry.value;
            return Positioned(
              left: index * size * (1 - overlap),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.surface,
                    width: 2,
                  ),
                ),
                child: avatar,
              ),
            );
          }),
          if (overflowCount > 0)
            Positioned(
              left: displayAvatars.length * size * (1 - overlap),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: overflowBackgroundColor ?? colorScheme.surfaceContainerHighest,
                  border: Border.all(
                    color: colorScheme.surface,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '+$overflowCount',
                  style: TextStyle(
                    color: overflowTextColor ?? colorScheme.onSurfaceVariant,
                    fontSize: size * 0.35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
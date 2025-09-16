import 'package:flutter/material.dart';

/// An atom for camera capture button that respects image limit
/// Automatically disabled when limit is reached
/// Following atomic design principles - smallest UI component
class CameraButtonAtom extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isAtLimit;
  final String? limitMessage;
  final ButtonStyle style;
  final double? size;
  final bool showLabel;
  final String? label;

  const CameraButtonAtom({
    super.key,
    required this.onPressed,
    this.isAtLimit = false,
    this.limitMessage,
    this.style = ButtonStyle.filled,
    this.size,
    this.showLabel = true,
    this.label,
  });

  /// Factory for icon-only camera button
  factory CameraButtonAtom.icon({
    Key? key,
    required VoidCallback? onPressed,
    bool isAtLimit = false,
    double? size,
  }) {
    return CameraButtonAtom(
      key: key,
      onPressed: onPressed,
      isAtLimit: isAtLimit,
      style: ButtonStyle.icon,
      size: size,
      showLabel: false,
    );
  }

  /// Factory for floating action button style
  factory CameraButtonAtom.fab({
    Key? key,
    required VoidCallback? onPressed,
    bool isAtLimit = false,
    String? limitMessage,
  }) {
    return CameraButtonAtom(
      key: key,
      onPressed: onPressed,
      isAtLimit: isAtLimit,
      limitMessage: limitMessage,
      style: ButtonStyle.fab,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case ButtonStyle.filled:
        return _buildFilledButton(context);
      case ButtonStyle.outlined:
        return _buildOutlinedButton(context);
      case ButtonStyle.icon:
        return _buildIconButton(context);
      case ButtonStyle.fab:
        return _buildFab(context);
    }
  }

  Widget _buildFilledButton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveLabel = label ?? 'Take Photo';

    return Tooltip(
      message: isAtLimit
          ? limitMessage ?? 'Image limit reached. Delete an image to add more.'
          : effectiveLabel,
      child: FilledButton.icon(
        onPressed: isAtLimit ? null : onPressed,
        icon: Icon(
          Icons.camera_alt,
          size: size ?? 20,
        ),
        label: showLabel
            ? Text(
                isAtLimit ? 'Limit Reached' : effectiveLabel,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              )
            : const SizedBox.shrink(),
        style: FilledButton.styleFrom(
          backgroundColor: isAtLimit ? colorScheme.surfaceContainerHighest : null,
          foregroundColor: isAtLimit ? colorScheme.onSurfaceVariant : null,
        ),
      ),
    );
  }

  Widget _buildOutlinedButton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveLabel = label ?? 'Take Photo';

    return Tooltip(
      message: isAtLimit
          ? limitMessage ?? 'Image limit reached. Delete an image to add more.'
          : effectiveLabel,
      child: OutlinedButton.icon(
        onPressed: isAtLimit ? null : onPressed,
        icon: Icon(
          Icons.camera_alt_outlined,
          size: size ?? 20,
        ),
        label: showLabel
            ? Text(
                isAtLimit ? 'Limit Reached' : effectiveLabel,
              )
            : const SizedBox.shrink(),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isAtLimit
                ? colorScheme.outline.withValues(alpha: 0.3)
                : colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: isAtLimit
          ? limitMessage ?? 'Image limit reached. Delete an image to add more.'
          : 'Take Photo',
      child: IconButton(
        onPressed: isAtLimit ? null : onPressed,
        icon: Icon(
          Icons.camera_alt,
          size: size ?? 24,
        ),
        color: isAtLimit ? colorScheme.onSurfaceVariant : colorScheme.primary,
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isAtLimit) {
      return Tooltip(
        message: limitMessage ?? 'Image limit reached. Delete an image to add more.',
        child: FloatingActionButton(
          onPressed: null,
          backgroundColor: colorScheme.surfaceContainerHighest,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                size: 20,
              ),
              const SizedBox(height: 2),
              Text(
                'FULL',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: 'Take Photo',
      child: Icon(
        Icons.camera_alt,
        size: size ?? 28,
      ),
    );
  }
}

enum ButtonStyle {
  filled,
  outlined,
  icon,
  fab,
}

/// A specialized camera options button
class CameraOptionsButtonAtom extends StatelessWidget {
  final VoidCallback? onCamera;
  final VoidCallback? onGallery;
  final bool isAtLimit;
  final String? cameraLabel;
  final String? galleryLabel;

  const CameraOptionsButtonAtom({
    super.key,
    required this.onCamera,
    required this.onGallery,
    this.isAtLimit = false,
    this.cameraLabel,
    this.galleryLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopupMenuButton<ImageSource>(
      enabled: !isAtLimit,
      onSelected: (source) {
        if (source == ImageSource.camera) {
          onCamera?.call();
        } else {
          onGallery?.call();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: ImageSource.camera,
          child: ListTile(
            leading: Icon(
              Icons.camera_alt,
              color: colorScheme.primary,
            ),
            title: Text(cameraLabel ?? 'Take Photo'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuItem(
          value: ImageSource.gallery,
          child: ListTile(
            leading: Icon(
              Icons.photo_library,
              color: colorScheme.primary,
            ),
            title: Text(galleryLabel ?? 'Choose from Gallery'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isAtLimit
              ? colorScheme.surfaceContainerHighest
              : colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_a_photo,
              size: 20,
              color: isAtLimit
                  ? colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
                  : colorScheme.onPrimaryContainer,
            ),
            const SizedBox(width: 8),
            Text(
              isAtLimit ? 'Limit Reached' : 'Add Image',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isAtLimit
                    ? colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
                    : colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 20,
              color: isAtLimit
                  ? colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
                  : colorScheme.onPrimaryContainer,
            ),
          ],
        ),
      ),
    );
  }
}

enum ImageSource {
  camera,
  gallery,
}
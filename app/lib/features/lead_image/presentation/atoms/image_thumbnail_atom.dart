import 'package:flutter/material.dart';
import '../../../../core/widgets/atoms/app_progress_indicator_atom.dart';

/// An atom for displaying image thumbnails with loading states
/// Following atomic design principles - smallest UI component
class ImageThumbnailAtom extends StatelessWidget {
  final String? base64Image;
  final String? imageUrl;
  final String? assetPath;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool isLoading;
  final bool showDeleteButton;
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final BoxFit fit;
  final int? index;
  final bool selected;

  const ImageThumbnailAtom({
    super.key,
    this.base64Image,
    this.imageUrl,
    this.assetPath,
    this.onTap,
    this.onDelete,
    this.isLoading = false,
    this.showDeleteButton = false,
    this.width = 100,
    this.height = 100,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.index,
    this.selected = false,
  }) : assert(
          base64Image != null || imageUrl != null || assetPath != null || isLoading,
          'Either base64Image, imageUrl, assetPath must be provided, or isLoading must be true',
        );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(8);

    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: effectiveBorderRadius,
            border: Border.all(
              color: selected
                  ? colorScheme.primary
                  : colorScheme.outline.withValues(alpha: 0.2),
              width: selected ? 2 : 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: effectiveBorderRadius,
            child: Material(
              color: colorScheme.surfaceContainerHighest,
              child: InkWell(
                onTap: onTap,
                child: _buildContent(context),
              ),
            ),
          ),
        ),
        if (showDeleteButton && onDelete != null)
          Positioned(
            top: 4,
            right: 4,
            child: Material(
              color: colorScheme.surface.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: onDelete,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: colorScheme.error,
                  ),
                ),
              ),
            ),
          ),
        if (index != null)
          Positioned(
            bottom: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${index! + 1}',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        if (selected)
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                size: 14,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return Center(
        child: AppProgressIndicatorAtom.circular(size: 24),
      );
    }

    if (base64Image != null) {
      return _buildBase64Image();
    }

    if (imageUrl != null) {
      return _buildNetworkImage();
    }

    if (assetPath != null) {
      return Image.asset(
        assetPath!,
        fit: fit,
        errorBuilder: _buildErrorWidget,
      );
    }

    return _buildPlaceholder(context);
  }

  Widget _buildBase64Image() {
    try {
      final imageData = base64Image!.split(',').last;
      return Image.memory(
        Uri.parse('data:image/png;base64,$imageData').data!.contentAsBytes(),
        fit: fit,
        errorBuilder: _buildErrorWidget,
      );
    } catch (e) {
      return _buildErrorWidget(null, e, null);
    }
  }

  Widget _buildNetworkImage() {
    return Image.network(
      imageUrl!,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: AppProgressIndicatorAtom.circular(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
            size: 24,
          ),
        );
      },
      errorBuilder: _buildErrorWidget,
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.image_outlined,
        color: colorScheme.onSurfaceVariant,
        size: 32,
      ),
    );
  }

  Widget _buildErrorWidget(
    BuildContext? context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return Container(
      color: Theme.of(context ?? NavigatorState().context).colorScheme.errorContainer,
      child: Icon(
        Icons.broken_image_outlined,
        color: Theme.of(context ?? NavigatorState().context).colorScheme.onErrorContainer,
        size: 32,
      ),
    );
  }
}
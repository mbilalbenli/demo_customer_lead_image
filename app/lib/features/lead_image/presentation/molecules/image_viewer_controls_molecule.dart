import 'package:flutter/material.dart';

/// A molecule for image viewer controls
/// Following atomic design principles - composed from atoms
class ImageViewerControlsMolecule extends StatelessWidget {
  final bool canGoPrevious;
  final bool canGoNext;
  final bool isZoomed;
  final bool showMetadata;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onToggleMetadata;
  final VoidCallback? onResetZoom;

  const ImageViewerControlsMolecule({
    super.key,
    required this.canGoPrevious,
    required this.canGoNext,
    this.isZoomed = false,
    this.showMetadata = false,
    this.onPrevious,
    this.onNext,
    this.onToggleMetadata,
    this.onResetZoom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button
          IconButton(
            onPressed: canGoPrevious ? onPrevious : null,
            icon: const Icon(Icons.chevron_left),
            color: Colors.white,
            iconSize: 32,
            disabledColor: Colors.white30,
          ),
          // Center controls
          Row(
            children: [
              if (onToggleMetadata != null)
                IconButton(
                  onPressed: onToggleMetadata,
                  icon: Icon(
                    showMetadata ? Icons.info : Icons.info_outline,
                    color: Colors.white,
                  ),
                  tooltip: showMetadata ? 'Hide info' : 'Show info',
                ),
              if (isZoomed && onResetZoom != null) ...[
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: onResetZoom,
                  icon: const Icon(Icons.zoom_out, color: Colors.white),
                  label: Text(
                    'Reset',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
          // Next button
          IconButton(
            onPressed: canGoNext ? onNext : null,
            icon: const Icon(Icons.chevron_right),
            color: Colors.white,
            iconSize: 32,
            disabledColor: Colors.white30,
          ),
        ],
      ),
    );
  }
}
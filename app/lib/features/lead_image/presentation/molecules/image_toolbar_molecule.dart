import 'package:flutter/material.dart';
import '../atoms/image_count_badge_atom.dart';
import '../../../../core/widgets/atoms/app_icon_button_atom.dart';

/// A molecule for image management toolbar
/// Following atomic design principles - composed from atoms
class ImageToolbarMolecule extends StatelessWidget {
  final int selectedCount;
  final int totalCount;
  final int maxCount;
  final VoidCallback? onSelectAll;
  final VoidCallback? onDeselectAll;
  final VoidCallback? onDelete;
  final VoidCallback? onShare;
  final VoidCallback? onDownload;
  final bool selectionMode;

  const ImageToolbarMolecule({
    super.key,
    required this.selectedCount,
    required this.totalCount,
    this.maxCount = 10,
    this.onSelectAll,
    this.onDeselectAll,
    this.onDelete,
    this.onShare,
    this.onDownload,
    this.selectionMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: selectionMode
            ? colorScheme.primaryContainer.withValues(alpha: 0.3)
            : colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          if (selectionMode) ...[
            Checkbox(
              value: selectedCount == totalCount && totalCount > 0,
              onChanged: (_) {
                if (selectedCount == totalCount) {
                  onDeselectAll?.call();
                } else {
                  onSelectAll?.call();
                }
              },
              tristate: selectedCount > 0 && selectedCount < totalCount,
            ),
            Text(
              selectedCount > 0
                  ? '$selectedCount selected'
                  : 'Select items',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ] else ...[
            Icon(
              Icons.photo_library,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Images',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            ImageCountBadgeAtom.minimal(
              count: totalCount,
              maxCount: maxCount,
            ),
          ],
          const Spacer(),
          if (selectionMode && selectedCount > 0) ...[
            AppIconButtonAtom(
              icon: Icons.share,
              onPressed: onShare,
              tooltip: 'Share',
            ),
            AppIconButtonAtom(
              icon: Icons.download,
              onPressed: onDownload,
              tooltip: 'Download',
            ),
            AppIconButtonAtom(
              icon: Icons.delete,
              onPressed: onDelete,
              color: colorScheme.error,
              tooltip: 'Delete',
            ),
          ],
        ],
      ),
    );
  }
}

/// A simplified toolbar for image viewer
class ImageViewerToolbarMolecule extends StatelessWidget {
  final int currentIndex;
  final int totalImages;
  final VoidCallback? onClose;
  final VoidCallback? onDelete;
  final VoidCallback? onShare;
  final VoidCallback? onDownload;
  final VoidCallback? onSetAsMain;
  final bool isMain;

  const ImageViewerToolbarMolecule({
    super.key,
    required this.currentIndex,
    required this.totalImages,
    this.onClose,
    this.onDelete,
    this.onShare,
    this.onDownload,
    this.onSetAsMain,
    this.isMain = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black87,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        'Image ${currentIndex + 1} of $totalImages',
        style: const TextStyle(color: Colors.white),
      ),
      actions: [
        if (!isMain && onSetAsMain != null)
          IconButton(
            icon: const Icon(Icons.star_border),
            onPressed: onSetAsMain,
            tooltip: 'Set as main image',
            color: Colors.white,
          ),
        if (onShare != null)
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: onShare,
            tooltip: 'Share',
            color: Colors.white,
          ),
        if (onDownload != null)
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: onDownload,
            tooltip: 'Download',
            color: Colors.white,
          ),
        if (onDelete != null)
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
            tooltip: 'Delete',
            color: Colors.red,
          ),
      ],
    );
  }
}
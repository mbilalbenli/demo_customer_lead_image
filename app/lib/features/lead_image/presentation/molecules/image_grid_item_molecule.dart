import 'package:flutter/material.dart';
import '../atoms/image_thumbnail_atom.dart';
import '../atoms/image_count_badge_atom.dart';
import '../../../../core/widgets/atoms/app_progress_indicator_atom.dart';

/// A molecule for displaying an image in a grid layout
/// Following atomic design principles - composed from atoms
class ImageGridItemMolecule extends StatelessWidget {
  final String? base64Image;
  final String? imageUrl;
  final int index;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool isSelected;
  final bool isLoading;
  final double? uploadProgress;
  final bool showIndex;
  final bool showDeleteButton;

  const ImageGridItemMolecule({
    super.key,
    this.base64Image,
    this.imageUrl,
    required this.index,
    this.onTap,
    this.onDelete,
    this.isSelected = false,
    this.isLoading = false,
    this.uploadProgress,
    this.showIndex = true,
    this.showDeleteButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      children: [
        ImageThumbnailAtom(
          base64Image: base64Image,
          imageUrl: imageUrl,
          onTap: onTap,
          onDelete: showDeleteButton ? onDelete : null,
          isLoading: isLoading && uploadProgress == null,
          showDeleteButton: showDeleteButton && !isLoading,
          index: showIndex ? index : null,
          selected: isSelected,
          width: double.infinity,
          height: double.infinity,
        ),
        if (uploadProgress != null)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppProgressIndicatorAtom.circular(
                      value: uploadProgress,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(uploadProgress! * 100).round()}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (index == 0)
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'MAIN',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// A molecule for displaying image grid with selection
class SelectableImageGridMolecule extends StatelessWidget {
  final List<ImageData> images;
  final Set<int> selectedIndices;
  final ValueChanged<int>? onSelectionChanged;
  final VoidCallback? onDeleteSelected;
  final bool selectionMode;
  final int maxImages;

  const SelectableImageGridMolecule({
    super.key,
    required this.images,
    this.selectedIndices = const {},
    this.onSelectionChanged,
    this.onDeleteSelected,
    this.selectionMode = false,
    this.maxImages = 10,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        if (selectionMode)
          Container(
            padding: const EdgeInsets.all(12),
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            child: Row(
              children: [
                Text(
                  '${selectedIndices.length} selected',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (selectedIndices.isNotEmpty && onDeleteSelected != null)
                  TextButton.icon(
                    onPressed: onDeleteSelected,
                    icon: Icon(Icons.delete, color: colorScheme.error),
                    label: Text(
                      'Delete',
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ),
              ],
            ),
          ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              final image = images[index];
              final isSelected = selectedIndices.contains(index);

              return ImageGridItemMolecule(
                base64Image: image.base64Data,
                imageUrl: image.url,
                index: index,
                isSelected: isSelected,
                onTap: selectionMode
                    ? () => onSelectionChanged?.call(index)
                    : null,
                showDeleteButton: !selectionMode,
                showIndex: !selectionMode,
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: ImageCountBadgeAtom.prominent(
            count: images.length,
            maxCount: maxImages,
          ),
        ),
      ],
    );
  }
}

/// Model for image data
class ImageData {
  final String? base64Data;
  final String? url;
  final String? fileName;
  final int? sizeInBytes;
  final DateTime? uploadedAt;

  const ImageData({
    this.base64Data,
    this.url,
    this.fileName,
    this.sizeInBytes,
    this.uploadedAt,
  });
}
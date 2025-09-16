import 'package:flutter/material.dart';
import '../molecules/image_grid_item_molecule.dart';
import '../molecules/image_toolbar_molecule.dart';
import '../atoms/add_image_button_atom.dart';
import '../atoms/slot_indicator_atom.dart';
import '../atoms/image_count_badge_atom.dart';
import '../../../../core/widgets/molecules/app_empty_state_molecule.dart';
import '../../../../core/widgets/molecules/app_loading_overlay_molecule.dart';

/// An organism for displaying image gallery grid with limit management
/// Shows X/10 indicator prominently at top
/// Following atomic design principles - composed from molecules and atoms
class ImageGalleryGridOrganism extends StatelessWidget {
  final List<GalleryImage> images;
  final int maxImages;
  final bool isLoading;
  final bool selectionMode;
  final Set<String> selectedIds;
  final ValueChanged<String>? onImageTap;
  final ValueChanged<String>? onImageDelete;
  final ValueChanged<String>? onSelectionChanged;
  final VoidCallback? onAddImage;
  final VoidCallback? onReplaceImage;
  final VoidCallback? onViewAll;
  final VoidCallback? onSelectAll;
  final VoidCallback? onDeselectAll;
  final VoidCallback? onDeleteSelected;
  final ScrollController? scrollController;

  const ImageGalleryGridOrganism({
    super.key,
    required this.images,
    this.maxImages = 10,
    this.isLoading = false,
    this.selectionMode = false,
    this.selectedIds = const {},
    this.onImageTap,
    this.onImageDelete,
    this.onSelectionChanged,
    this.onAddImage,
    this.onReplaceImage,
    this.onViewAll,
    this.onSelectAll,
    this.onDeselectAll,
    this.onDeleteSelected,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final isAtLimit = images.length >= maxImages;
    final slotsRemaining = maxImages - images.length;

    if (isLoading && images.isEmpty) {
      return _buildLoadingState(context);
    }

    if (images.isEmpty) {
      return _buildEmptyState(context, isAtLimit);
    }

    return Column(
      children: [
        // Header with prominent count display
        _buildHeader(context),

        // Selection toolbar if in selection mode
        if (selectionMode)
          ImageToolbarMolecule(
            selectedCount: selectedIds.length,
            totalCount: images.length,
            maxCount: maxImages,
            onSelectAll: onSelectAll,
            onDeselectAll: onDeselectAll,
            onDelete: onDeleteSelected,
            selectionMode: true,
          ),

        // Gallery grid
        Expanded(
          child: Stack(
            children: [
              GridView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: images.length + (isAtLimit ? 0 : 1),
                itemBuilder: (context, index) {
                  if (index == images.length && !isAtLimit) {
                    return AddImagePlaceholderAtom(
                      onTap: onAddImage,
                      isAtLimit: false,
                      slotsRemaining: slotsRemaining,
                    );
                  }

                  final image = images[index];
                  final isSelected = selectedIds.contains(image.id);

                  return ImageGridItemMolecule(
                    base64Image: image.base64Data,
                    imageUrl: image.url,
                    index: index,
                    isSelected: isSelected,
                    onTap: selectionMode
                        ? () => onSelectionChanged?.call(image.id)
                        : () => onImageTap?.call(image.id),
                    onDelete: !selectionMode ? () => onImageDelete?.call(image.id) : null,
                    showDeleteButton: !selectionMode,
                    showIndex: true,
                  );
                },
              ),
              if (isLoading)
                AppLoadingOverlayMolecule(
                  isLoading: true,
                  message: 'Processing images...',
                  child: const SizedBox.shrink(),
                )
            ],
          ),
        ),

        // Bottom status bar
        _buildBottomBar(context, isAtLimit, slotsRemaining),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAtLimit = images.length >= maxImages;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.surface,
            colorScheme.surface.withValues(alpha: 0.98),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Image Gallery',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isAtLimit
                        ? 'Storage limit reached'
                        : '${maxImages - images.length} slots available',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isAtLimit
                          ? colorScheme.error
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              ImageCountBadgeAtom.prominent(
                count: images.length,
                maxCount: maxImages,
              ),
            ],
          ),
          const SizedBox(height: 12),
          SlotIndicatorAtom.bar(
            filled: images.length,
            total: maxImages,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    bool isAtLimit,
    int slotsRemaining,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: AddImageButtonAtom(
              onAdd: isAtLimit ? null : onAddImage,
              onReplace: isAtLimit ? onReplaceImage : null,
              currentCount: images.length,
              maxCount: maxImages,
              variant: ButtonVariant.filled,
            ),
          ),
          if (images.isNotEmpty) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: onViewAll,
              icon: const Icon(Icons.view_carousel),
              tooltip: 'View carousel',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 2; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int j = 0; j < 3; j++)
                          AppSkeletonLoadingMolecule.card(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isAtLimit) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: Center(
            child: AppEmptyStateMolecule(
              icon: Icons.photo_library_outlined,
              title: 'No Images Yet',
              message: isAtLimit
                  ? 'Storage limit prevents adding images'
                  : 'Start adding images to this lead',
              actionText: isAtLimit ? null : 'Add First Image',
              onAction: isAtLimit ? null : onAddImage,
            ),
          ),
        ),
      ],
    );
  }
}

/// Data model for gallery images
class GalleryImage {
  final String id;
  final String? base64Data;
  final String? url;
  final String fileName;
  final int sizeInBytes;
  final DateTime uploadedAt;
  final bool isMain;

  const GalleryImage({
    required this.id,
    this.base64Data,
    this.url,
    required this.fileName,
    required this.sizeInBytes,
    required this.uploadedAt,
    this.isMain = false,
  });
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../lead_image/presentation/providers/image_providers.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../atoms/image_thumbnail_atom.dart';

class LeadImageGalleryMolecule extends ConsumerWidget {
  final String leadId;
  final int maxImages;
  final VoidCallback onAddPhotos;
  final bool isLoading;

  const LeadImageGalleryMolecule({
    super.key,
    required this.leadId,
    required this.maxImages,
    required this.onAddPhotos,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(imageGalleryViewModelProvider(leadId));
    final images = imageState.images;
    final loading = isLoading || imageState.isBusy;

    if (loading) {
      return _buildLoadingSkeleton(context);
    }

    if (images.isEmpty) {
      return _buildEmptyGallery(context);
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Non-scrollable, 3 columns per row. Container grows with content.
    return LayoutBuilder(
      builder: (context, constraints) {
        const horizontalPadding = 12.0;
        const verticalPadding = 12.0;
        const hSpacing = 8.0; // space between columns
        const vSpacing = 12.0; // space between rows

        // Compute exact width so 3 tiles fit per row with spacing
        final availableWidth = constraints.maxWidth - (horizontalPadding * 2) - (hSpacing * 2);
        final tileWidth = (availableWidth / 3).floorToDouble();
        final tileHeight = tileWidth; // square tiles

        final children = <Widget>[];

        for (var i = 0; i < images.length; i++) {
          final image = images[i];
          children.add(
            SizedBox(
              width: tileWidth,
              height: tileHeight,
              child: ImageThumbnailAtom(
                imageBase64: image.base64Data.value,
                index: i,
                onTap: () => _showImageOptions(context, ref, image.id),
              ),
            ),
          );
        }

        final canAdd = images.length < maxImages;
        if (canAdd) {
          children.add(_AddTile(
            width: tileWidth,
            height: tileHeight,
            onTap: onAddPhotos,
          ));
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Wrap(
            spacing: hSpacing,
            runSpacing: vSpacing,
            children: children,
          ),
        );
      },
    );
  }

  Widget _buildEmptyGallery(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          style: BorderStyle.solid,
        ),
      ),
      child: InkWell(
        onTap: onAddPhotos,
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 40,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              Text(
                'Add Photos',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        const horizontalPadding = 12.0;
        const verticalPadding = 12.0;
        const hSpacing = 8.0;
        const vSpacing = 12.0;

        final availableWidth = constraints.maxWidth - (horizontalPadding * 2) - (hSpacing * 2);
        final tileWidth = (availableWidth / 3).floorToDouble();
        final tileHeight = tileWidth;

        final placeholders = List.generate(6, (i) => _SkeletonTile(width: tileWidth, height: tileHeight));

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Wrap(
            spacing: hSpacing,
            runSpacing: vSpacing,
            children: placeholders,
          ),
        );
      },
    );
  }

  void _showImageOptions(BuildContext context, WidgetRef ref, String imageId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.remove_red_eye_outlined),
              title: const Text('Inspect'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                context.go(RouteNames.getImageViewerPath(leadId, imageId));
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                final vm = ref.read(imageGalleryViewModelProvider(leadId).notifier);
                final image = ref.read(imageGalleryViewModelProvider(leadId)).images.firstWhere((i) => i.id == imageId);
                vm.deleteImage(image);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _AddTile extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback onTap;

  const _AddTile({required this.width, required this.height, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: colorScheme.outline,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_photo_alternate, size: 28, color: colorScheme.primary),
                const SizedBox(height: 4),
                Text('Add', style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.primary)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SkeletonTile extends StatelessWidget {
  final double width;
  final double height;

  const _SkeletonTile({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.2);
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

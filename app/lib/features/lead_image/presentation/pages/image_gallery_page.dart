import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../organisms/image_gallery_grid_organism.dart';

/// Image gallery page showing "X of 10 Images" header
class ImageGalleryPage extends ConsumerWidget {
  final String leadId;

  const ImageGalleryPage({
    super.key,
    required this.leadId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock data - replace with actual state management
    final images = <GalleryImage>[];
    const maxImages = 10;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header: "7 of 10 Images"
            _buildHeader(context, images.length, maxImages),
            // Gallery
            Expanded(
              child: ImageGalleryGridOrganism(
                images: images,
                maxImages: maxImages,
                onImageTap: (id) => context.go('/leads/$leadId/images/$id'),
                onAddImage: images.length < maxImages
                    ? () => context.go('/leads/$leadId/images/upload')
                    : null,
                onReplaceImage: images.length >= maxImages
                    ? () => context.go('/leads/$leadId/images/replace')
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int currentCount, int maxCount) {
    final theme = Theme.of(context);
    final isAtLimit = currentCount >= maxCount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Center(
              child: Text(
                '$currentCount of $maxCount Images',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isAtLimit ? theme.colorScheme.error : null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48), // Balance the layout
        ],
      ),
    );
  }
}
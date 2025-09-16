import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/base/base_page.dart';
import '../states/image_gallery_state.dart';
import '../providers/image_providers.dart';
import '../../domain/entities/lead_image_entity.dart';

/// Image gallery page showing "X of 10 Images" header with simple list
/// No replacement flow - users must delete to add more when at limit
class ImageGalleryPage extends BasePage<ImageGalleryState> {
  final String leadId;

  const ImageGalleryPage({
    super.key,
    required this.leadId,
  }) : super(
    initialShowAppBar: false,
    wrapWithScroll: false,
  );

  @override
  ConsumerState<ImageGalleryPage> createState() => _ImageGalleryPageState();
}

class _ImageGalleryPageState extends BasePageState<ImageGalleryPage, ImageGalleryState> {
  @override
  ProviderListenable<ImageGalleryState> get vmProvider =>
      imageGalleryViewModelProvider(widget.leadId);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(imageGalleryViewModelProvider(widget.leadId).notifier).fetchImages();
    });
  }

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vmProvider);
    final currentCount = state.images.length;
    const maxCount = 10;

    return Column(
      children: [
        // Header showing count
        _buildHeader(context, currentCount, maxCount),

        // Limit status bar
        if (currentCount >= maxCount)
          _buildLimitWarning(context),

        // Image list
        Expanded(
          child: _buildImageList(context, ref, state),
        ),

        // Add button (disabled at limit)
        if (currentCount < maxCount)
          _buildAddButton(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, int currentCount, int maxCount) {
    final theme = Theme.of(context);
    final isAtLimit = currentCount >= maxCount;
    final slotsAvailable = maxCount - currentCount;

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$currentCount of $maxCount Images',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isAtLimit ? theme.colorScheme.error : null,
                  ),
                ),
                if (!isAtLimit)
                  Text(
                    '$slotsAvailable slots available',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 48), // Balance the layout
        ],
      ),
    );
  }

  Widget _buildLimitWarning(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: theme.colorScheme.errorContainer,
      child: Row(
        children: [
          Icon(
            Icons.warning,
            color: theme.colorScheme.onErrorContainer,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Maximum limit reached. Delete images to add new ones.',
              style: TextStyle(
                color: theme.colorScheme.onErrorContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageList(BuildContext context, WidgetRef ref, ImageGalleryState state) {
    if (state.images.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No images yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first image',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.images.length,
      itemBuilder: (context, index) {
        final image = state.images[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              child: const Icon(Icons.photo),
            ),
            title: Text(
              'Image ${index + 1}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Uploaded: ${image.metadata.uploadedAt.toString().split('.').first}\nSize: ${image.metadata.sizeDisplay}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () => context.go('/leads/${widget.leadId}/images/${image.id}'),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () => _showDeleteConfirmation(context, ref, image),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => context.go('/leads/${widget.leadId}/images/upload'),
          icon: const Icon(Icons.add_photo_alternate),
          label: const Text('Add Image'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, LeadImageEntity image) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Image?'),
        content: const Text(
          'Are you sure you want to delete this image?\n'
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ref.read(imageGalleryViewModelProvider(widget.leadId).notifier).deleteImage(image);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Image deleted'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
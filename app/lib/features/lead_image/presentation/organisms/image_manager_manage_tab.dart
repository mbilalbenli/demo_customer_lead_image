import 'package:flutter/material.dart';
import '../../data/models/managed_image_model.dart';
import '../molecules/image_grid_item_molecule.dart';
import '../../../../core/widgets/molecules/app_empty_state_molecule.dart';

class ImageManagerManageTab extends StatefulWidget {
  final List<ManagedImage> images;
  final ValueChanged<String>? onImageSelect;
  final ValueChanged<String>? onImageDelete;
  final VoidCallback? onAddImage;

  const ImageManagerManageTab({
    super.key,
    required this.images,
    this.onImageSelect,
    this.onImageDelete,
    this.onAddImage,
  });

  @override
  State<ImageManagerManageTab> createState() => _ImageManagerManageTabState();
}

class _ImageManagerManageTabState extends State<ImageManagerManageTab> {
  String? _selectedImageId;
  bool _showReplacementMode = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (widget.images.isEmpty) {
      return const Center(
        child: AppEmptyStateMolecule(
          icon: Icons.photo_library_outlined,
          title: 'No Images to Manage',
          message: 'Add images to manage them here',
        ),
      );
    }

    return Column(
      children: [
        // Management toolbar
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Row(
            children: [
              if (_showReplacementMode) ...[
                IconButton(
                  onPressed: () => setState(() {
                    _showReplacementMode = false;
                    _selectedImageId = null;
                  }),
                  icon: const Icon(Icons.close),
                ),
                Text(
                  'Select image to replace',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ] else ...[
                const Spacer(),
                Text(
                  '${widget.images.length} images',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),

        // Image grid for management
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              final image = widget.images[index];
              final isSelected = image.id == _selectedImageId;

              return ImageGridItemMolecule(
                index: index,
                base64Image: image.base64Data,
                imageUrl: image.url,
                isSelected: isSelected,
                onTap: _showReplacementMode
                    ? () => _handleReplacement(image.id)
                    : () => setState(() {
                            _selectedImageId = isSelected ? null : image.id;
                          }),
                onDelete: () => _confirmDelete(context, image),
                showDeleteButton: !_showReplacementMode && isSelected,
              );
            },
          ),
        ),
      ],
    );
  }

  void _handleReplacement(String imageId) {
    setState(() {
      _showReplacementMode = false;
      _selectedImageId = null;
    });

    // Handle replacement logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image replacement initiated'),
      ),
    );

    widget.onAddImage?.call();
  }

  void _confirmDelete(BuildContext context, ManagedImage image) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Image'),
        content: Text('Delete "${image.fileName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onImageDelete?.call(image.id);
              setState(() {
                _selectedImageId = null;
              });
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

}
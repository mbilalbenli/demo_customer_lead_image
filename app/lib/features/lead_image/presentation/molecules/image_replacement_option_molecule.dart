import 'package:flutter/material.dart';
import '../atoms/image_thumbnail_atom.dart';
import '../../../../core/widgets/atoms/app_button_atom.dart';

/// A molecule for handling image replacement when at limit
/// Following atomic design principles - composed from atoms
class ImageReplacementOptionMolecule extends StatelessWidget {
  final List<ImageInfo> currentImages;
  final int? selectedImageIndex;
  final ValueChanged<int>? onImageSelected;
  final VoidCallback? onConfirmReplace;
  final VoidCallback? onCancel;
  final bool showInstructions;

  const ImageReplacementOptionMolecule({
    super.key,
    required this.currentImages,
    this.selectedImageIndex,
    this.onImageSelected,
    this.onConfirmReplace,
    this.onCancel,
    this.showInstructions = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasSelection = selectedImageIndex != null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.swap_horiz,
                  color: colorScheme.tertiary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Replace Image',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (showInstructions) ...[
              const SizedBox(height: 8),
              Text(
                'You\'ve reached the maximum image limit. Select an image to replace:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: currentImages.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final image = currentImages[index];
                  final isSelected = selectedImageIndex == index;

                  return Stack(
                    children: [
                      InkWell(
                        onTap: () => onImageSelected?.call(index),
                        borderRadius: BorderRadius.circular(8),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? colorScheme.tertiary
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: ImageThumbnailAtom(
                            base64Image: image.base64Data,
                            imageUrl: image.url,
                            width: 100,
                            height: 100,
                            selected: false,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: colorScheme.tertiary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              size: 16,
                              color: colorScheme.onTertiary,
                            ),
                          ),
                        ),
                      if (index == 0)
                        Positioned(
                          bottom: 4,
                          left: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
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
                },
              ),
            ),
            const SizedBox(height: 16),
            if (hasSelection)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: colorScheme.tertiary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Image ${selectedImageIndex! + 1} will be replaced with the new image',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppOutlinedButtonAtom(
                    text: 'Cancel',
                    onPressed: onCancel,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButtonAtom(
                    text: hasSelection ? 'Replace' : 'Select Image',
                    onPressed: hasSelection ? onConfirmReplace : null,
                    icon: Icon(
                      Icons.swap_horiz,
                      size: 18,
                      color: hasSelection ? null : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Model for image information
class ImageInfo {
  final String? base64Data;
  final String? url;
  final String fileName;
  final DateTime uploadedAt;

  const ImageInfo({
    this.base64Data,
    this.url,
    required this.fileName,
    required this.uploadedAt,
  });
}

/// A dialog-style replacement option molecule
class ReplacementDialogMolecule extends StatelessWidget {
  final VoidCallback? onReplace;
  final VoidCallback? onCancel;
  final VoidCallback? onManage;

  const ReplacementDialogMolecule({
    super.key,
    this.onReplace,
    this.onCancel,
    this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info,
            size: 48,
            color: colorScheme.tertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'Storage Limit Reached',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'ve reached the maximum of 10 images. '
            'Would you like to replace an existing image?',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppButtonAtom(
                text: 'Replace Existing Image',
                onPressed: onReplace,
                icon: const Icon(Icons.swap_horiz, size: 18),
              ),
              const SizedBox(height: 8),
              AppOutlinedButtonAtom(
                text: 'Manage Images',
                onPressed: onManage,
                icon: const Icon(Icons.photo_library, size: 18),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: onCancel,
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
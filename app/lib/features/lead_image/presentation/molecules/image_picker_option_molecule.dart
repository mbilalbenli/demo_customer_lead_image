import 'package:flutter/material.dart';
import '../atoms/camera_button_atom.dart' as camera;
import '../atoms/add_image_button_atom.dart';
import '../atoms/limit_warning_atom.dart';
import '../atoms/slot_indicator_atom.dart';

/// A molecule for image picker options with limit awareness
/// Following atomic design principles - composed from atoms
class ImagePickerOptionMolecule extends StatelessWidget {
  final VoidCallback? onCamera;
  final VoidCallback? onGallery;
  final VoidCallback? onReplace;
  final int currentImageCount;
  final int maxImageCount;
  final bool showSlotIndicator;
  final PickerStyle style;

  const ImagePickerOptionMolecule({
    super.key,
    required this.onCamera,
    required this.onGallery,
    this.onReplace,
    required this.currentImageCount,
    this.maxImageCount = 10,
    this.showSlotIndicator = true,
    this.style = PickerStyle.card,
  });

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case PickerStyle.card:
        return _buildCardStyle(context);
      case PickerStyle.bottomSheet:
        return _buildBottomSheetStyle(context);
      case PickerStyle.inline:
        return _buildInlineStyle(context);
    }
  }

  Widget _buildCardStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAtLimit = currentImageCount >= maxImageCount;
    final slotsRemaining = maxImageCount - currentImageCount;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isAtLimit ? 'Storage Full' : 'Add Images',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isAtLimit ? 'No slots available' : '$slotsRemaining slots available',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isAtLimit ? colorScheme.error : colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            if (showSlotIndicator) ...[
              const SizedBox(height: 12),
              SlotIndicatorAtom.dots(
                filled: currentImageCount,
                total: maxImageCount,
              ),
            ],
            const SizedBox(height: 16),
            if (!isAtLimit) ...[
              Row(
                children: [
                  Expanded(
                    child: camera.CameraButtonAtom(
                      onPressed: onCamera,
                      isAtLimit: false,
                      style: camera.ButtonStyle.outlined,
                      label: 'Camera',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onGallery,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Gallery'),
                    ),
                  ),
                ],
              ),
            ] else ...[
              LimitWarningAtom(
                currentCount: currentImageCount,
                maxCount: maxImageCount,
                level: WarningLevel.atLimit,
                onAction: onReplace,
                actionLabel: 'Replace Image',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAtLimit = currentImageCount >= maxImageCount;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            isAtLimit ? 'Image Limit Reached' : 'Choose Image Source',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (showSlotIndicator) ...[
            const SizedBox(height: 12),
            SlotIndicatorAtom.bar(
              filled: currentImageCount,
              total: maxImageCount,
            ),
          ],
          const SizedBox(height: 24),
          if (!isAtLimit) ...[
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              title: const Text('Take Photo'),
              subtitle: const Text('Use camera to capture image'),
              onTap: () {
                Navigator.pop(context);
                onCamera?.call();
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.photo_library,
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
              title: const Text('Choose from Gallery'),
              subtitle: const Text('Select existing image'),
              onTap: () {
                Navigator.pop(context);
                onGallery?.call();
              },
            ),
          ] else ...[
            LimitWarningAtom(
              currentCount: currentImageCount,
              maxCount: maxImageCount,
              level: WarningLevel.atLimit,
            ),
            const SizedBox(height: 16),
            if (onReplace != null)
              FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  onReplace?.call();
                },
                icon: const Icon(Icons.swap_horiz),
                label: const Text('Replace Existing Image'),
              ),
          ],
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildInlineStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAtLimit = currentImageCount >= maxImageCount;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          if (showSlotIndicator)
            CompactSlotIndicatorAtom(
              filledSlots: currentImageCount,
              totalSlots: maxImageCount,
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (!isAtLimit) ...[
                Expanded(
                  child: camera.CameraButtonAtom.icon(
                    onPressed: onCamera,
                    isAtLimit: false,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: IconButton(
                    onPressed: onGallery,
                    icon: const Icon(Icons.photo_library),
                    tooltip: 'Choose from gallery',
                  ),
                ),
              ] else ...[
                Expanded(
                  child: AddImageButtonAtom(
                    onAdd: null,
                    onReplace: onReplace,
                    currentCount: currentImageCount,
                    maxCount: maxImageCount,
                    variant: ButtonVariant.outlined,
                    showCount: false,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

enum PickerStyle {
  card,
  bottomSheet,
  inline,
}

/// A quick access image picker molecule
class QuickImagePickerMolecule extends StatelessWidget {
  final VoidCallback? onCamera;
  final VoidCallback? onGallery;
  final bool isAtLimit;

  const QuickImagePickerMolecule({
    super.key,
    required this.onCamera,
    required this.onGallery,
    this.isAtLimit = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filled(
          onPressed: isAtLimit ? null : onCamera,
          icon: const Icon(Icons.camera_alt),
          tooltip: isAtLimit ? 'Image limit reached' : 'Take photo',
          style: IconButton.styleFrom(
            backgroundColor: isAtLimit
                ? colorScheme.surfaceContainerHighest
                : colorScheme.primaryContainer,
            foregroundColor: isAtLimit
                ? colorScheme.onSurfaceVariant
                : colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          onPressed: isAtLimit ? null : onGallery,
          icon: const Icon(Icons.photo_library),
          tooltip: isAtLimit ? 'Image limit reached' : 'Choose from gallery',
          style: IconButton.styleFrom(
            backgroundColor: isAtLimit
                ? colorScheme.surfaceContainerHighest
                : colorScheme.secondaryContainer,
            foregroundColor: isAtLimit
                ? colorScheme.onSurfaceVariant
                : colorScheme.onSecondaryContainer,
          ),
        ),
      ],
    );
  }
}
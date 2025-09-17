import 'package:flutter/material.dart';

class ImageActionBarMolecule extends StatelessWidget {
  final VoidCallback? onCameraPressed;
  final VoidCallback? onGalleryPressed;
  final VoidCallback? onUploadPressed;
  final VoidCallback? onDeletePressed;
  final bool canUpload;
  final bool canDelete;

  const ImageActionBarMolecule({
    super.key,
    this.onCameraPressed,
    this.onGalleryPressed,
    this.onUploadPressed,
    this.onDeletePressed,
    this.canUpload = false,
    this.canDelete = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image Source Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCameraPressed,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onGalleryPressed,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: canUpload ? onUploadPressed : null,
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text('Start Upload'),
                ),
              ),
              const SizedBox(width: 12),
              IconButton.filled(
                onPressed: canDelete ? onDeletePressed : null,
                icon: const Icon(Icons.delete_outline),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
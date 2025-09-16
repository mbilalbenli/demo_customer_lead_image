import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../organisms/image_capture_overlay_organism.dart';

/// Image capture page - disabled at limit with message
class ImageCapturePage extends ConsumerWidget {
  final String leadId;

  const ImageCapturePage({
    super.key,
    required this.leadId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock data - replace with actual state management
    const currentImageCount = 10; // At limit for demonstration
    const maxImages = 10;

    if (currentImageCount >= maxImages) {
      return _buildLimitReachedScreen(context);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: ImageCaptureOverlayOrganism(
        currentImageCount: currentImageCount,
        maxImages: maxImages,
        onCapture: () {
          // Handle capture
        },
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildLimitReachedScreen(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cannot Capture Image'),
        backgroundColor: colorScheme.errorContainer,
        foregroundColor: colorScheme.onErrorContainer,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.block,
                size: 80,
                color: colorScheme.error,
              ),
              const SizedBox(height: 24),
              Text(
                'Storage Full',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.error,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'You have reached the limit of 10 images.',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Delete an image to add more',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.photo_library),
                label: const Text('Manage Images'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
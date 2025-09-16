import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../organisms/image_upload_queue_organism.dart';
import '../atoms/slot_indicator_atom.dart';

/// Image upload page - shows slots, disabled at limit
class ImageUploadPage extends ConsumerWidget {
  final String leadId;

  const ImageUploadPage({
    super.key,
    required this.leadId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock data - replace with actual state management
    const currentImageCount = 8;
    const maxImages = 10;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Images'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: _buildSlotIndicator(context, currentImageCount, maxImages),
        ),
      ),
      body: currentImageCount >= maxImages
          ? _buildLimitReachedContent(context)
          : _buildUploadContent(context, currentImageCount, maxImages),
    );
  }

  Widget _buildSlotIndicator(BuildContext context, int current, int max) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAtLimit = current >= max;

    return Container(
      padding: const EdgeInsets.all(16),
      color: isAtLimit
          ? colorScheme.errorContainer.withValues(alpha: 0.2)
          : colorScheme.surface,
      child: Column(
        children: [
          Text(
            isAtLimit ? 'Storage Full' : '${max - current} slots available',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isAtLimit ? colorScheme.error : null,
            ),
          ),
          const SizedBox(height: 8),
          SlotIndicatorAtom.bar(
            filled: current,
            total: max,
          ),
        ],
      ),
    );
  }

  Widget _buildUploadContent(BuildContext context, int current, int max) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Upload queue
        Expanded(
          child: ImageUploadQueueOrganism(
            queueItems: const [],
            currentImageCount: current,
            maxImages: max,
          ),
        ),
        // Upload button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Visual slots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(max, (index) {
                  final isFilled = index < current;
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isFilled
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceContainerHighest,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: current < max ? () {} : null,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Take Photo'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: current < max ? () {} : null,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Choose from Gallery'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLimitReachedContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.storage_rounded,
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
              'You have reached the maximum of 10 images.',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Delete an image to add more',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../data/models/managed_image_model.dart';

class ImageManagerStorageTab extends StatelessWidget {
  final List<ManagedImage> images;
  final int storageUsed;
  final VoidCallback? onManageStorage;

  const ImageManagerStorageTab({
    super.key,
    required this.images,
    required this.storageUsed,
    this.onManageStorage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final avgSize = images.isNotEmpty ? storageUsed ~/ images.length : 0;

    // Sort images by size for analysis
    final sortedImages = List<ManagedImage>.from(images)
      ..sort((a, b) => b.sizeInBytes.compareTo(a.sizeInBytes));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Storage overview card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.storage,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Storage Overview',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildStorageMetric(
                    context,
                    'Total Storage Used',
                    _formatFileSize(storageUsed),
                    colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  _buildStorageMetric(
                    context,
                    'Average per Image',
                    _formatFileSize(avgSize),
                    colorScheme.secondary,
                  ),
                  if (sortedImages.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildStorageMetric(
                      context,
                      'Largest Image',
                      _formatFileSize(sortedImages.first.sizeInBytes),
                      colorScheme.tertiary,
                    ),
                    const SizedBox(height: 12),
                    _buildStorageMetric(
                      context,
                      'Smallest Image',
                      _formatFileSize(sortedImages.last.sizeInBytes),
                      colorScheme.tertiary,
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Storage distribution chart
          if (images.isNotEmpty) ...[
            Text(
              'Storage Distribution',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            ...sortedImages.take(5).map(
              (image) => _buildImageStorageItem(context, image),
            ),

            if (images.length > 5) ...[
              const SizedBox(height: 8),
              Text(
                '... and ${images.length - 5} more images',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],

          const SizedBox(height: 16),

          // Storage recommendations
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: colorScheme.tertiary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Recommendations',
                        style: theme.textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...getStorageRecommendations(avgSize, sortedImages).map(
                    (rec) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 16,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              rec,
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (onManageStorage != null) ...[
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: onManageStorage,
              child: const Text('Manage Storage Settings'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStorageMetric(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildImageStorageItem(BuildContext context, ManagedImage image) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final percentage = images.isNotEmpty
        ? (image.sizeInBytes / storageUsed * 100)
        : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  image.fileName.length > 20
                      ? '${image.fileName.substring(0, 20)}...'
                      : image.fileName,
                  style: theme.textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatFileSize(image.sizeInBytes),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${percentage.toStringAsFixed(1)}%)',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getStorageColor(context, percentage),
              ),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStorageColor(BuildContext context, double percentage) {
    final colorScheme = Theme.of(context).colorScheme;
    if (percentage >= 30) return colorScheme.error;
    if (percentage >= 20) return colorScheme.tertiary;
    return colorScheme.primary;
  }

  List<String> getStorageRecommendations(int avgSize, List<ManagedImage> sortedImages) {
    final recommendations = <String>[];

    if (avgSize > 1024 * 1024) {
      recommendations.add('Consider compressing images to reduce storage usage');
    }

    if (sortedImages.isNotEmpty &&
        sortedImages.first.sizeInBytes > 3 * avgSize) {
      recommendations.add('Some images are significantly larger than average');
    }

    if (images.length >= 8) {
      recommendations.add('You are approaching the image limit');
    }

    if (recommendations.isEmpty) {
      recommendations.add('Storage usage is optimal');
    }

    return recommendations;
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
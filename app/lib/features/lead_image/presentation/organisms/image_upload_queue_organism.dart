import 'package:flutter/material.dart';
import '../molecules/upload_progress_card_molecule.dart';
import '../atoms/image_count_badge_atom.dart';
import '../../../../core/widgets/molecules/app_empty_state_molecule.dart';

/// An organism for managing image upload queue with limit awareness
/// Respects the 10-image limit and shows upload progress
/// Following atomic design principles - composed from molecules and atoms
class ImageUploadQueueOrganism extends StatelessWidget {
  final List<UploadQueueItem> queueItems;
  final int currentImageCount;
  final int maxImages;
  final bool isProcessing;
  final ValueChanged<String>? onRetryUpload;
  final ValueChanged<String>? onCancelUpload;
  final ValueChanged<String>? onRemoveFromQueue;
  final VoidCallback? onClearCompleted;
  final VoidCallback? onPauseAll;
  final VoidCallback? onResumeAll;

  const ImageUploadQueueOrganism({
    super.key,
    required this.queueItems,
    required this.currentImageCount,
    this.maxImages = 10,
    this.isProcessing = false,
    this.onRetryUpload,
    this.onCancelUpload,
    this.onRemoveFromQueue,
    this.onClearCompleted,
    this.onPauseAll,
    this.onResumeAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final pendingItems = queueItems.where((item) =>
      item.status == UploadStatus.pending ||
      item.status == UploadStatus.uploading
    ).length;
    final completedItems = queueItems.where((item) =>
      item.status == UploadStatus.completed
    ).length;
    final failedItems = queueItems.where((item) =>
      item.status == UploadStatus.failed
    ).length;
    final willExceedLimit = currentImageCount + pendingItems > maxImages;

    if (queueItems.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: [
        // Header with stats
        _buildHeader(context, pendingItems, completedItems, failedItems),

        // Limit warning if applicable
        if (willExceedLimit)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorScheme.error.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: colorScheme.onErrorContainer,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Upload will exceed limit. Only ${maxImages - currentImageCount} more images can be added.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Queue toolbar
        if (queueItems.isNotEmpty)
          _buildToolbar(context),

        // Upload queue list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: queueItems.length,
            itemBuilder: (context, index) {
              final item = queueItems[index];
              final isOverLimit = currentImageCount + index >= maxImages;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: UploadProgressCardMolecule(
                  fileName: item.fileName,
                  fileSize: item.fileSize,
                  progress: item.progress,
                  status: item.status,
                  errorMessage: item.errorMessage,
                  isOverLimit: isOverLimit,
                  thumbnailData: item.thumbnailData,
                  onRetry: item.status == UploadStatus.failed
                      ? () => onRetryUpload?.call(item.id)
                      : null,
                  onCancel: item.status == UploadStatus.uploading
                      ? () => onCancelUpload?.call(item.id)
                      : null,
                  onRemove: item.status != UploadStatus.uploading
                      ? () => onRemoveFromQueue?.call(item.id)
                      : null,
                ),
              );
            },
          ),
        ),

        // Bottom status bar
        _buildBottomBar(context),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context,
    int pending,
    int completed,
    int failed,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upload Queue',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              ImageCountBadgeAtom.standard(
                count: currentImageCount,
                maxCount: maxImages,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatChip(
                context,
                Icons.schedule,
                '$pending pending',
                colorScheme.primary,
              ),
              const SizedBox(width: 8),
              _buildStatChip(
                context,
                Icons.check_circle,
                '$completed done',
                colorScheme.primary,
              ),
              if (failed > 0) ...[
                const SizedBox(width: 8),
                _buildStatChip(
                  context,
                  Icons.error,
                  '$failed failed',
                  colorScheme.error,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasCompleted = queueItems.any((item) =>
      item.status == UploadStatus.completed
    );
    final hasActive = queueItems.any((item) =>
      item.status == UploadStatus.uploading
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          if (hasActive && onPauseAll != null)
            TextButton.icon(
              onPressed: onPauseAll,
              icon: const Icon(Icons.pause, size: 18),
              label: const Text('Pause All'),
            ),
          if (!hasActive && onResumeAll != null)
            TextButton.icon(
              onPressed: onResumeAll,
              icon: const Icon(Icons.play_arrow, size: 18),
              label: const Text('Resume All'),
            ),
          const Spacer(),
          if (hasCompleted && onClearCompleted != null)
            TextButton.icon(
              onPressed: onClearCompleted,
              icon: const Icon(Icons.clear_all, size: 18),
              label: const Text('Clear Done'),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activeUploads = queueItems.where((item) =>
      item.status == UploadStatus.uploading
    ).length;
    final totalProgress = queueItems.isEmpty ? 0.0 :
      queueItems.map((item) => item.progress).reduce((a, b) => a + b) /
      queueItems.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: totalProgress,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                activeUploads > 0
                  ? 'Uploading $activeUploads file${activeUploads > 1 ? 's' : ''}...'
                  : 'Queue idle',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '${(totalProgress * 100).toStringAsFixed(0)}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return const Center(
      child: AppEmptyStateMolecule(
        icon: Icons.cloud_upload_outlined,
        title: 'No Uploads in Queue',
        message: 'Images will appear here when you start uploading',
      ),
    );
  }
}

/// Data model for upload queue items
class UploadQueueItem {
  final String id;
  final String fileName;
  final int fileSize;
  final double progress;
  final UploadStatus status;
  final String? errorMessage;
  final String? thumbnailData;
  final DateTime addedAt;

  const UploadQueueItem({
    required this.id,
    required this.fileName,
    required this.fileSize,
    required this.progress,
    required this.status,
    this.errorMessage,
    this.thumbnailData,
    required this.addedAt,
  });
}

/// Upload status enumeration
enum UploadStatus {
  pending,
  uploading,
  completed,
  failed,
  cancelled,
}
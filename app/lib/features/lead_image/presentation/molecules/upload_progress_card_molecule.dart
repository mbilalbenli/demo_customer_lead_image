import 'package:flutter/material.dart';
import '../organisms/image_upload_queue_organism.dart';

/// A molecule for displaying upload progress card
/// Following atomic design principles - composed from atoms
class UploadProgressCardMolecule extends StatelessWidget {
  final String fileName;
  final int fileSize;
  final double progress;
  final UploadStatus status;
  final String? errorMessage;
  final bool isOverLimit;
  final String? thumbnailData;
  final VoidCallback? onRetry;
  final VoidCallback? onCancel;
  final VoidCallback? onRemove;

  const UploadProgressCardMolecule({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.progress,
    required this.status,
    this.errorMessage,
    this.isOverLimit = false,
    this.thumbnailData,
    this.onRetry,
    this.onCancel,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case UploadStatus.pending:
        statusColor = colorScheme.onSurfaceVariant;
        statusIcon = Icons.schedule;
        break;
      case UploadStatus.uploading:
        statusColor = colorScheme.primary;
        statusIcon = Icons.cloud_upload;
        break;
      case UploadStatus.completed:
        statusColor = colorScheme.primary;
        statusIcon = Icons.check_circle;
        break;
      case UploadStatus.failed:
        statusColor = colorScheme.error;
        statusIcon = Icons.error;
        break;
      case UploadStatus.cancelled:
        statusColor = colorScheme.tertiary;
        statusIcon = Icons.cancel;
        break;
    }

    return Card(
      color: isOverLimit
          ? colorScheme.errorContainer.withValues(alpha: 0.3)
          : null,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
                border: isOverLimit
                    ? Border.all(
                        color: colorScheme.error.withValues(alpha: 0.5),
                        width: 2,
                      )
                    : null,
              ),
              child: Center(
                child: Icon(
                  Icons.image,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // File info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatFileSize(fileSize),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (status == UploadStatus.uploading) ...[
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    ),
                  ],
                  if (errorMessage != null && status == UploadStatus.failed) ...[
                    const SizedBox(height: 4),
                    Text(
                      errorMessage!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (isOverLimit) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Exceeds limit',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Status icon
            Icon(statusIcon, color: statusColor, size: 20),
            // Action button
            if (status == UploadStatus.failed && onRetry != null)
              IconButton(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                tooltip: 'Retry',
              ),
            if (status == UploadStatus.uploading && onCancel != null)
              IconButton(
                onPressed: onCancel,
                icon: const Icon(Icons.close, size: 18),
                tooltip: 'Cancel',
              ),
            if (status != UploadStatus.uploading && onRemove != null)
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline, size: 18),
                tooltip: 'Remove',
              ),
          ],
        ),
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
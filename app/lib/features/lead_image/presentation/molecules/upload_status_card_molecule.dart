import 'package:flutter/material.dart';
import '../atoms/upload_progress_atom.dart';
import '../atoms/image_count_badge_atom.dart';
import '../atoms/limit_warning_atom.dart';
import '../../../../core/widgets/atoms/app_button_atom.dart';

/// A molecule for displaying upload status with progress
/// Following atomic design principles - composed from atoms
class UploadStatusCardMolecule extends StatelessWidget {
  final List<UploadItem> items;
  final int currentImageCount;
  final int maxImageCount;
  final VoidCallback? onCancelAll;
  final VoidCallback? onRetryFailed;
  final VoidCallback? onViewUploaded;

  const UploadStatusCardMolecule({
    super.key,
    required this.items,
    required this.currentImageCount,
    this.maxImageCount = 10,
    this.onCancelAll,
    this.onRetryFailed,
    this.onViewUploaded,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final completedCount = items.where((item) => item.isComplete).length;
    final failedCount = items.where((item) => item.hasError).length;
    final inProgressCount = items.where((item) => !item.isComplete && !item.hasError).length;
    final willExceedLimit = currentImageCount + items.length > maxImageCount;

    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.cloud_upload,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Upload Status',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                ImageCountBadgeAtom.minimal(
                  count: currentImageCount,
                  maxCount: maxImageCount,
                ),
              ],
            ),

            // Warning if will exceed limit
            if (willExceedLimit) ...[
              const SizedBox(height: 12),
              LimitWarningAtom(
                currentCount: currentImageCount + items.length,
                maxCount: maxImageCount,
                level: WarningLevel.atLimit,
                compact: true,
              ),
            ],

            const SizedBox(height: 16),

            // Summary stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  'Uploading',
                  inProgressCount,
                  colorScheme.primary,
                ),
                _buildStatItem(
                  context,
                  'Completed',
                  completedCount,
                  colorScheme.primary,
                ),
                _buildStatItem(
                  context,
                  'Failed',
                  failedCount,
                  colorScheme.error,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Upload progress items
            if (items.isNotEmpty)
              MultiUploadProgressAtom(
                items: items
                    .map((item) => UploadProgressItem(
                          fileName: item.fileName,
                          progress: item.progress,
                          isComplete: item.isComplete,
                          hasError: item.hasError,
                          errorMessage: item.errorMessage,
                        ))
                    .toList(),
                onCancelAll: inProgressCount > 0 ? onCancelAll : null,
              ),

            // Action buttons
            if (failedCount > 0 || completedCount > 0) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  if (failedCount > 0 && onRetryFailed != null)
                    Expanded(
                      child: AppOutlinedButtonAtom(
                        text: 'Retry Failed',
                        onPressed: onRetryFailed,
                        icon: const Icon(Icons.refresh, size: 18),
                      ),
                    ),
                  if (failedCount > 0 && completedCount > 0)
                    const SizedBox(width: 8),
                  if (completedCount > 0 && onViewUploaded != null)
                    Expanded(
                      child: AppButtonAtom(
                        text: 'View Uploaded',
                        onPressed: onViewUploaded,
                        icon: const Icon(Icons.check_circle, size: 18),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    int count,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          count.toString(),
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Model for upload item
class UploadItem {
  final String fileName;
  final double progress;
  final bool isComplete;
  final bool hasError;
  final String? errorMessage;

  const UploadItem({
    required this.fileName,
    required this.progress,
    this.isComplete = false,
    this.hasError = false,
    this.errorMessage,
  });
}

/// A simple upload status indicator molecule
class SimpleUploadStatusMolecule extends StatelessWidget {
  final int uploadingCount;
  final int completedCount;
  final int failedCount;
  final VoidCallback? onTap;

  const SimpleUploadStatusMolecule({
    super.key,
    required this.uploadingCount,
    required this.completedCount,
    required this.failedCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final totalCount = uploadingCount + completedCount + failedCount;

    if (totalCount == 0) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (uploadingCount > 0) ...[
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$uploadingCount uploading',
                style: theme.textTheme.bodySmall,
              ),
            ],
            if (completedCount > 0) ...[
              if (uploadingCount > 0) const SizedBox(width: 8),
              Icon(
                Icons.check_circle,
                size: 16,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                '$completedCount',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ],
            if (failedCount > 0) ...[
              if (uploadingCount > 0 || completedCount > 0)
                const SizedBox(width: 8),
              Icon(
                Icons.error,
                size: 16,
                color: colorScheme.error,
              ),
              const SizedBox(width: 4),
              Text(
                '$failedCount',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
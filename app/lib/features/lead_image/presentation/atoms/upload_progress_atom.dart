import 'package:flutter/material.dart';
import '../../../../core/widgets/atoms/app_progress_indicator_atom.dart';

/// An atom for displaying upload progress
/// Following atomic design principles - smallest UI component
class UploadProgressAtom extends StatelessWidget {
  final double progress;
  final String? fileName;
  final String? statusText;
  final VoidCallback? onCancel;
  final bool showPercentage;
  final bool compact;
  final Color? progressColor;

  const UploadProgressAtom({
    super.key,
    required this.progress,
    this.fileName,
    this.statusText,
    this.onCancel,
    this.showPercentage = true,
    this.compact = false,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompactProgress(context);
    }
    return _buildFullProgress(context);
  }

  Widget _buildCompactProgress(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final percentage = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: AppProgressIndicatorAtom.circular(
              value: progress,
              size: 24,
            ),
          ),
          const SizedBox(width: 8),
          if (showPercentage)
            Text(
              '$percentage%',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFullProgress(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final percentage = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (fileName != null || statusText != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (fileName != null)
                        Text(
                          fileName!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (statusText != null)
                        Text(
                          statusText!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                if (onCancel != null)
                  IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: colorScheme.error,
                      size: 20,
                    ),
                    onPressed: onCancel,
                    tooltip: 'Cancel upload',
                  ),
              ],
            ),
          if (fileName != null || statusText != null) const SizedBox(height: 12),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progressColor ?? colorScheme.primary,
                  ),
                ),
              ),
              if (showPercentage)
                Positioned.fill(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '$percentage%',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// An atom for showing multiple file upload progress
class MultiUploadProgressAtom extends StatelessWidget {
  final List<UploadProgressItem> items;
  final VoidCallback? onCancelAll;

  const MultiUploadProgressAtom({
    super.key,
    required this.items,
    this.onCancelAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final totalProgress = items.isEmpty
        ? 0.0
        : items.map((e) => e.progress).reduce((a, b) => a + b) / items.length;
    final percentage = (totalProgress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Uploading ${items.length} images',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (onCancelAll != null)
                TextButton(
                  onPressed: onCancelAll,
                  child: Text(
                    'Cancel All',
                    style: TextStyle(
                      color: colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: totalProgress,
            minHeight: 4,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
          const SizedBox(height: 4),
          Text(
            'Overall progress: $percentage%',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildItemProgress(context, item),
              )),
        ],
      ),
    );
  }

  Widget _buildItemProgress(BuildContext context, UploadProgressItem item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final percentage = (item.progress * 100).toInt();

    return Row(
      children: [
        Icon(
          item.isComplete
              ? Icons.check_circle
              : item.hasError
                  ? Icons.error
                  : Icons.upload_file,
          size: 16,
          color: item.isComplete
              ? colorScheme.primary
              : item.hasError
                  ? colorScheme.error
                  : colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.fileName,
                style: theme.textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              LinearProgressIndicator(
                value: item.progress,
                minHeight: 2,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  item.hasError
                      ? colorScheme.error
                      : item.isComplete
                          ? colorScheme.primary
                          : colorScheme.primary.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          item.hasError ? 'Failed' : '$percentage%',
          style: theme.textTheme.bodySmall?.copyWith(
            color: item.hasError
                ? colorScheme.error
                : colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// Model for upload progress item
class UploadProgressItem {
  final String fileName;
  final double progress;
  final bool isComplete;
  final bool hasError;
  final String? errorMessage;

  const UploadProgressItem({
    required this.fileName,
    required this.progress,
    this.isComplete = false,
    this.hasError = false,
    this.errorMessage,
  });
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/atoms/app_button_atom.dart';
import '../../../../core/widgets/atoms/app_progress_indicator_atom.dart';
import '../providers/upload_queue_providers.dart';
import '../providers/image_limit_providers.dart';

/// Widget for retrying failed uploads
class UploadRetryWidget extends ConsumerStatefulWidget {
  final String leadId;
  final String uploadId;
  final String? errorMessage;
  final VoidCallback onRetry;
  final VoidCallback onCancel;
  final double? progress;

  const UploadRetryWidget({
    super.key,
    required this.leadId,
    required this.uploadId,
    this.errorMessage,
    required this.onRetry,
    required this.onCancel,
    this.progress,
  });

  @override
  ConsumerState<UploadRetryWidget> createState() => _UploadRetryWidgetState();
}

class _UploadRetryWidgetState extends ConsumerState<UploadRetryWidget> {
  bool _isRetrying = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Watch upload queue state
    final failedUploads = ref.watch(failedUploadsProvider(widget.leadId));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isRetrying ? colorScheme.primary : colorScheme.error,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status icon
          Row(
            children: [
              _buildStatusIcon(colorScheme),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isRetrying ? (l10n?.retryingUpload ?? 'Retrying Upload') : (l10n?.uploadFailed ?? 'Upload Failed'),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _isRetrying ? colorScheme.primary : colorScheme.error,
                      ),
                    ),
                    if (widget.errorMessage != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.errorMessage!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress or retry options
          if (_isRetrying)
            _buildRetryingContent(l10n, colorScheme)
          else
            _buildRetryOptions(l10n, colorScheme),

          // Failed uploads summary
          if (failedUploads.isNotEmpty && !_isRetrying) ...[
            const SizedBox(height: 16),
            _buildFailedUploadsSummary(failedUploads, l10n, theme),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusIcon(ColorScheme colorScheme) {
    if (_isRetrying) {
      return Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          shape: BoxShape.circle,
        ),
        child: const AppProgressIndicatorAtom(size: 24),
      );
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.error_outline,
        color: colorScheme.error,
        size: 24,
      ),
    );
  }

  Widget _buildRetryingContent(
    AppLocalizations? l10n,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Progress bar
        if (widget.progress != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: widget.progress,
              minHeight: 8,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(widget.progress! * 100).toStringAsFixed(0)}%',
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ] else
          const AppProgressIndicatorAtom(),

        const SizedBox(height: 16),

        // Cancel button
        AppOutlinedButtonAtom(
          onPressed: () {
            setState(() => _isRetrying = false);
            widget.onCancel();
          },
          text: l10n?.cancelUpload ?? 'Cancel Upload',
        ),
      ],
    );
  }

  Widget _buildRetryOptions(
    AppLocalizations? l10n,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Expanded(
          child: AppOutlinedButtonAtom(
            onPressed: widget.onCancel,
            text: l10n?.cancel ?? 'Cancel',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppButtonAtom.primary(
            onPressed: () {
              setState(() => _isRetrying = true);
              widget.onRetry();
            },
            text: l10n?.retryUpload ?? 'Retry Upload',
            icon: Icons.refresh,
          ),
        ),
      ],
    );
  }

  Widget _buildFailedUploadsSummary(
    List<UploadQueueItem> failedUploads,
    AppLocalizations? l10n,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 16,
                color: theme.colorScheme.error,
              ),
              const SizedBox(width: 8),
              Text(
                l10n?.failedUploadsCount(failedUploads.length) ?? '${failedUploads.length} failed uploads',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => _retryAllFailed(),
            icon: const Icon(Icons.refresh, size: 16),
            label: Text(l10n?.retryAllFailed ?? 'Retry All Failed'),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
              padding: EdgeInsets.zero,
              minimumSize: const Size.fromHeight(32),
            ),
          ),
        ],
      ),
    );
  }

  void _retryAllFailed() {
    ref.read(uploadQueueManagerProvider(widget.leadId).notifier).retryFailed();
  }
}
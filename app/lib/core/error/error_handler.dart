import 'package:flutter/material.dart';
import '../utils/app_logger.dart';
import '../../l10n/app_localizations.dart';

/// Global error handler for the application
class ErrorHandler {
  static final ErrorHandler _instance = ErrorHandler._internal();
  factory ErrorHandler() => _instance;
  ErrorHandler._internal();

  /// Handle error and show appropriate UI feedback
  static Future<void> handleError({
    required BuildContext context,
    required dynamic error,
    StackTrace? stackTrace,
    String? customMessage,
    VoidCallback? onRetry,
    bool showErrorDialog = true,
  }) async {
    // Log error
    AppLogger.error(
      customMessage ?? 'An error occurred',
      error,
      stackTrace,
    );

    if (!showErrorDialog) return;

    // Determine error type and message
    final errorMessage = _getErrorMessage(context, error, customMessage);
    final canRetry = onRetry != null;

    // Show error dialog
    return showDialog<void>(
      context: context,
      barrierDismissible: !canRetry,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)?.error ?? 'Error',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
          content: Text(errorMessage),
          actions: [
            if (!canRetry)
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(AppLocalizations.of(context)?.close ?? 'Close'),
              ),
            if (canRetry) ...[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  onRetry();
                },
                child: Text(AppLocalizations.of(context)?.retry ?? 'Retry'),
              ),
            ],
          ],
        );
      },
    );
  }

  /// Get user-friendly error message
  static String _getErrorMessage(
    BuildContext context,
    dynamic error,
    String? customMessage,
  ) {
    if (customMessage != null) return customMessage;

    final l10n = AppLocalizations.of(context);

    // Check for specific error types
    if (error is ImageLimitException) {
      return l10n?.cancel ?? 'Image limit reached';
    }

    if (error is ImageSizeException) {
      return l10n?.cancel ?? 'Image too large';
    }

    if (error is NetworkException) {
      return l10n?.cancel ?? 'Network error';
    }

    if (error is UploadFailedException) {
      return l10n?.cancel ?? 'Upload failed';
    }

    // Default error message
    return l10n?.cancel ?? 'An error occurred';
  }

  /// Show error snackbar for non-critical errors
  static void showErrorSnackbar({
    required BuildContext context,
    required String message,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Theme.of(context).colorScheme.error,
      action: onAction != null && actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: Theme.of(context).colorScheme.onError,
              onPressed: onAction,
            )
          : null,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  /// Show success snackbar
  static void showSuccessSnackbar({
    required BuildContext context,
    required String message,
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

/// Custom exception types
class ImageLimitException implements Exception {
  final String message;
  final int currentCount;
  final int maxCount;

  ImageLimitException({
    required this.message,
    required this.currentCount,
    required this.maxCount,
  });
}

class ImageSizeException implements Exception {
  final String message;
  final int actualSize;
  final int maxSize;

  ImageSizeException({
    required this.message,
    required this.actualSize,
    required this.maxSize,
  });
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class UploadFailedException implements Exception {
  final String message;
  final String? imageId;

  UploadFailedException({
    required this.message,
    this.imageId,
  });
}
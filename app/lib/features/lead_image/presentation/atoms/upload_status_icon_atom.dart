import 'package:flutter/material.dart';
import '../organisms/image_upload_queue_organism.dart';

/// An atom for upload status icon
/// Following atomic design principles
class UploadStatusIconAtom extends StatelessWidget {
  final UploadStatus status;
  final double size;

  const UploadStatusIconAtom({
    super.key,
    required this.status,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    IconData icon;
    Color color;

    switch (status) {
      case UploadStatus.pending:
        icon = Icons.schedule;
        color = colorScheme.onSurfaceVariant;
        break;
      case UploadStatus.uploading:
        icon = Icons.cloud_upload;
        color = colorScheme.primary;
        break;
      case UploadStatus.completed:
        icon = Icons.check_circle;
        color = colorScheme.primary;
        break;
      case UploadStatus.failed:
        icon = Icons.error;
        color = colorScheme.error;
        break;
      case UploadStatus.cancelled:
        icon = Icons.cancel;
        color = colorScheme.tertiary;
        break;
    }

    return Icon(icon, color: color, size: size);
  }
}
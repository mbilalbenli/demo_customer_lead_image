import 'package:flutter/material.dart';
import '../../domain/entities/upload_queue_item_entity.dart';

class UploadStatusBadgeAtom extends StatelessWidget {
  final UploadStatus status;
  const UploadStatusBadgeAtom({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    switch (status) {
      case UploadStatus.uploading:
        icon = Icons.cloud_upload; color = Colors.blue; break;
      case UploadStatus.complete:
        icon = Icons.check_circle; color = Colors.green; break;
      case UploadStatus.failed:
        icon = Icons.error; color = Colors.red; break;
      case UploadStatus.paused:
        icon = Icons.pause_circle; color = Colors.orange; break;
      case UploadStatus.ready:
        icon = Icons.hourglass_empty; color = Colors.grey; break;
    }
    return Icon(icon, color: color, size: 18);
  }
}

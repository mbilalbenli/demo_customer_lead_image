import 'package:flutter/material.dart';
import '../atoms/upload_queue_item_thumbnail_atom.dart';
import '../atoms/upload_status_badge_atom.dart';
import '../atoms/file_size_text_atom.dart';
import '../../domain/entities/upload_queue_item_entity.dart';

class UploadQueueItemMolecule extends StatelessWidget {
  final UploadQueueItemEntity item;
  final VoidCallback onRemove;
  const UploadQueueItemMolecule({super.key, required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UploadQueueItemThumbnailAtom(fileName: item.fileName),
      title: Text(item.fileName, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Row(children: [UploadStatusBadgeAtom(status: item.status), const SizedBox(width: 8), FileSizeTextAtom(sizeBytes: item.sizeBytes)]),
      trailing: IconButton(icon: const Icon(Icons.close), onPressed: onRemove),
    );
  }
}


import 'package:flutter/material.dart';

class UploadQueueItemThumbnailAtom extends StatelessWidget {
  final String fileName;
  const UploadQueueItemThumbnailAtom({super.key, required this.fileName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.photo, size: 24),
    );
  }
}


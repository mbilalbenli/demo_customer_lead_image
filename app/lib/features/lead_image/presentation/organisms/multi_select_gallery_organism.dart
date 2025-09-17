import 'package:flutter/material.dart';

class MultiSelectGalleryOrganism extends StatelessWidget {
  final VoidCallback onPick;
  const MultiSelectGalleryOrganism({super.key, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton.icon(
        onPressed: onPick,
        icon: const Icon(Icons.photo_library),
        label: const Text('Select Images'),
      ),
    );
  }
}


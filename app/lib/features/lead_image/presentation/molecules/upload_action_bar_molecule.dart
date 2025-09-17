import 'package:flutter/material.dart';

class UploadActionBarMolecule extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback onClear;
  final bool enabled;
  const UploadActionBarMolecule({super.key, required this.onStart, required this.onClear, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: enabled ? onStart : null,
            icon: const Icon(Icons.cloud_upload),
            label: const Text('Start Upload'),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(onPressed: enabled ? onClear : null, icon: const Icon(Icons.delete_outline), tooltip: 'Clear queue')
      ],
    );
  }
}


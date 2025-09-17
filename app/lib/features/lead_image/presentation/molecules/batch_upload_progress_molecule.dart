import 'package:flutter/material.dart';

class BatchUploadProgressMolecule extends StatelessWidget {
  final double progress;
  const BatchUploadProgressMolecule({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(value: progress == 0 ? null : progress),
        const SizedBox(height: 8),
        Text('${(progress * 100).round()}%'),
      ],
    );
  }
}


import 'package:flutter/material.dart';

class CompressionSettingsDialog extends StatefulWidget {
  final int initialQuality;
  const CompressionSettingsDialog({super.key, this.initialQuality = 85});
  @override
  State<CompressionSettingsDialog> createState() => _CompressionSettingsDialogState();
}

class _CompressionSettingsDialogState extends State<CompressionSettingsDialog> {
  late double _quality;
  @override
  void initState() {
    super.initState();
    _quality = widget.initialQuality.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Compression Settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Quality'),
          Slider(value: _quality, min: 10, max: 100, divisions: 9, label: _quality.round().toString(), onChanged: (v) => setState(() => _quality = v)),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(context, _quality.round()), child: const Text('Apply')),
      ],
    );
  }
}


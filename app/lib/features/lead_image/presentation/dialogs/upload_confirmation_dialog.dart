import 'package:flutter/material.dart';

class UploadConfirmationDialog extends StatelessWidget {
  final int count;
  const UploadConfirmationDialog({super.key, required this.count});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Upload'),
      content: Text('Upload $count image(s)?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Upload')),
      ],
    );
  }
}


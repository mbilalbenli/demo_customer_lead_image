import 'package:flutter/material.dart';

class UploadSuccessDialogOrganism extends StatelessWidget {
  final int count;
  const UploadSuccessDialogOrganism({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.check_circle, color: Colors.green),
      title: const Text('Upload Complete'),
      content: Text('$count image(s) uploaded successfully'),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
      ],
    );
  }
}


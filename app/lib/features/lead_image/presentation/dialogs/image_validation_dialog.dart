import 'package:flutter/material.dart';

class ImageValidationDialog extends StatelessWidget {
  final List<String> errors;
  const ImageValidationDialog({super.key, required this.errors});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Validation Issues'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: errors.map((e) => Align(alignment: Alignment.centerLeft, child: Text('• $e'))).toList(),
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
    );
  }
}


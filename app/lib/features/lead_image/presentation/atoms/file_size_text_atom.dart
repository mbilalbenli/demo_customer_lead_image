import 'package:flutter/material.dart';

class FileSizeTextAtom extends StatelessWidget {
  final int sizeBytes;
  const FileSizeTextAtom({super.key, required this.sizeBytes});
  @override
  Widget build(BuildContext context) {
    final kb = (sizeBytes / 1024).toStringAsFixed(1);
    return Text('$kb KB', style: Theme.of(context).textTheme.bodySmall);
  }
}


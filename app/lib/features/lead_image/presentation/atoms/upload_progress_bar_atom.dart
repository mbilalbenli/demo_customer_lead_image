import 'package:flutter/material.dart';

class UploadProgressBarAtom extends StatelessWidget {
  final double value; // 0.0 - 1.0
  const UploadProgressBarAtom({super.key, required this.value});
  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(value: value);
  }
}


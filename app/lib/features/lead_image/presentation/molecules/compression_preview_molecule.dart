import 'package:flutter/material.dart';

class CompressionPreviewMolecule extends StatelessWidget {
  final int originalBytes;
  final int compressedBytes;
  const CompressionPreviewMolecule({super.key, required this.originalBytes, required this.compressedBytes});
  @override
  Widget build(BuildContext context) {
    final savings = originalBytes == 0 ? 0 : (100 - (compressedBytes / originalBytes * 100)).round();
    return Text('Compression savings: $savings%');
  }
}


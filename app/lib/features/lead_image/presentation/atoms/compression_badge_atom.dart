import 'package:flutter/material.dart';

class CompressionBadgeAtom extends StatelessWidget {
  final int originalBytes;
  final int compressedBytes;
  const CompressionBadgeAtom({super.key, required this.originalBytes, required this.compressedBytes});

  @override
  Widget build(BuildContext context) {
    if (compressedBytes >= originalBytes) return const SizedBox.shrink();
    final savings = (100 - (compressedBytes / originalBytes * 100)).round();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text('-$savings%', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
    );
  }
}

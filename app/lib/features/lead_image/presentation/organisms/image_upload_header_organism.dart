import 'package:flutter/material.dart';
import '../molecules/image_limit_status_molecule.dart';

class ImageUploadHeaderOrganism extends StatelessWidget {
  final int current;
  final int max;
  const ImageUploadHeaderOrganism({super.key, required this.current, required this.max});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: ImageLimitStatusMolecule(current: current, max: max),
    );
  }
}

import 'package:flutter/material.dart';
import '../atoms/limit_indicator_bar_atom.dart';

class ImageLimitStatusMolecule extends StatelessWidget {
  final int current;
  final int max;
  const ImageLimitStatusMolecule({super.key, required this.current, required this.max});

  @override
  Widget build(BuildContext context) {
    final isAtLimit = current >= max;
    return Column(
      children: [
        Text(isAtLimit ? 'Storage Full' : '${max - current} slots available',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: isAtLimit ? Theme.of(context).colorScheme.error : null)),
        const SizedBox(height: 8),
        LimitIndicatorBarAtom(current: current, max: max),
      ],
    );
  }
}


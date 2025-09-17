import 'package:flutter/material.dart';

class LimitIndicatorBarAtom extends StatelessWidget {
  final int current;
  final int max;
  const LimitIndicatorBarAtom({super.key, required this.current, required this.max});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(max, (i) => Container(
        width: 8,
        height: 8,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: i < current ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
      )),
    );
  }
}


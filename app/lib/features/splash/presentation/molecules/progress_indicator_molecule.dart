import 'package:flutter/material.dart';
import '../atoms/progress_dot_atom.dart';

class ProgressIndicatorMolecule extends StatelessWidget {
  final int totalSteps;
  final int completedSteps;
  final Color activeColor;
  final Color inactiveColor;

  const ProgressIndicatorMolecule({
    super.key,
    required this.totalSteps,
    required this.completedSteps,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalSteps, (index) {
        return ProgressDotAtom(
          isActive: index < completedSteps,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          animationDuration: Duration(milliseconds: 300 + (index * 100)),
        );
      }),
    );
  }
}
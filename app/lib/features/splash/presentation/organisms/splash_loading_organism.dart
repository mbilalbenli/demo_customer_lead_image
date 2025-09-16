import 'package:flutter/material.dart';
import '../atoms/loading_indicator_atom.dart';
import '../atoms/loading_text_atom.dart';
import '../molecules/progress_indicator_molecule.dart';

class SplashLoadingOrganism extends StatelessWidget {
  final String loadingMessage;
  final int totalSteps;
  final int completedSteps;
  final Color primaryColor;
  final Color secondaryColor;
  final TextStyle? textStyle;

  const SplashLoadingOrganism({
    super.key,
    required this.loadingMessage,
    required this.totalSteps,
    required this.completedSteps,
    required this.primaryColor,
    required this.secondaryColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LoadingIndicatorAtom(
          primaryColor: primaryColor,
          secondaryColor: secondaryColor.withValues(alpha: 0.3),
        ),
        const SizedBox(height: 40),
        LoadingTextAtom(
          text: loadingMessage,
          style: textStyle,
        ),
        const SizedBox(height: 16),
        ProgressIndicatorMolecule(
          totalSteps: totalSteps,
          completedSteps: completedSteps,
          activeColor: primaryColor,
          inactiveColor: primaryColor.withValues(alpha: 0.2),
        ),
      ],
    );
  }
}
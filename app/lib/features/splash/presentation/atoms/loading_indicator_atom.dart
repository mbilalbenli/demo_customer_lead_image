import 'package:flutter/material.dart';

class LoadingIndicatorAtom extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final double size;
  final double strokeWidth;

  const LoadingIndicatorAtom({
    super.key,
    required this.primaryColor,
    required this.secondaryColor,
    this.size = 80,
    this.strokeWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: strokeWidth,
            color: primaryColor,
          ),
          CircularProgressIndicator(
            strokeWidth: strokeWidth - 1,
            color: secondaryColor,
            value: null,
          ),
        ],
      ),
    );
  }
}
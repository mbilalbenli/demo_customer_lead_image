import 'package:flutter/material.dart';

class ProgressDotAtom extends StatelessWidget {
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final double size;
  final Duration animationDuration;

  const ProgressDotAtom({
    super.key,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    this.size = 8,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: animationDuration,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? activeColor : inactiveColor,
      ),
    );
  }
}
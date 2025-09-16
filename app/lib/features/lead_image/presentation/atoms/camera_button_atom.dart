import 'package:flutter/material.dart';

/// An atom for camera capture button
/// Following atomic design principles
class CameraButtonAtom extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isDisabled;
  final bool isCapturing;
  final double size;

  const CameraButtonAtom({
    super.key,
    this.onPressed,
    this.isDisabled = false,
    this.isCapturing = false,
    this.size = 70,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: isDisabled || isCapturing ? null : onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isDisabled
                ? Colors.white30
                : isCapturing
                    ? colorScheme.error
                    : Colors.white,
            width: 3,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDisabled
                ? Colors.white30
                : isCapturing
                    ? colorScheme.error
                    : Colors.white,
          ),
        ),
      ),
    );
  }
}
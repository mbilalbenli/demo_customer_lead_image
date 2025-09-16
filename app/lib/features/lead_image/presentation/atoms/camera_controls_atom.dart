import 'package:flutter/material.dart';

/// An atom for camera control buttons
/// Following atomic design principles
class CameraControlsAtom extends StatelessWidget {
  final bool flashEnabled;
  final bool frontCamera;
  final VoidCallback? onFlashToggle;
  final VoidCallback? onCameraSwitch;

  const CameraControlsAtom({
    super.key,
    this.flashEnabled = false,
    this.frontCamera = false,
    this.onFlashToggle,
    this.onCameraSwitch,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onFlashToggle,
          icon: Icon(
            flashEnabled ? Icons.flash_on : Icons.flash_off,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 16),
        IconButton(
          onPressed: onCameraSwitch,
          icon: Icon(
            frontCamera ? Icons.camera_front : Icons.camera_rear,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
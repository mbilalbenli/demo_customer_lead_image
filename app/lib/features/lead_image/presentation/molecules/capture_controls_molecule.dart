import 'package:flutter/material.dart';
import '../atoms/camera_button_atom.dart';

/// A molecule for camera capture controls
/// Following atomic design principles - composed from atoms
class CaptureControlsMolecule extends StatelessWidget {
  final bool isCapturing;
  final bool isProcessing;
  final bool isDisabled;
  final bool flashEnabled;
  final bool frontCamera;
  final VoidCallback? onCapture;
  final VoidCallback? onGalleryPick;
  final VoidCallback? onFlashToggle;
  final VoidCallback? onCameraSwitch;
  final int currentCount;
  final int maxCount;

  const CaptureControlsMolecule({
    super.key,
    this.isCapturing = false,
    this.isProcessing = false,
    this.isDisabled = false,
    this.flashEnabled = false,
    this.frontCamera = false,
    this.onCapture,
    this.onGalleryPick,
    this.onFlashToggle,
    this.onCameraSwitch,
    required this.currentCount,
    this.maxCount = 10,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Gallery button
          IconButton(
            onPressed: isDisabled || isProcessing ? null : onGalleryPick,
            icon: const Icon(Icons.photo_library),
            color: Colors.white,
            iconSize: 32,
          ),
          // Capture button
          CameraButtonAtom(
            onPressed: isDisabled || isProcessing || isCapturing
                ? null
                : onCapture,
            isDisabled: isDisabled,
            isCapturing: isCapturing,
          ),
          // Settings menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings, color: Colors.white, size: 32),
            enabled: !isProcessing && !isCapturing,
            color: colorScheme.surface,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'flash',
                child: Row(
                  children: [
                    Icon(
                      flashEnabled ? Icons.flash_on : Icons.flash_off,
                      color: colorScheme.onSurface,
                    ),
                    const SizedBox(width: 8),
                    Text(flashEnabled ? 'Flash On' : 'Flash Off'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'camera',
                child: Row(
                  children: [
                    Icon(
                      frontCamera ? Icons.camera_front : Icons.camera_rear,
                      color: colorScheme.onSurface,
                    ),
                    const SizedBox(width: 8),
                    Text(frontCamera ? 'Front Camera' : 'Rear Camera'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'flash':
                  onFlashToggle?.call();
                  break;
                case 'camera':
                  onCameraSwitch?.call();
                  break;
              }
            },
          ),
        ],
      ),
    );
  }
}
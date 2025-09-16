import 'package:flutter/material.dart';
import '../../../../core/widgets/molecules/app_loading_overlay_molecule.dart';

/// A molecule for showing camera capture preview
/// Following atomic design principles - composed from atoms
class CapturePreviewMolecule extends StatelessWidget {
  final String imageData;
  final bool isProcessing;

  const CapturePreviewMolecule({
    super.key,
    required this.imageData,
    this.isProcessing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Preview image
        Container(
          color: Colors.black,
          child: Center(
            child: Container(
              color: Colors.grey[900],
              child: const Icon(
                Icons.image,
                size: 100,
                color: Colors.white30,
              ),
            ),
          ),
        ),
        // Processing overlay
        if (isProcessing)
          const AppFullScreenLoadingMolecule(
            message: 'Processing image...',
            backgroundColor: Colors.transparent,
          ),
      ],
    );
  }
}
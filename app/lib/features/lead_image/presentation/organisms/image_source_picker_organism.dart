import 'package:flutter/material.dart';
import '../molecules/upload_source_selector_molecule.dart';

class ImageSourcePickerOrganism extends StatelessWidget {
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback? onFiles;
  const ImageSourcePickerOrganism({super.key, required this.onCamera, required this.onGallery, this.onFiles});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: UploadSourceSelectorMolecule(onCamera: onCamera, onGallery: onGallery, onFiles: onFiles),
      ),
    );
  }
}


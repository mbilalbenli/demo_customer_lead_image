import 'package:flutter/material.dart';
import '../atoms/upload_source_button_atom.dart';

class UploadSourceSelectorMolecule extends StatelessWidget {
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback? onFiles;
  const UploadSourceSelectorMolecule({super.key, required this.onCamera, required this.onGallery, this.onFiles});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: UploadSourceButtonAtom(icon: Icons.camera_alt, label: 'Camera', onTap: onCamera)),
        const SizedBox(width: 12),
        Expanded(child: UploadSourceButtonAtom(icon: Icons.photo_library, label: 'Gallery', onTap: onGallery)),
        if (onFiles != null) ...[
          const SizedBox(width: 12),
          Expanded(child: UploadSourceButtonAtom(icon: Icons.folder, label: 'Files', onTap: onFiles!)),
        ]
      ],
    );
  }
}


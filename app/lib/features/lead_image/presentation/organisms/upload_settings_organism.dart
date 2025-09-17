import 'package:flutter/material.dart';
import '../../domain/entities/upload_options_entity.dart';
import '../molecules/upload_options_panel_molecule.dart';

class UploadSettingsOrganism extends StatelessWidget {
  final UploadOptionsEntity options;
  final ValueChanged<UploadOptionsEntity> onChanged;
  const UploadSettingsOrganism({super.key, required this.options, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: UploadOptionsPanelMolecule(options: options, onChanged: onChanged),
      ),
    );
  }
}


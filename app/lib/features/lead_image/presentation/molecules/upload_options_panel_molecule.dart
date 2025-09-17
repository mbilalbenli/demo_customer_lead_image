import 'package:flutter/material.dart';
import '../atoms/checkbox_setting_atom.dart';
import '../../domain/entities/upload_options_entity.dart';

class UploadOptionsPanelMolecule extends StatelessWidget {
  final UploadOptionsEntity options;
  final ValueChanged<UploadOptionsEntity> onChanged;
  const UploadOptionsPanelMolecule({super.key, required this.options, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxSettingAtom(
          value: options.compress,
          label: 'Compress Images',
          onChanged: (v) => onChanged(options.copyWith(compress: v)),
        ),
        CheckboxSettingAtom(
          value: options.addWatermark,
          label: 'Add Watermark',
          onChanged: (v) => onChanged(options.copyWith(addWatermark: v)),
        ),
        CheckboxSettingAtom(
          value: options.backgroundUpload,
          label: 'Upload in Background',
          onChanged: (v) => onChanged(options.copyWith(backgroundUpload: v)),
        ),
      ],
    );
  }
}


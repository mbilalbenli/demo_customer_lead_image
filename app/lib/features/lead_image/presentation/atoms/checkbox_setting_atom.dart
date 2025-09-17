import 'package:flutter/material.dart';

class CheckboxSettingAtom extends StatelessWidget {
  final bool value;
  final String label;
  final ValueChanged<bool> onChanged;
  const CheckboxSettingAtom({super.key, required this.value, required this.label, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: (v) => onChanged(v ?? false),
      title: Text(label),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }
}


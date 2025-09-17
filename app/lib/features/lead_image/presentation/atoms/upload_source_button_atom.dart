import 'package:flutter/material.dart';

class UploadSourceButtonAtom extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const UploadSourceButtonAtom({super.key, required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}


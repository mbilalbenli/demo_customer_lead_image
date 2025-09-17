import 'package:flutter/material.dart';

class UploadControlButtonAtom extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const UploadControlButtonAtom({super.key, required this.icon, required this.tooltip, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPressed, icon: Icon(icon), tooltip: tooltip);
  }
}


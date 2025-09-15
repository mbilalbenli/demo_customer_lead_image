import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 72});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.monitor_heart, size: size, color: Theme.of(context).colorScheme.primary);
  }
}


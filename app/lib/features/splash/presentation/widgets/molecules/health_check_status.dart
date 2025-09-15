import 'package:flutter/material.dart';

class HealthCheckStatus extends StatelessWidget {
  final String label;
  final bool done;
  final bool ok;
  const HealthCheckStatus({super.key, required this.label, required this.done, required this.ok});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    IconData icon;
    Color color;
    if (!done) {
      icon = Icons.hourglass_top;
      color = colorScheme.primary;
    } else if (ok) {
      icon = Icons.check_circle;
      color = Colors.green;
    } else {
      icon = Icons.cancel;
      color = colorScheme.error;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}


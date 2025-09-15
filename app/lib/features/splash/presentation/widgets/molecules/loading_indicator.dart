import 'package:flutter/material.dart';
import '../atoms/loading_spinner.dart';
import '../atoms/status_text.dart';

class LoadingIndicator extends StatelessWidget {
  final String message;
  const LoadingIndicator({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const LoadingSpinner(),
        const SizedBox(height: 12),
        StatusText(message),
      ],
    );
  }
}


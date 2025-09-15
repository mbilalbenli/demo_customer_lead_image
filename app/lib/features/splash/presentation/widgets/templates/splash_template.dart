import 'package:flutter/material.dart';
import '../organisms/splash_content.dart';

class SplashTemplate extends StatelessWidget {
  final SplashContent content;
  const SplashTemplate({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).colorScheme.surface,
        child: content,
      ),
    );
  }
}

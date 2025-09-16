import 'package:flutter/material.dart';

class LoadingTextAtom extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Duration animationDuration;

  const LoadingTextAtom({
    super.key,
    required this.text,
    this.style,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: animationDuration,
      child: Text(
        text,
        key: ValueKey(text),
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }
}
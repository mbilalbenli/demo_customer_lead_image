import 'package:flutter/material.dart';

class StatusText extends StatelessWidget {
  final String text;
  const StatusText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, textAlign: TextAlign.center);
  }
}


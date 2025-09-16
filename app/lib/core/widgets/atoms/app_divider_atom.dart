import 'package:flutter/material.dart';
import 'dart:math' as dart_math;

/// A reusable divider atom for separating content
/// Following atomic design principles - this is the smallest divider component
class AppDividerAtom extends StatelessWidget {
  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;
  final DividerType type;

  const AppDividerAtom({
    super.key,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
    this.type = DividerType.horizontal,
  });

  /// Factory constructor for a subtle divider
  factory AppDividerAtom.subtle({
    Key? key,
    double? indent,
    double? endIndent,
    DividerType type = DividerType.horizontal,
  }) {
    return AppDividerAtom(
      key: key,
      thickness: 0.5,
      indent: indent,
      endIndent: endIndent,
      type: type,
    );
  }

  /// Factory constructor for a thick divider
  factory AppDividerAtom.thick({
    Key? key,
    double? indent,
    double? endIndent,
    Color? color,
    DividerType type = DividerType.horizontal,
  }) {
    return AppDividerAtom(
      key: key,
      thickness: 2,
      indent: indent,
      endIndent: endIndent,
      color: color,
      type: type,
    );
  }

  /// Factory constructor for a section divider
  factory AppDividerAtom.section({
    Key? key,
    double? height,
    DividerType type = DividerType.horizontal,
  }) {
    return AppDividerAtom(
      key: key,
      height: height ?? 32,
      thickness: 1,
      type: type,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveColor = color ?? colorScheme.outlineVariant;

    if (type == DividerType.vertical) {
      return VerticalDivider(
        width: height,
        thickness: thickness,
        indent: indent,
        endIndent: endIndent,
        color: effectiveColor,
      );
    }

    return Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: effectiveColor,
    );
  }
}

enum DividerType {
  horizontal,
  vertical,
}

/// A divider with a label in the middle
class AppLabeledDividerAtom extends StatelessWidget {
  final String label;
  final TextStyle? labelStyle;
  final Color? dividerColor;
  final double? thickness;
  final EdgeInsets? padding;
  final MainAxisAlignment alignment;

  const AppLabeledDividerAtom({
    super.key,
    required this.label,
    this.labelStyle,
    this.dividerColor,
    this.thickness,
    this.padding,
    this.alignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveLabelStyle = labelStyle ??
        TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        );

    final effectivePadding = padding ?? const EdgeInsets.symmetric(horizontal: 16);

    return Row(
      mainAxisAlignment: alignment,
      children: [
        if (alignment != MainAxisAlignment.start)
          Expanded(
            child: AppDividerAtom(
              color: dividerColor,
              thickness: thickness,
            ),
          ),
        Padding(
          padding: effectivePadding,
          child: Text(
            label,
            style: effectiveLabelStyle,
          ),
        ),
        if (alignment != MainAxisAlignment.end)
          Expanded(
            child: AppDividerAtom(
              color: dividerColor,
              thickness: thickness,
            ),
          ),
      ],
    );
  }
}

/// A decorative divider with patterns
class AppDecorativeDividerAtom extends StatelessWidget {
  final DividerDecoration decoration;
  final Color? color;
  final double height;
  final double? indent;
  final double? endIndent;

  const AppDecorativeDividerAtom({
    super.key,
    this.decoration = DividerDecoration.dots,
    this.color,
    this.height = 20,
    this.indent,
    this.endIndent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveColor = color ?? colorScheme.outlineVariant;

    return Container(
      height: height,
      margin: EdgeInsets.only(
        left: indent ?? 0,
        right: endIndent ?? 0,
      ),
      child: CustomPaint(
        painter: _DecorativeDividerPainter(
          decoration: decoration,
          color: effectiveColor,
        ),
      ),
    );
  }
}

enum DividerDecoration {
  dots,
  dashes,
  wave,
}

class _DecorativeDividerPainter extends CustomPainter {
  final DividerDecoration decoration;
  final Color color;

  _DecorativeDividerPainter({
    required this.decoration,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5;

    switch (decoration) {
      case DividerDecoration.dots:
        _drawDots(canvas, size, paint);
        break;
      case DividerDecoration.dashes:
        _drawDashes(canvas, size, paint);
        break;
      case DividerDecoration.wave:
        _drawWave(canvas, size, paint);
        break;
    }
  }

  void _drawDots(Canvas canvas, Size size, Paint paint) {
    final dotRadius = 2.0;
    final spacing = 10.0;
    final y = size.height / 2;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawCircle(Offset(x, y), dotRadius, paint);
    }
  }

  void _drawDashes(Canvas canvas, Size size, Paint paint) {
    final dashWidth = 5.0;
    final dashSpace = 5.0;
    final y = size.height / 2;

    for (double x = 0; x < size.width; x += dashWidth + dashSpace) {
      canvas.drawLine(
        Offset(x, y),
        Offset(x + dashWidth, y),
        paint,
      );
    }
  }

  void _drawWave(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final amplitude = 5.0;
    final wavelength = 20.0;
    final y = size.height / 2;

    path.moveTo(0, y);

    for (double x = 0; x <= size.width; x++) {
      final phase = (x / wavelength) * 2 * 3.14159;
      final waveY = y + amplitude * (phase.sin);
      path.lineTo(x, waveY);
    }

    paint.style = PaintingStyle.stroke;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

extension on double {
  double get sin => dart_math.sin(this);
}
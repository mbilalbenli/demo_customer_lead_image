import 'package:flutter/material.dart';

/// A reusable progress indicator atom with various styles
/// Following atomic design principles - this is the smallest progress component
class AppProgressIndicatorAtom extends StatelessWidget {
  final double? value;
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final ProgressIndicatorType type;
  final String? label;
  final bool showPercentage;

  const AppProgressIndicatorAtom({
    super.key,
    this.value,
    this.size = 24,
    this.strokeWidth = 2,
    this.color,
    this.backgroundColor,
    this.type = ProgressIndicatorType.circular,
    this.label,
    this.showPercentage = false,
  });

  /// Factory constructor for loading indicator
  factory AppProgressIndicatorAtom.loading({
    Key? key,
    double size = 24,
    Color? color,
    ProgressIndicatorType type = ProgressIndicatorType.circular,
  }) {
    return AppProgressIndicatorAtom(
      key: key,
      size: size,
      color: color,
      type: type,
    );
  }

  /// Factory constructor for progress with percentage
  factory AppProgressIndicatorAtom.withPercentage({
    Key? key,
    required double value,
    double size = 48,
    Color? color,
    Color? backgroundColor,
  }) {
    return AppProgressIndicatorAtom(
      key: key,
      value: value,
      size: size,
      color: color,
      backgroundColor: backgroundColor,
      type: ProgressIndicatorType.circular,
      showPercentage: true,
    );
  }

  /// Factory constructor for linear progress
  factory AppProgressIndicatorAtom.linear({
    Key? key,
    double? value,
    Color? color,
    Color? backgroundColor,
    String? label,
  }) {
    return AppProgressIndicatorAtom(
      key: key,
      value: value,
      color: color,
      backgroundColor: backgroundColor,
      type: ProgressIndicatorType.linear,
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveColor = color ?? colorScheme.primary;
    final effectiveBackgroundColor = backgroundColor ?? colorScheme.surfaceContainerHighest;

    switch (type) {
      case ProgressIndicatorType.circular:
        return _buildCircular(effectiveColor, effectiveBackgroundColor);
      case ProgressIndicatorType.linear:
        return _buildLinear(effectiveColor, effectiveBackgroundColor);
      case ProgressIndicatorType.dots:
        return _buildDots(effectiveColor);
    }
  }

  Widget _buildCircular(Color color, Color backgroundColor) {
    Widget indicator = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(color),
        backgroundColor: value != null ? backgroundColor : null,
      ),
    );

    if (showPercentage && value != null) {
      final percentage = (value! * 100).round();
      indicator = Stack(
        alignment: Alignment.center,
        children: [
          indicator,
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: size * 0.25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    if (label != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          indicator,
          const SizedBox(height: 8),
          Text(
            label!,
            style: TextStyle(fontSize: 12),
          ),
        ],
      );
    }

    return indicator;
  }

  Widget _buildLinear(Color color, Color backgroundColor) {
    Widget indicator = LinearProgressIndicator(
      value: value,
      valueColor: AlwaysStoppedAnimation<Color>(color),
      backgroundColor: backgroundColor,
      minHeight: strokeWidth * 2,
    );

    if (label != null || (showPercentage && value != null)) {
      final percentage = value != null ? (value! * 100).round() : 0;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null || showPercentage)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (label != null)
                  Text(
                    label!,
                    style: TextStyle(fontSize: 12),
                  ),
                if (showPercentage && value != null)
                  Text(
                    '$percentage%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          if (label != null || showPercentage) const SizedBox(height: 4),
          indicator,
        ],
      );
    }

    return indicator;
  }

  Widget _buildDots(Color color) {
    return AppDotsProgressIndicator(
      size: size,
      color: color,
    );
  }
}

enum ProgressIndicatorType {
  circular,
  linear,
  dots,
}

/// Animated dots progress indicator
class AppDotsProgressIndicator extends StatefulWidget {
  final double size;
  final Color color;
  final int dotCount;
  final Duration animationDuration;

  const AppDotsProgressIndicator({
    super.key,
    this.size = 24,
    required this.color,
    this.dotCount = 3,
    this.animationDuration = const Duration(milliseconds: 1000),
  });

  @override
  State<AppDotsProgressIndicator> createState() => _AppDotsProgressIndicatorState();
}

class _AppDotsProgressIndicatorState extends State<AppDotsProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..repeat();

    _animations = List.generate(widget.dotCount, (index) {
      final start = index / widget.dotCount;
      final end = (index + 0.5) / widget.dotCount;
      return Tween<double>(
        begin: 0.5,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeInOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.dotCount, (index) {
            final dotSize = widget.size / 3;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: dotSize / 4),
              child: Transform.scale(
                scale: _animations[index].value,
                child: Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: _animations[index].value),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// Step progress indicator for multi-step processes
class AppStepProgressIndicatorAtom extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? size;
  final bool showLabels;
  final List<String>? labels;

  const AppStepProgressIndicatorAtom({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.activeColor,
    this.inactiveColor,
    this.size,
    this.showLabels = false,
    this.labels,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveActiveColor = activeColor ?? colorScheme.primary;
    final effectiveInactiveColor = inactiveColor ?? colorScheme.surfaceContainerHighest;
    final effectiveSize = size ?? 8;

    return Row(
      children: List.generate(totalSteps, (index) {
        final isActive = index <= currentStep;
        final isLast = index == totalSteps - 1;

        return Expanded(
          child: Row(
            children: [
              Container(
                width: effectiveSize,
                height: effectiveSize,
                decoration: BoxDecoration(
                  color: isActive ? effectiveActiveColor : effectiveInactiveColor,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2,
                    color: isActive ? effectiveActiveColor : effectiveInactiveColor,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
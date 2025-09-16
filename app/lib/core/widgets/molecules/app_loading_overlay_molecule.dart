import 'package:flutter/material.dart';
import '../atoms/app_progress_indicator_atom.dart';

/// A reusable loading overlay molecule for showing loading states
/// Following atomic design principles - composed from atoms
class AppLoadingOverlayMolecule extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  final Color? overlayColor;
  final double? opacity;
  final bool dismissible;
  final VoidCallback? onDismiss;
  final ProgressIndicatorType indicatorType;

  const AppLoadingOverlayMolecule({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.overlayColor,
    this.opacity,
    this.dismissible = false,
    this.onDismiss,
    this.indicatorType = ProgressIndicatorType.circular,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return child;
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        child,
        Positioned.fill(
          child: GestureDetector(
            onTap: dismissible ? onDismiss : null,
            child: Container(
              color: (overlayColor ?? Colors.black).withValues(alpha: opacity ?? 0.3),
              child: Center(
                child: _LoadingContent(
                  message: message,
                  indicatorType: indicatorType,
                  backgroundColor: colorScheme.surface,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadingContent extends StatelessWidget {
  final String? message;
  final ProgressIndicatorType indicatorType;
  final Color backgroundColor;

  const _LoadingContent({
    this.message,
    required this.indicatorType,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppProgressIndicatorAtom(
            type: indicatorType,
            size: 48,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// A full-screen loading overlay
class AppFullScreenLoadingMolecule extends StatelessWidget {
  final String? message;
  final String? submessage;
  final Widget? customIndicator;
  final Color? backgroundColor;
  final bool showProgress;
  final double? progress;

  const AppFullScreenLoadingMolecule({
    super.key,
    this.message,
    this.submessage,
    this.customIndicator,
    this.backgroundColor,
    this.showProgress = false,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: backgroundColor ?? colorScheme.surface,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (customIndicator != null)
              customIndicator!
            else if (showProgress && progress != null)
              AppProgressIndicatorAtom.withPercentage(
                value: progress!,
                size: 80,
              )
            else
              AppProgressIndicatorAtom(
                type: ProgressIndicatorType.circular,
                size: 60,
              ),
            if (message != null) ...[
              const SizedBox(height: 24),
              Text(
                message!,
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ],
            if (submessage != null) ...[
              const SizedBox(height: 8),
              Text(
                submessage!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A skeleton loading placeholder
class AppSkeletonLoadingMolecule extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;
  final Duration animationDuration;

  const AppSkeletonLoadingMolecule({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
    this.animationDuration = const Duration(milliseconds: 1500),
  });

  /// Factory constructor for text skeleton
  factory AppSkeletonLoadingMolecule.text({
    Key? key,
    double? width,
    double height = 16,
    EdgeInsets? margin,
  }) {
    return AppSkeletonLoadingMolecule(
      key: key,
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(4),
      margin: margin,
    );
  }

  /// Factory constructor for avatar skeleton
  factory AppSkeletonLoadingMolecule.avatar({
    Key? key,
    double size = 40,
    EdgeInsets? margin,
  }) {
    return AppSkeletonLoadingMolecule(
      key: key,
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
      margin: margin,
    );
  }

  /// Factory constructor for card skeleton
  factory AppSkeletonLoadingMolecule.card({
    Key? key,
    double? width,
    double height = 120,
    EdgeInsets? margin,
  }) {
    return AppSkeletonLoadingMolecule(
      key: key,
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(8),
      margin: margin,
    );
  }

  @override
  State<AppSkeletonLoadingMolecule> createState() => _AppSkeletonLoadingMoleculeState();
}

class _AppSkeletonLoadingMoleculeState extends State<AppSkeletonLoadingMolecule>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          margin: widget.margin,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                colorScheme.surfaceContainerHighest,
                colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                colorScheme.surfaceContainerHighest,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
            ),
          ),
        );
      },
    );
  }
}

/// A shimmer loading effect
class AppShimmerLoadingMolecule extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color? baseColor;
  final Color? highlightColor;

  const AppShimmerLoadingMolecule({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<AppShimmerLoadingMolecule> createState() => _AppShimmerLoadingMoleculeState();
}

class _AppShimmerLoadingMoleculeState extends State<AppShimmerLoadingMolecule>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseColor = widget.baseColor ?? colorScheme.surfaceContainerHighest;
    final highlightColor = widget.highlightColor ?? colorScheme.surface;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
              transform: GradientRotation(_animation.value * 2),
            ).createShader(rect);
          },
          child: widget.child,
        );
      },
    );
  }
}
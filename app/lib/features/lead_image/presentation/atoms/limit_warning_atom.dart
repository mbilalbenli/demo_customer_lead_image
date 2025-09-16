import 'package:flutter/material.dart';

/// An atom for displaying limit warnings when approaching or at capacity
/// Appears when 8+ images are stored
/// Following atomic design principles - smallest UI component
class LimitWarningAtom extends StatelessWidget {
  final int currentCount;
  final int maxCount;
  final WarningLevel level;
  final bool dismissible;
  final VoidCallback? onDismiss;
  final VoidCallback? onAction;
  final String? actionLabel;
  final bool compact;

  const LimitWarningAtom({
    super.key,
    required this.currentCount,
    this.maxCount = 10,
    this.level = WarningLevel.auto,
    this.dismissible = false,
    this.onDismiss,
    this.onAction,
    this.actionLabel,
    this.compact = false,
  });

  /// Factory for approaching limit warning (8-9 images)
  factory LimitWarningAtom.approaching({
    Key? key,
    required int count,
    VoidCallback? onDismiss,
  }) {
    return LimitWarningAtom(
      key: key,
      currentCount: count,
      level: WarningLevel.approaching,
      dismissible: true,
      onDismiss: onDismiss,
    );
  }

  /// Factory for at limit warning (10 images)
  factory LimitWarningAtom.atLimit({
    Key? key,
    VoidCallback? onManageImages,
  }) {
    return LimitWarningAtom(
      key: key,
      currentCount: 10,
      level: WarningLevel.atLimit,
      onAction: onManageImages,
      actionLabel: 'Manage Images',
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveLevel = _determineLevel();

    if (effectiveLevel == WarningLevel.none) {
      return const SizedBox.shrink();
    }

    if (compact) {
      return _buildCompactWarning(context, effectiveLevel);
    }

    return _buildFullWarning(context, effectiveLevel);
  }

  WarningLevel _determineLevel() {
    if (level != WarningLevel.auto) return level;

    if (currentCount >= maxCount) return WarningLevel.atLimit;
    if (currentCount >= maxCount - 2) return WarningLevel.approaching;
    return WarningLevel.none;
  }

  Widget _buildFullWarning(BuildContext context, WarningLevel effectiveLevel) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final remainingSlots = maxCount - currentCount;

    final (bgColor, fgColor, icon, title, message) = switch (effectiveLevel) {
      WarningLevel.approaching => (
          colorScheme.tertiaryContainer,
          colorScheme.onTertiaryContainer,
          Icons.info_outline,
          'Approaching Limit',
          remainingSlots == 1
              ? 'Only 1 slot remaining for images'
              : 'Only $remainingSlots slots remaining for images',
        ),
      WarningLevel.atLimit => (
          colorScheme.errorContainer,
          colorScheme.onErrorContainer,
          Icons.warning,
          'Storage Full',
          'You\'ve reached the maximum of $maxCount images. Delete existing images to add new ones.',
        ),
      WarningLevel.none || WarningLevel.auto => (
          Colors.transparent,
          Colors.transparent,
          Icons.info,
          '',
          '',
        ),
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: bgColor.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: effectiveLevel == WarningLevel.atLimit
                ? colorScheme.error
                : colorScheme.tertiary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: fgColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: fgColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          if (onAction != null)
            TextButton(
              onPressed: onAction,
              child: Text(
                actionLabel ?? 'Action',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (dismissible && onDismiss != null)
            IconButton(
              icon: Icon(
                Icons.close,
                size: 18,
              ),
              onPressed: onDismiss,
              color: fgColor.withValues(alpha: 0.6),
            ),
        ],
      ),
    );
  }

  Widget _buildCompactWarning(BuildContext context, WarningLevel effectiveLevel) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final remainingSlots = maxCount - currentCount;

    final (bgColor, fgColor, icon, message) = switch (effectiveLevel) {
      WarningLevel.approaching => (
          colorScheme.tertiaryContainer,
          colorScheme.onTertiaryContainer,
          Icons.info,
          '$remainingSlots ${remainingSlots == 1 ? 'slot' : 'slots'} left',
        ),
      WarningLevel.atLimit => (
          colorScheme.errorContainer,
          colorScheme.onErrorContainer,
          Icons.block,
          'Storage full',
        ),
      WarningLevel.none || WarningLevel.auto => (
          Colors.transparent,
          Colors.transparent,
          Icons.info,
          '',
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: effectiveLevel == WarningLevel.atLimit
                ? colorScheme.error
                : colorScheme.tertiary,
          ),
          const SizedBox(width: 4),
          Text(
            message,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: fgColor,
            ),
          ),
        ],
      ),
    );
  }
}

enum WarningLevel {
  none,
  approaching,
  atLimit,
  auto,
}

/// An animated warning badge that pulses when at limit
class AnimatedLimitWarningAtom extends StatefulWidget {
  final int currentCount;
  final int maxCount;

  const AnimatedLimitWarningAtom({
    super.key,
    required this.currentCount,
    this.maxCount = 10,
  });

  @override
  State<AnimatedLimitWarningAtom> createState() => _AnimatedLimitWarningAtomState();
}

class _AnimatedLimitWarningAtomState extends State<AnimatedLimitWarningAtom>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.currentCount >= widget.maxCount) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AnimatedLimitWarningAtom oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentCount >= widget.maxCount) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentCount < widget.maxCount - 2) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAtLimit = widget.currentCount >= widget.maxCount;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: isAtLimit ? _animation.value : 1.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isAtLimit
                  ? colorScheme.error.withValues(alpha: 0.2)
                  : colorScheme.tertiary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isAtLimit ? colorScheme.error : colorScheme.tertiary,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isAtLimit ? Icons.error : Icons.warning,
                  size: 16,
                  color: isAtLimit ? colorScheme.error : colorScheme.tertiary,
                ),
                const SizedBox(width: 4),
                Text(
                  isAtLimit
                      ? 'FULL'
                      : '${widget.maxCount - widget.currentCount} left',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isAtLimit ? colorScheme.error : colorScheme.tertiary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
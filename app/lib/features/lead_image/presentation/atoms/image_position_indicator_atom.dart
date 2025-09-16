import 'package:flutter/material.dart';

/// An atom for image position indicator
/// Shows position X of Y format
/// Following atomic design principles
class ImagePositionIndicatorAtom extends StatelessWidget {
  final int current;
  final int total;
  final int maxTotal;
  final bool showLimitWarning;

  const ImagePositionIndicatorAtom({
    super.key,
    required this.current,
    required this.total,
    this.maxTotal = 10,
    this.showLimitWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAtLimit = total >= maxTotal;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(16),
        border: showLimitWarning && isAtLimit
            ? Border.all(
                color: theme.colorScheme.error.withValues(alpha: 0.5),
                width: 1,
              )
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$current / $total',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (showLimitWarning && isAtLimit) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.warning_amber_rounded,
              size: 16,
              color: theme.colorScheme.error,
            ),
          ],
        ],
      ),
    );
  }
}
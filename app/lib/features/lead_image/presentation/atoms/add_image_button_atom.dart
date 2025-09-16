import 'package:flutter/material.dart';

/// An atom for add image button that changes behavior at limit
/// Shows replacement option when at capacity
/// Following atomic design principles - smallest UI component
class AddImageButtonAtom extends StatelessWidget {
  final VoidCallback? onAdd;
  final VoidCallback? onReplace;
  final int currentCount;
  final int maxCount;
  final ButtonVariant variant;
  final bool showCount;
  final double? size;

  const AddImageButtonAtom({
    super.key,
    required this.onAdd,
    this.onReplace,
    required this.currentCount,
    this.maxCount = 10,
    this.variant = ButtonVariant.filled,
    this.showCount = true,
    this.size,
  });

  /// Factory for standard add button
  factory AddImageButtonAtom.standard({
    Key? key,
    required VoidCallback? onAdd,
    required int currentCount,
    VoidCallback? onReplace,
  }) {
    return AddImageButtonAtom(
      key: key,
      onAdd: onAdd,
      onReplace: onReplace,
      currentCount: currentCount,
      variant: ButtonVariant.filled,
    );
  }

  /// Factory for card style add button
  factory AddImageButtonAtom.card({
    Key? key,
    required VoidCallback? onAdd,
    required int currentCount,
    VoidCallback? onReplace,
  }) {
    return AddImageButtonAtom(
      key: key,
      onAdd: onAdd,
      onReplace: onReplace,
      currentCount: currentCount,
      variant: ButtonVariant.card,
    );
  }

  /// Factory for floating action button
  factory AddImageButtonAtom.fab({
    Key? key,
    required VoidCallback? onAdd,
    required int currentCount,
    VoidCallback? onReplace,
  }) {
    return AddImageButtonAtom(
      key: key,
      onAdd: onAdd,
      onReplace: onReplace,
      currentCount: currentCount,
      variant: ButtonVariant.fab,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAtLimit = currentCount >= maxCount;
    final slotsRemaining = maxCount - currentCount;

    switch (variant) {
      case ButtonVariant.filled:
        return _buildFilledButton(context, isAtLimit, slotsRemaining);
      case ButtonVariant.outlined:
        return _buildOutlinedButton(context, isAtLimit, slotsRemaining);
      case ButtonVariant.card:
        return _buildCardButton(context, isAtLimit, slotsRemaining);
      case ButtonVariant.fab:
        return _buildFabButton(context, isAtLimit);
    }
  }

  Widget _buildFilledButton(
    BuildContext context,
    bool isAtLimit,
    int slotsRemaining,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isAtLimit && onReplace != null) {
      return FilledButton.icon(
        onPressed: onReplace,
        icon: Icon(Icons.swap_horiz, size: size ?? 20),
        label: Text(
          'Replace Image',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.tertiary,
          foregroundColor: colorScheme.onTertiary,
        ),
      );
    }

    return FilledButton.icon(
      onPressed: isAtLimit ? null : onAdd,
      icon: Icon(
        Icons.add_photo_alternate,
        size: size ?? 20,
      ),
      label: Text(
        isAtLimit
            ? 'Storage Full'
            : showCount
                ? 'Add Image ($slotsRemaining left)'
                : 'Add Image',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      style: FilledButton.styleFrom(
        backgroundColor: isAtLimit ? colorScheme.surfaceContainerHighest : null,
        foregroundColor: isAtLimit ? colorScheme.onSurfaceVariant : null,
      ),
    );
  }

  Widget _buildOutlinedButton(
    BuildContext context,
    bool isAtLimit,
    int slotsRemaining,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isAtLimit && onReplace != null) {
      return OutlinedButton.icon(
        onPressed: onReplace,
        icon: Icon(Icons.swap_horiz, size: size ?? 20),
        label: Text('Replace Image'),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colorScheme.tertiary),
          foregroundColor: colorScheme.tertiary,
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: isAtLimit ? null : onAdd,
      icon: Icon(
        Icons.add_photo_alternate_outlined,
        size: size ?? 20,
      ),
      label: Text(
        isAtLimit
            ? 'Storage Full'
            : showCount
                ? 'Add ($slotsRemaining)'
                : 'Add',
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: isAtLimit
              ? colorScheme.outline.withValues(alpha: 0.3)
              : colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildCardButton(
    BuildContext context,
    bool isAtLimit,
    int slotsRemaining,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: isAtLimit
          ? (onReplace ?? () => _showLimitDialog(context))
          : onAdd,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: size ?? 100,
        height: size ?? 100,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isAtLimit
                ? colorScheme.error.withValues(alpha: 0.3)
                : colorScheme.outline.withValues(alpha: 0.3),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isAtLimit ? Icons.block : Icons.add_a_photo,
              size: 32,
              color: isAtLimit
                  ? colorScheme.error.withValues(alpha: 0.5)
                  : colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              isAtLimit
                  ? 'Full'
                  : showCount
                      ? '+$slotsRemaining'
                      : 'Add',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isAtLimit ? colorScheme.error : colorScheme.primary,
              ),
            ),
            if (isAtLimit && onReplace != null) ...[
              const SizedBox(height: 4),
              Text(
                'Tap to replace',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.tertiary,
                  fontSize: 10,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFabButton(BuildContext context, bool isAtLimit) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isAtLimit) {
      if (onReplace != null) {
        return FloatingActionButton.extended(
          onPressed: onReplace,
          icon: Icon(Icons.swap_horiz),
          label: Text('Replace'),
          backgroundColor: colorScheme.tertiary,
          foregroundColor: colorScheme.onTertiary,
        );
      }

      return FloatingActionButton(
        onPressed: null,
        backgroundColor: colorScheme.surfaceContainerHighest,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.block,
              color: colorScheme.error,
              size: 20,
            ),
            Text(
              'FULL',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: colorScheme.error,
              ),
            ),
          ],
        ),
      );
    }

    return FloatingActionButton(
      onPressed: onAdd,
      tooltip: 'Add Image',
      child: Icon(Icons.add_photo_alternate),
    );
  }

  void _showLimitDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.info_outline,
          color: colorScheme.primary,
          size: 48,
        ),
        title: Text('Storage Limit Reached'),
        content: Text(
          'You have reached the maximum of $maxCount images. '
          'To add new images, please delete some existing ones first.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Got it'),
          ),
        ],
      ),
    );
  }
}

enum ButtonVariant {
  filled,
  outlined,
  card,
  fab,
}

/// A specialized add image placeholder for grids
class AddImagePlaceholderAtom extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isAtLimit;
  final int slotsRemaining;

  const AddImagePlaceholderAtom({
    super.key,
    required this.onTap,
    this.isAtLimit = false,
    this.slotsRemaining = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isAtLimit ? null : onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isAtLimit
                  ? colorScheme.error.withValues(alpha: 0.3)
                  : colorScheme.outline.withValues(alpha: 0.3),
              width: 2,
              style: isAtLimit ? BorderStyle.solid : BorderStyle.solid,
            ),
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isAtLimit ? Icons.block : Icons.add_photo_alternate,
                  size: 32,
                  color: isAtLimit
                      ? colorScheme.error.withValues(alpha: 0.5)
                      : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 8),
                Text(
                  isAtLimit
                      ? 'Limit\nReached'
                      : slotsRemaining == 1
                          ? 'Add Last\nImage'
                          : 'Add\nImage',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isAtLimit
                        ? colorScheme.error
                        : colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (!isAtLimit && slotsRemaining > 0) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$slotsRemaining left',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
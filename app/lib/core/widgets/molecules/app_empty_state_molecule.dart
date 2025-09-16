import 'package:flutter/material.dart';
import '../atoms/app_button_atom.dart';

/// A reusable empty state molecule for displaying when there's no content
/// Following atomic design principles - composed from atoms
class AppEmptyStateMolecule extends StatelessWidget {
  final IconData? icon;
  final Widget? illustration;
  final String title;
  final String? message;
  final String? actionText;
  final VoidCallback? onAction;
  final double? iconSize;
  final Color? iconColor;
  final EdgeInsets? padding;
  final MainAxisAlignment mainAxisAlignment;

  const AppEmptyStateMolecule({
    super.key,
    this.icon,
    this.illustration,
    required this.title,
    this.message,
    this.actionText,
    this.onAction,
    this.iconSize,
    this.iconColor,
    this.padding,
    this.mainAxisAlignment = MainAxisAlignment.center,
  }) : assert(
          icon != null || illustration != null,
          'Either icon or illustration must be provided',
        );

  /// Factory constructor for no data state
  factory AppEmptyStateMolecule.noData({
    Key? key,
    String? title,
    String? message,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return AppEmptyStateMolecule(
      key: key,
      icon: Icons.inbox_outlined,
      title: title ?? 'No Data',
      message: message ?? 'There is no data to display',
      actionText: actionText,
      onAction: onAction,
    );
  }

  /// Factory constructor for no results state
  factory AppEmptyStateMolecule.noResults({
    Key? key,
    String? title,
    String? message,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return AppEmptyStateMolecule(
      key: key,
      icon: Icons.search_off,
      title: title ?? 'No Results',
      message: message ?? 'Try adjusting your search or filters',
      actionText: actionText ?? 'Clear Filters',
      onAction: onAction,
    );
  }

  /// Factory constructor for no connection state
  factory AppEmptyStateMolecule.noConnection({
    Key? key,
    String? title,
    String? message,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return AppEmptyStateMolecule(
      key: key,
      icon: Icons.wifi_off,
      title: title ?? 'No Connection',
      message: message ?? 'Please check your internet connection',
      actionText: actionText ?? 'Retry',
      onAction: onAction,
    );
  }

  /// Factory constructor for image limit reached (specific to this project)
  factory AppEmptyStateMolecule.imageLimit({
    Key? key,
    required int currentCount,
    required int maxCount,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return AppEmptyStateMolecule(
      key: key,
      icon: Icons.photo_library_outlined,
      title: 'Image Limit Reached',
      message: 'You have $currentCount of $maxCount images. Delete some to add more.',
      actionText: actionText ?? 'Manage Images',
      onAction: onAction,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveIconSize = iconSize ?? 80;
    final effectiveIconColor = iconColor ?? colorScheme.onSurfaceVariant.withValues(alpha: 0.5);
    final effectivePadding = padding ?? const EdgeInsets.all(24);

    return Padding(
      padding: effectivePadding,
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (illustration != null)
            illustration!
          else if (icon != null)
            Icon(
              icon,
              size: effectiveIconSize,
              color: effectiveIconColor,
            ),
          const SizedBox(height: 24),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (actionText != null && onAction != null) ...[
            const SizedBox(height: 24),
            AppButtonAtom(
              text: actionText!,
              onPressed: onAction,
            ),
          ],
        ],
      ),
    );
  }
}

/// A compact empty state variant for smaller spaces
class AppCompactEmptyStateMolecule extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? actionText;
  final VoidCallback? onAction;

  const AppCompactEmptyStateMolecule({
    super.key,
    required this.icon,
    required this.text,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          if (actionText != null && onAction != null) ...[
            const SizedBox(width: 12),
            AppTextButtonAtom(
              text: actionText!,
              onPressed: onAction,
            ),
          ],
        ],
      ),
    );
  }
}

/// An empty state with illustration widget support
class AppIllustrationEmptyStateMolecule extends StatelessWidget {
  final Widget illustration;
  final String title;
  final String? message;
  final List<Widget> actions;
  final EdgeInsets? padding;

  const AppIllustrationEmptyStateMolecule({
    super.key,
    required this.illustration,
    required this.title,
    this.message,
    this.actions = const [],
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectivePadding = padding ?? const EdgeInsets.all(24);

    return Padding(
      padding: effectivePadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 200,
              maxWidth: 200,
            ),
            child: illustration,
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(
              message!,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (actions.isNotEmpty) ...[
            const SizedBox(height: 32),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: actions,
            ),
          ],
        ],
      ),
    );
  }
}
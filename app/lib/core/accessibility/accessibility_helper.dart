import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Helper class for accessibility features and semantics
class AccessibilityHelper {
  /// Private constructor to prevent instantiation
  AccessibilityHelper._();

  /// Add accessibility semantics to a widget
  static Widget addSemantics({
    required Widget child,
    String? label,
    String? hint,
    String? value,
    bool excludeSemantics = false,
    bool focusable = true,
    bool button = false,
    bool header = false,
    bool image = false,
    bool textField = false,
    bool link = false,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    bool enabled = true,
  }) {
    if (excludeSemantics) {
      return ExcludeSemantics(child: child);
    }

    return Semantics(
      label: label,
      hint: hint,
      value: value,
      focusable: focusable,
      button: button,
      header: header,
      image: image,
      textField: textField,
      link: link,
      onTap: onTap,
      onLongPress: onLongPress,
      enabled: enabled,
      child: child,
    );
  }

  /// Create a semantics wrapper for buttons
  static Widget buttonSemantics({
    required Widget child,
    required String label,
    String? hint,
    VoidCallback? onPressed,
    bool enabled = true,
  }) {
    return addSemantics(
      child: child,
      label: label,
      hint: hint,
      button: true,
      focusable: true,
      enabled: enabled,
      onTap: enabled ? onPressed : null,
    );
  }

  /// Create a semantics wrapper for images
  static Widget imageSemantics({
    required Widget child,
    required String label,
    String? hint,
    VoidCallback? onTap,
  }) {
    return addSemantics(
      child: child,
      label: label,
      hint: hint,
      image: true,
      focusable: onTap != null,
      onTap: onTap,
    );
  }

  /// Create a semantics wrapper for text fields
  static Widget textFieldSemantics({
    required Widget child,
    required String label,
    String? hint,
    String? value,
    bool enabled = true,
  }) {
    return addSemantics(
      child: child,
      label: label,
      hint: hint,
      value: value,
      textField: true,
      focusable: true,
      enabled: enabled,
    );
  }

  /// Create a semantics wrapper for headers
  static Widget headerSemantics({
    required Widget child,
    required String label,
  }) {
    return addSemantics(
      child: child,
      label: label,
      header: true,
      focusable: false,
    );
  }

  /// Create a semantics wrapper for links
  static Widget linkSemantics({
    required Widget child,
    required String label,
    String? hint,
    VoidCallback? onTap,
    bool enabled = true,
  }) {
    return addSemantics(
      child: child,
      label: label,
      hint: hint,
      link: true,
      focusable: true,
      enabled: enabled,
      onTap: enabled ? onTap : null,
    );
  }

  /// Get readable text for screen readers
  static String getReadableText(String text) {
    // Remove special characters and normalize for screen readers
    return text
        .replaceAll(RegExp(r'[^\w\s]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Get accessible color contrast
  static bool hasGoodContrast(Color foreground, Color background) {
    // Calculate luminance for both colors
    final foregroundLuminance = _calculateLuminance(foreground);
    final backgroundLuminance = _calculateLuminance(background);

    // Calculate contrast ratio
    final lighter = foregroundLuminance > backgroundLuminance
        ? foregroundLuminance
        : backgroundLuminance;
    final darker = foregroundLuminance > backgroundLuminance
        ? backgroundLuminance
        : foregroundLuminance;

    final contrastRatio = (lighter + 0.05) / (darker + 0.05);

    // WCAG AA standard requires a contrast ratio of at least 4.5:1
    return contrastRatio >= 4.5;
  }

  /// Calculate luminance of a color
  static double _calculateLuminance(Color color) {
    final r = _sRGBtoLinear(color.r);
    final g = _sRGBtoLinear(color.g);
    final b = _sRGBtoLinear(color.b);

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Convert sRGB to linear RGB
  static double _sRGBtoLinear(double colorChannel) {
    if (colorChannel <= 0.03928) {
      return colorChannel / 12.92;
    } else {
      return ((colorChannel + 0.055) / 1.055).clamp(0.0, 1.0);
    }
  }

  /// Check if high contrast mode is enabled
  static bool isHighContrastMode(BuildContext context) {
    return MediaQuery.of(context).highContrast;
  }

  /// Check if animations are disabled (reduce motion)
  static bool shouldReduceMotion(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  /// Get text scale factor for accessibility
  static double getTextScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaler.scale(14) / 14;
  }

  /// Check if bold text is enabled
  static bool isBoldTextEnabled(BuildContext context) {
    return MediaQuery.of(context).boldText;
  }

  /// Create focus traversal order for keyboard navigation
  static FocusTraversalOrder createFocusOrder({
    required Widget child,
    required double order,
  }) {
    return FocusTraversalOrder(
      order: NumericFocusOrder(order),
      child: child,
    );
  }

  /// Create a focus scope for better keyboard navigation
  static FocusScope createFocusScope({
    required Widget child,
    bool canRequestFocus = true,
    bool skipTraversal = false,
    FocusScopeNode? node,
  }) {
    return FocusScope(
      canRequestFocus: canRequestFocus,
      skipTraversal: skipTraversal,
      node: node,
      child: child,
    );
  }

  /// Announce content to screen readers
  static void announce(BuildContext context, String message) {
    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Create a tooltip for accessibility
  static Widget createTooltip({
    required Widget child,
    required String message,
    Duration? showDuration,
    Duration? waitDuration,
  }) {
    return Tooltip(
      message: message,
      showDuration: showDuration ?? const Duration(seconds: 2),
      waitDuration: waitDuration ?? const Duration(milliseconds: 500),
      child: child,
    );
  }

  /// Get minimum touch target size for accessibility
  static Size getMinimumTouchTarget() {
    return const Size(48.0, 48.0);
  }

  /// Ensure widget meets minimum touch target size
  static Widget ensureMinimumTouchTarget({
    required Widget child,
    Size? minimumSize,
  }) {
    final minSize = minimumSize ?? getMinimumTouchTarget();

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minSize.width,
        minHeight: minSize.height,
      ),
      child: child,
    );
  }

  /// Create an accessible dismissible widget
  static Widget createAccessibleDismissible({
    required Widget child,
    required Key key,
    required DismissDirectionCallback onDismissed,
    String? dismissLabel,
    IconData? dismissIcon,
  }) {
    return Dismissible(
      key: key,
      onDismissed: onDismissed,
      child: addSemantics(
        child: child,
        label: dismissLabel ?? 'Swipe to dismiss',
        hint: 'Swipe left or right to remove this item',
      ),
    );
  }

  /// Create an accessible expansion tile
  static Widget createAccessibleExpansionTile({
    required Widget title,
    required List<Widget> children,
    bool initiallyExpanded = false,
    String? expandedHint,
    String? collapsedHint,
  }) {
    return ExpansionTile(
      title: addSemantics(
        child: title,
        button: true,
        hint: initiallyExpanded
            ? (expandedHint ?? 'Tap to collapse')
            : (collapsedHint ?? 'Tap to expand'),
      ),
      initiallyExpanded: initiallyExpanded,
      children: children,
    );
  }
}

/// Extension for adding accessibility to common widgets
extension AccessibilityExtensions on Widget {
  /// Add button semantics to any widget
  Widget asAccessibleButton({
    required String label,
    String? hint,
    VoidCallback? onPressed,
    bool enabled = true,
  }) {
    return AccessibilityHelper.buttonSemantics(
      child: this,
      label: label,
      hint: hint,
      onPressed: onPressed,
      enabled: enabled,
    );
  }

  /// Add image semantics to any widget
  Widget asAccessibleImage({
    required String label,
    String? hint,
    VoidCallback? onTap,
  }) {
    return AccessibilityHelper.imageSemantics(
      child: this,
      label: label,
      hint: hint,
      onTap: onTap,
    );
  }

  /// Add header semantics to any widget
  Widget asAccessibleHeader(String label) {
    return AccessibilityHelper.headerSemantics(
      child: this,
      label: label,
    );
  }

  /// Add tooltip for accessibility
  Widget withAccessibleTooltip(String message) {
    return AccessibilityHelper.createTooltip(
      child: this,
      message: message,
    );
  }

  /// Ensure minimum touch target size
  Widget withMinimumTouchTarget([Size? minimumSize]) {
    return AccessibilityHelper.ensureMinimumTouchTarget(
      child: this,
      minimumSize: minimumSize,
    );
  }

  /// Add focus traversal order
  Widget withFocusOrder(double order) {
    return AccessibilityHelper.createFocusOrder(
      child: this,
      order: order,
    );
  }
}
import 'package:flutter/material.dart';

/// Helper class for Right-to-Left (RTL) language support
class RTLHelper {
  /// Private constructor to prevent instantiation
  RTLHelper._();

  /// Check if the current locale is RTL
  static bool isRTL(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl;
  }

  /// Get the appropriate text direction for the locale
  static TextDirection getTextDirection(String languageCode) {
    const rtlLanguages = {
      'ar', // Arabic
      'he', // Hebrew
      'fa', // Persian/Farsi
      'ur', // Urdu
      'yi', // Yiddish
      'ji', // Yiddish alternative code
      'iw', // Hebrew alternative code
      'ku', // Kurdish
      'ps', // Pashto
      'sd', // Sindhi
      'ug', // Uyghur
    };

    return rtlLanguages.contains(languageCode)
        ? TextDirection.rtl
        : TextDirection.ltr;
  }

  /// Create a directional wrapper that respects RTL
  static Widget directional({
    required BuildContext context,
    required Widget child,
    TextDirection? textDirection,
  }) {
    return Directionality(
      textDirection: textDirection ?? Directionality.of(context),
      child: child,
    );
  }

  /// Get appropriate alignment for text based on text direction
  static TextAlign getTextAlign(BuildContext context, {TextAlign? fallback}) {
    if (isRTL(context)) {
      switch (fallback) {
        case TextAlign.left:
          return TextAlign.right;
        case TextAlign.right:
          return TextAlign.left;
        case TextAlign.start:
          return TextAlign.start; // Already correct for RTL
        case TextAlign.end:
          return TextAlign.end; // Already correct for RTL
        default:
          return TextAlign.start;
      }
    }
    return fallback ?? TextAlign.start;
  }

  /// Get appropriate alignment for widgets based on text direction
  static Alignment getAlignment(BuildContext context, Alignment ltrAlignment) {
    if (!isRTL(context)) return ltrAlignment;

    // Mirror horizontal alignments for RTL
    if (ltrAlignment == Alignment.centerLeft) {
      return Alignment.centerRight;
    } else if (ltrAlignment == Alignment.centerRight) {
      return Alignment.centerLeft;
    } else if (ltrAlignment == Alignment.topLeft) {
      return Alignment.topRight;
    } else if (ltrAlignment == Alignment.topRight) {
      return Alignment.topLeft;
    } else if (ltrAlignment == Alignment.bottomLeft) {
      return Alignment.bottomRight;
    } else if (ltrAlignment == Alignment.bottomRight) {
      return Alignment.bottomLeft;
    }

    return ltrAlignment;
  }

  /// Get appropriate EdgeInsets for RTL
  static EdgeInsets getEdgeInsets(
    BuildContext context, {
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) {
    if (isRTL(context)) {
      return EdgeInsets.only(
        left: right,
        top: top,
        right: left,
        bottom: bottom,
      );
    }
    return EdgeInsets.only(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
  }

  /// Get appropriate EdgeInsetsDirectional (recommended)
  static EdgeInsetsDirectional getDirectionalPadding({
    double start = 0.0,
    double top = 0.0,
    double end = 0.0,
    double bottom = 0.0,
  }) {
    return EdgeInsetsDirectional.only(
      start: start,
      top: top,
      end: end,
      bottom: bottom,
    );
  }

  /// Get appropriate BorderRadius for RTL
  static BorderRadius getBorderRadius(
    BuildContext context, {
    double topLeft = 0.0,
    double topRight = 0.0,
    double bottomLeft = 0.0,
    double bottomRight = 0.0,
  }) {
    if (isRTL(context)) {
      return BorderRadius.only(
        topLeft: Radius.circular(topRight),
        topRight: Radius.circular(topLeft),
        bottomLeft: Radius.circular(bottomRight),
        bottomRight: Radius.circular(bottomLeft),
      );
    }
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight),
      bottomLeft: Radius.circular(bottomLeft),
      bottomRight: Radius.circular(bottomRight),
    );
  }

  /// Get appropriate BorderRadiusDirectional (recommended)
  static BorderRadiusDirectional getDirectionalBorderRadius({
    double topStart = 0.0,
    double topEnd = 0.0,
    double bottomStart = 0.0,
    double bottomEnd = 0.0,
  }) {
    return BorderRadiusDirectional.only(
      topStart: Radius.circular(topStart),
      topEnd: Radius.circular(topEnd),
      bottomStart: Radius.circular(bottomStart),
      bottomEnd: Radius.circular(bottomEnd),
    );
  }

  /// Mirror an icon for RTL languages if needed
  static Widget mirrorIcon({
    required BuildContext context,
    required IconData icon,
    double? size,
    Color? color,
    bool shouldMirror = true,
  }) {
    final iconWidget = Icon(
      icon,
      size: size,
      color: color,
    );

    if (shouldMirror && isRTL(context)) {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..setEntry(0, 0, -1.0),
        child: iconWidget,
      );
    }

    return iconWidget;
  }

  /// Create a properly aligned Row for RTL
  static Widget createDirectionalRow({
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
  }) {
    return Row(
      textDirection: null, // Let parent handle direction
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children,
    );
  }

  /// Create a properly aligned Wrap for RTL
  static Widget createDirectionalWrap({
    required List<Widget> children,
    WrapAlignment alignment = WrapAlignment.start,
    double spacing = 0.0,
    WrapAlignment runAlignment = WrapAlignment.start,
    double runSpacing = 0.0,
    WrapCrossAlignment crossAxisAlignment = WrapCrossAlignment.start,
  }) {
    return Wrap(
      textDirection: null, // Let parent handle direction
      alignment: alignment,
      spacing: spacing,
      runAlignment: runAlignment,
      runSpacing: runSpacing,
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }

  /// Create a ListTile with proper RTL support
  static Widget createDirectionalListTile({
    Widget? leading,
    Widget? title,
    Widget? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
      contentPadding: contentPadding,
    );
  }

  /// Get appropriate slide transition for RTL
  static SlideTransition createDirectionalSlideTransition({
    required BuildContext context,
    required Animation<Offset> position,
    required Widget child,
    bool slideFromEnd = false,
  }) {
    Animation<Offset> adjustedPosition = position;

    if (slideFromEnd && isRTL(context)) {
      // Reverse the horizontal direction for RTL
      adjustedPosition = position.drive(
        Tween<Offset>(
          begin: const Offset(-1.0, 0.0),
          end: const Offset(0.0, 0.0),
        ),
      );
    }

    return SlideTransition(
      position: adjustedPosition,
      child: child,
    );
  }

  /// Get the appropriate text direction for a specific locale
  static TextDirection getTextDirectionForLocale(Locale locale) {
    return getTextDirection(locale.languageCode);
  }

  /// Check if a specific locale is RTL
  static bool isLocaleRTL(Locale locale) {
    return getTextDirection(locale.languageCode) == TextDirection.rtl;
  }
}

/// Extension methods for easier RTL support
extension RTLExtensions on Widget {
  /// Wrap widget with directional support
  Widget withDirectional(BuildContext context, {TextDirection? direction}) {
    return RTLHelper.directional(
      context: context,
      textDirection: direction,
      child: this,
    );
  }

  /// Add RTL-aware padding
  Widget withDirectionalPadding({
    double start = 0.0,
    double top = 0.0,
    double end = 0.0,
    double bottom = 0.0,
  }) {
    return Padding(
      padding: RTLHelper.getDirectionalPadding(
        start: start,
        top: top,
        end: end,
        bottom: bottom,
      ),
      child: this,
    );
  }

  /// Add RTL-aware margin
  Widget withDirectionalMargin({
    double start = 0.0,
    double top = 0.0,
    double end = 0.0,
    double bottom = 0.0,
  }) {
    return Container(
      margin: RTLHelper.getDirectionalPadding(
        start: start,
        top: top,
        end: end,
        bottom: bottom,
      ),
      child: this,
    );
  }
}
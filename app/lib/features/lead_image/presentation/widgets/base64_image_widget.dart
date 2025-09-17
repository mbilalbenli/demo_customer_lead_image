import 'package:flutter/material.dart';
import '../../infrastructure/services/base64_converter.dart';
import '../../../../core/utils/app_logger.dart';

class Base64ImageWidget extends StatelessWidget {
  final String base64Data;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Color? backgroundColor;

  const Base64ImageWidget({
    super.key,
    required this.base64Data,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (base64Data.isEmpty) {
      AppLogger.warning('Base64ImageWidget: Empty base64 data');
      return _buildErrorWidget(context);
    }

    try {
      final bytes = Base64Converter.decodeBase64(base64Data);

      return Container(
        width: width,
        height: height,
        color: backgroundColor ?? Colors.grey[200],
        child: Image.memory(
          bytes,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            AppLogger.error('Failed to display Base64 image: $error');
            return _buildErrorWidget(context);
          },
        ),
      );
    } catch (e) {
      AppLogger.error('Error decoding Base64 image: $e');
      return _buildErrorWidget(context);
    }
  }

  Widget _buildErrorWidget(BuildContext context) {
    return errorWidget ??
      Container(
        width: width,
        height: height,
        color: backgroundColor ?? Colors.grey[300],
        child: const Center(
          child: Icon(
            Icons.broken_image_outlined,
            color: Colors.grey,
            size: 48,
          ),
        ),
      );
  }

}
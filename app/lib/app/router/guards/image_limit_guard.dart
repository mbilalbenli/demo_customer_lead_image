import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/app_logger.dart';
import '../../../features/lead_image/presentation/providers/image_limit_providers.dart';
import '../../../features/lead_image/domain/constants/image_constants.dart';
import '../route_names.dart';

class ImageLimitGuard {
  static Future<String?> checkImageLimitBeforeUpload(
    BuildContext context,
    GoRouterState state,
    WidgetRef ref,
  ) async {
    try {
      final leadId = state.pathParameters['leadId'];
      if (leadId == null) {
        AppLogger.error('Lead ID not found in route parameters');
        return RouteNames.leadListPath;
      }

      // Check current image count for the lead
      final imageStatusAsync = ref.read(imageStatusProvider(leadId));
      AppLogger.info('ImageLimitGuard.check | leadId=$leadId | status=$imageStatusAsync');

      await imageStatusAsync.when(
        data: (status) async {
          AppLogger.info('ImageLimitGuard.status | data received: current=${status?.currentCount}, max=${status?.maxCount}');
          if (status != null) {
            final currentCount = status.currentCount;
            final maxCount = ImageConstants.maxImagesPerLead;

            if (currentCount >= maxCount) {
              AppLogger.info('Image limit reached ($currentCount/$maxCount)');

              // Show dialog to user
              final shouldReplace = await _showLimitReachedDialog(context);

              if (shouldReplace) {
                // Redirect to lead detail for managing images inline
                return RouteNames.getLeadDetailPath(leadId);
              } else {
                // Go back to previous route
                return null;
              }
            }
          }
        },
        loading: () {
          AppLogger.info('ImageLimitGuard.status | loading');
          // Allow navigation while loading
        },
        error: (error, stack) {
          AppLogger.error('ImageLimitGuard.status | error checking image limit', error, stack);
        },
      );

      return null; // Allow navigation if under limit
    } catch (e) {
      AppLogger.error('Error in image limit guard', e);
      return null; // Allow navigation on error (will be handled by upload page)
    }
  }

  static Future<bool> _showLimitReachedDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Image Limit Reached'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You have reached the maximum of ${ImageConstants.maxImagesPerLead} images for this lead.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Would you like to replace an existing image?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Replace Image'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  static bool canAddImage(int currentCount) {
    return currentCount < ImageConstants.maxImagesPerLead;
  }

  static int getRemainingSlots(int currentCount) {
    return ImageConstants.maxImagesPerLead - currentCount;
  }

  static String getSlotMessage(int currentCount) {
    final remaining = getRemainingSlots(currentCount);
    final max = ImageConstants.maxImagesPerLead;

    if (remaining == 0) {
      return 'Maximum images reached ($max/$max)';
    } else if (remaining == 1) {
      return '1 image slot remaining';
    } else {
      return '$remaining image slots remaining';
    }
  }

  static Widget buildLimitIndicator(
    int currentCount, {
    Color? activeColor,
    Color? inactiveColor,
    double size = 8.0,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        ImageConstants.maxImagesPerLead,
        (index) => Container(
          width: size,
          height: size,
          margin: EdgeInsets.symmetric(horizontal: size / 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < currentCount
                ? (activeColor ?? Colors.blue)
                : (inactiveColor ?? Colors.grey.shade300),
          ),
        ),
      ),
    );
  }
}

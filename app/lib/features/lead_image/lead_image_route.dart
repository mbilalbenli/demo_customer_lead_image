import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/router/route_names.dart';
import '../../app/router/guards/image_limit_guard.dart';
import 'presentation/pages/image_gallery_page.dart';
import 'presentation/pages/image_viewer_page.dart';
import 'presentation/pages/image_capture_page.dart';
import 'presentation/pages/image_upload_page.dart';

class LeadImageRoute {
  static List<RouteBase> getImageRoutes(WidgetRef ref) {
    return [
      // These routes are nested under lead detail route
      // Image gallery
      GoRoute(
        path: 'images',
        name: RouteNames.imageGallery,
        builder: (context, state) {
          final leadId = state.pathParameters['leadId'] ?? '';
          return ImageGalleryPage(leadId: leadId);
        },
        routes: [
          // Image status
          GoRoute(
            path: 'status',
            name: RouteNames.imageStatus,
            builder: (context, state) {
              final leadId = state.pathParameters['leadId'] ?? '';
              // TODO: Create ImageStatusPage
              return ImageGalleryPage(leadId: leadId);
            },
          ),
          // Image capture with limit guard
          GoRoute(
            path: 'capture',
            name: RouteNames.imageCapture,
            redirect: (context, state) async {
              return await ImageLimitGuard.checkImageLimitBeforeUpload(
                context,
                state,
                ref,
              );
            },
            builder: (context, state) {
              final leadId = state.pathParameters['leadId'] ?? '';
              return ImageCapturePage(leadId: leadId);
            },
          ),
          // Image upload with limit guard
          GoRoute(
            path: 'upload',
            name: RouteNames.imageUpload,
            redirect: (context, state) async {
              return await ImageLimitGuard.checkImageLimitBeforeUpload(
                context,
                state,
                ref,
              );
            },
            builder: (context, state) {
              final leadId = state.pathParameters['leadId'] ?? '';
              return ImageUploadPage(leadId: leadId);
            },
          ),
          // Single image viewer
          GoRoute(
            path: ':imageId',
            name: RouteNames.imageViewer,
            builder: (context, state) {
              final leadId = state.pathParameters['leadId'] ?? '';
              final imageId = state.pathParameters['imageId'] ?? '';

              return ImageViewerPage(
                leadId: leadId,
                imageId: imageId,
              );
            },
            routes: [
              // Image replacement
              GoRoute(
                path: 'replace',
                name: RouteNames.imageReplacement,
                builder: (context, state) {
                  final leadId = state.pathParameters['leadId'] ?? '';
                  // final imageId = state.pathParameters['imageId'] ?? ''; // For future use

                  // Use upload page with replacement mode
                  return ImageUploadPage(
                    leadId: leadId,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ];
  }
}
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/router/route_names.dart';
import 'presentation/pages/image_viewer_page.dart';
// Simplified: keep only the image viewer route under lead detail

class LeadImageRoute {
  static List<RouteBase> getImageRoutes(WidgetRef ref) {
    return [
      // Single image viewer nested under lead detail route
      GoRoute(
        path: 'images/:imageId',
        name: RouteNames.imageViewer,
        builder: (context, state) {
          final leadId = state.pathParameters['leadId'] ?? '';
          final imageId = state.pathParameters['imageId'] ?? '';

          return ImageViewerPage(
            leadId: leadId,
            imageId: imageId,
          );
        },
      ),
    ];
  }
}

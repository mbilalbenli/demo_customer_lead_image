import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/router/route_names.dart';
import 'presentation/pages/lead_list_page.dart';
import 'presentation/pages/lead_detail_page.dart';
import 'presentation/pages/lead_create_page.dart';
import 'presentation/pages/lead_search_page.dart';
import '../lead_image/lead_image_route.dart';
// Removed separate edit and photo management pages; consolidated into LeadDetail

class LeadRoute {
  static List<RouteBase> getRoutes(WidgetRef ref) => [
        GoRoute(
          path: RouteNames.leadListPath,
          name: RouteNames.leadList,
          builder: (context, state) => LeadListPage(),
          routes: [
            // Create lead
            GoRoute(
              path: 'create',
              name: RouteNames.leadCreate,
              builder: (context, state) => const LeadCreatePage(),
            ),
            // Search leads
            GoRoute(
              path: 'search',
              name: RouteNames.leadSearch,
              builder: (context, state) => const LeadSearchPage(),
            ),
            // Lead detail with nested image routes
            GoRoute(
              path: ':leadId',
              name: RouteNames.leadDetail,
              builder: (context, state) {
                final leadId = state.pathParameters['leadId'] ?? '';
                return LeadDetailPage(leadId: leadId);
              },
              routes: [
                // Legacy image routes (kept for compatibility)
                ...LeadImageRoute.getImageRoutes(ref),
              ],
            ),
          ],
        ),
      ];
}

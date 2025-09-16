import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/lead/presentation/pages/lead_list_page.dart';
import '../../features/lead_image/presentation/pages/image_gallery_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/leads',
        name: 'leads',
        builder: (context, state) => LeadListPage(),
        routes: [
          GoRoute(
            path: ':leadId',
            name: 'leadDetail',
            builder: (context, state) {
              final leadId = state.pathParameters['leadId'] ?? '';
              return ImageGalleryPage(leadId: leadId);
            },
          ),
          GoRoute(
            path: ':leadId/images',
            name: 'leadImages',
            builder: (context, state) {
              final leadId = state.pathParameters['leadId'] ?? '';
              return ImageGalleryPage(leadId: leadId);
            },
          ),
        ],
      ),
      // Simple navigation shortcuts
      GoRoute(
        path: '/lead/:leadId',
        builder: (context, state) {
          final leadId = state.pathParameters['leadId'] ?? '';
          return ImageGalleryPage(leadId: leadId);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Page not found: ${state.uri}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/leads'),
              child: const Text('Go to Leads'),
            ),
          ],
        ),
      ),
    ),
  );
}
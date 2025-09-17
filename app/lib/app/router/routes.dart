import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/lead/lead_route.dart';
import '../../features/lead_image/lead_image_route.dart';
import '../../features/lead_image/image_replacement_route.dart';
import 'route_names.dart';
import 'guards/auth_guard.dart';

class AppRoutes {
  static GoRouter getRouter(WidgetRef ref) {
    return GoRouter(
      initialLocation: RouteNames.splashPath,
      debugLogDiagnostics: true,
      routes: [
        // Splash route
        GoRoute(
          path: RouteNames.splashPath,
          name: RouteNames.splash,
          builder: (context, state) => const SplashPage(),
        ),

        // Lead routes with nested image routes
        ...LeadRoute.routes.map((route) {
          if (route is GoRoute && route.name == RouteNames.leadDetail) {
            // Add image routes as nested routes under lead detail
            return GoRoute(
              path: route.path,
              name: route.name,
              builder: route.builder,
              redirect: route.redirect,
              routes: [
                ...route.routes,
                ...LeadImageRoute.getImageRoutes(ref),
              ],
            );
          }
          return route;
        }),

        // Image replacement flow (standalone route)
        ImageReplacementRoute.route,

        // Error fallback route
        GoRoute(
          path: RouteNames.errorPath,
          name: RouteNames.error,
          builder: (context, state) {
            final error = state.extra as String?;
            return ErrorPage(errorMessage: error);
          },
        ),
      ],

      // Error handler
      errorBuilder: (context, state) => ErrorPage(
        errorMessage: state.error?.toString(),
        path: state.uri.toString(),
      ),

      // Global redirect for auth
      redirect: (context, state) async {
        // Check authentication for protected routes
        final publicRoutes = [
          RouteNames.splashPath,
          RouteNames.errorPath,
        ];

        if (!publicRoutes.contains(state.matchedLocation)) {
          return await AuthGuard.redirectIfNotAuthenticated(context, state);
        }

        return null;
      },
    );
  }
}

class ErrorPage extends StatelessWidget {
  final String? errorMessage;
  final String? path;

  const ErrorPage({
    super.key,
    this.errorMessage,
    this.path,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        backgroundColor: Theme.of(context).colorScheme.error,
        foregroundColor: Theme.of(context).colorScheme.onError,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 24),
              Text(
                'Oops! Something went wrong',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  errorMessage!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (path != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Path: $path',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () => context.go(RouteNames.leadListPath),
                icon: const Icon(Icons.home),
                label: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
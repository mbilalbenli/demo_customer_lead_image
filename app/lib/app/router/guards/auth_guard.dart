import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/app_logger.dart';

class AuthGuard {
  static Future<String?> redirectIfNotAuthenticated(
    BuildContext context,
    GoRouterState state,
  ) async {
    try {
      // For this minimal app, we'll assume all users are authenticated
      // In a real app, you would check authentication status here
      // Example:
      // final authService = sl<AuthService>();
      // final isAuthenticated = await authService.isAuthenticated();
      // if (!isAuthenticated) {
      //   AppLogger.info('User not authenticated, redirecting to login');
      //   return '/login';
      // }

      return null; // No redirect needed
    } catch (e) {
      AppLogger.error('Error in auth guard', e);
      return '/leads'; // Redirect to lead list on error
    }
  }

  static Future<bool> canNavigate(
    BuildContext context,
    GoRouterState state,
  ) async {
    try {
      // Check if user can navigate to the requested route
      // For now, allow all navigation
      return true;
    } catch (e) {
      AppLogger.error('Error checking navigation permission', e);
      return false;
    }
  }
}

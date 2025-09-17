import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';

class AppRouter {
  static GoRouter getRouter(WidgetRef ref) => AppRoutes.getRouter(ref);
}
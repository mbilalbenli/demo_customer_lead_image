import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/base/base_page.dart';
import '../providers/splash_providers.dart';
import '../organisms/splash_loading_organism.dart';

class SplashPage extends BasePage {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends BasePageState<SplashPage> {
  @override
  void onInit() {
    super.onInit();
    Future.microtask(() async {
      final vm = ref.read(splashViewModelProvider.notifier);

      // Set the navigation callback using GoRouter
      vm.onNavigateToMain = () {
        if (mounted) {
          // Use GoRouter to navigate to the leads page
          context.go('/leads');
        }
      };

      await vm.start();
    });
  }

  @override
  Widget buildBody(BuildContext context) {
    final state = ref.watch(splashViewModelProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.surface,
              colorScheme.surface.withValues(alpha: 0.95),
              colorScheme.primary.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Center(
          child: SplashLoadingOrganism(
            loadingMessage: state.message.isEmpty ? 'Getting ready...' : state.message,
            totalSteps: 3,
            completedSteps: state.responsesCount,
            primaryColor: colorScheme.primary,
            secondaryColor: colorScheme.primary,
            textStyle: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

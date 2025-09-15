import 'package:flutter/material.dart';
import '../../../../core/presentation/base/base_page.dart';
import '../providers/splash_providers.dart';
import '../widgets/organisms/splash_content.dart';
import '../widgets/templates/splash_template.dart';
import '../../../main/presentation/pages/main_page.dart';

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
      await vm.start();
      if (mounted) {
        // Navigate to main page regardless of results
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainPage()),
        );
      }
    });
  }

  @override
  Widget buildBody(BuildContext context) {
    final state = ref.watch(splashViewModelProvider);
    return SplashTemplate(
      content: SplashContent(
        message: state.message,
        systemDone: state.systemDone,
        liveDone: state.liveDone,
        readyDone: state.readyDone,
        systemOk: state.systemOk,
        liveOk: state.liveOk,
        readyOk: state.readyOk,
      ),
    );
  }
}

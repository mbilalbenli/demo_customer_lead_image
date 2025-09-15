import 'package:flutter/material.dart';
import '../../../../../core/utils/temp_l10n.dart';
import '../atoms/app_logo.dart';
import '../molecules/loading_indicator.dart';
import '../molecules/health_check_status.dart';

class SplashContent extends StatelessWidget {
  final String message;
  final bool systemDone;
  final bool liveDone;
  final bool readyDone;
  final bool systemOk;
  final bool liveOk;
  final bool readyOk;

  const SplashContent({
    super.key,
    required this.message,
    required this.systemDone,
    required this.liveDone,
    required this.readyDone,
    required this.systemOk,
    required this.liveOk,
    required this.readyOk,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLogo(size: 80),
            const SizedBox(height: 24),
            LoadingIndicator(message: message),
            const SizedBox(height: 24),
            HealthCheckStatus(label: TempL10n.checkingHealth, done: systemDone, ok: systemOk),
            const SizedBox(height: 8),
            HealthCheckStatus(label: TempL10n.checkingLiveness, done: liveDone, ok: liveOk),
            const SizedBox(height: 8),
            HealthCheckStatus(label: TempL10n.checkingReadiness, done: readyDone, ok: readyOk),
          ],
        ),
      ),
    );
  }
}


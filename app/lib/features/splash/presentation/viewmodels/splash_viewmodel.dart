import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/health_check_result.dart';
import '../../domain/usecases/check_liveness_usecase.dart';
import '../../domain/usecases/check_readiness_usecase.dart';
import '../../domain/usecases/check_system_health_usecase.dart';
import '../states/splash_state.dart';
import '../../../../core/utils/temp_l10n.dart';

class SplashViewModel extends StateNotifier<SplashState> {
  final CheckSystemHealthUseCase _system;
  final CheckLivenessUseCase _live;
  final CheckReadinessUseCase _ready;

  SplashViewModel({
    required CheckSystemHealthUseCase system,
    required CheckLivenessUseCase live,
    required CheckReadinessUseCase ready,
  })  : _system = system,
        _live = live,
        _ready = ready,
        super(const SplashState(message: TempL10n.checkingSystem));

  Future<void> start() async {
    final completer = Completer<void>();
    Timer(const Duration(seconds: 5), () {
      if (!completer.isCompleted) completer.complete();
    });

    _runCheck(
      which: 'system',
      message: TempL10n.checkingSystem,
      call: _system.execute,
    );
    _runCheck(
      which: 'live',
      message: TempL10n.checkingLiveness,
      call: _live.execute,
    );
    _runCheck(
      which: 'ready',
      message: TempL10n.checkingReadiness,
      call: _ready.execute,
    );

    // Wait until all three complete or timeout
    while (!(state.systemDone && state.liveDone && state.readyDone)) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (completer.isCompleted) break;
    }

    state = state.copyWith(completed: true, message: TempL10n.loadingComplete);
  }

  Future<void> _runCheck({
    required String which,
    required String message,
    required Future<HealthCheckResult> Function() call,
  }) async {
    try {
      final result = await call();
      switch (which) {
        case 'system':
          state = state.copyWith(
            systemDone: true,
            systemOk: result.ok,
            message: message,
          );
          break;
        case 'live':
          state = state.copyWith(
            liveDone: true,
            liveOk: result.ok,
            message: message,
          );
          break;
        case 'ready':
          state = state.copyWith(
            readyDone: true,
            readyOk: result.ok,
            message: message,
          );
          break;
      }
    } catch (e) {
      switch (which) {
        case 'system':
          state = state.copyWith(systemDone: true, systemOk: false);
          break;
        case 'live':
          state = state.copyWith(liveDone: true, liveOk: false);
          break;
        case 'ready':
          state = state.copyWith(readyDone: true, readyOk: false);
          break;
      }
    }
  }
}


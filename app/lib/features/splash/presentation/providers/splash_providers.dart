import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../domain/usecases/check_liveness_usecase.dart';
import '../../domain/usecases/check_readiness_usecase.dart';
import '../../domain/usecases/check_system_health_usecase.dart';
import '../viewmodels/splash_viewmodel.dart';

final splashViewModelProvider = StateNotifierProvider<SplashViewModel, dynamic>((ref) {
  final sl = GetIt.instance;
  return SplashViewModel(
    system: sl<CheckSystemHealthUseCase>(),
    live: sl<CheckLivenessUseCase>(),
    ready: sl<CheckReadinessUseCase>(),
  );
});

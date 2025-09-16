import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/usecases/check_liveness_usecase.dart';
import '../../domain/usecases/check_readiness_usecase.dart';
import '../../domain/usecases/check_system_health_usecase.dart';
import '../states/splash_state.dart';

class SplashViewModel extends StateNotifier<SplashState> {
  final CheckSystemHealthUseCase _system;
  final CheckLivenessUseCase _live;
  final CheckReadinessUseCase _ready;
  Timer? _messageTimer;

  SplashViewModel({
    required CheckSystemHealthUseCase system,
    required CheckLivenessUseCase live,
    required CheckReadinessUseCase ready,
  })  : _system = system,
        _live = live,
        _ready = ready,
        super(const SplashState());

  @override
  void dispose() {
    _messageTimer?.cancel();
    super.dispose();
  }

  Future<void> start() async {
    state = state.copyWith(
      isLoading: true,
      responsesCount: 0,
      allResponsesReceived: false,
      message: 'Initializing your experience...',
      shouldNavigate: false,
      shouldRetry: false,
    );

    AppLogger.logDivider('HEALTH CHECK STARTED');
    AppLogger.info('Initiating health check requests...');
    final startTime = DateTime.now();

    // Start rotating messages
    _startLoadingMessages();

    int successCount = 0;
    int failureCount = 0;

    try {
      // Execute all 3 requests in parallel and wait for ALL to complete
      final results = await Future.wait([
        _executeWithTiming('System Health', '/api/health', _system.execute),
        _executeWithTiming('Liveness', '/api/health/live', _live.execute),
        _executeWithTiming('Readiness', '/api/health/ready', _ready.execute),
      ], eagerError: false); // Don't fail fast, wait for all

      // Count successful responses
      for (var result in results) {
        if (result != null) {
          successCount++;
        } else {
          failureCount++;
        }
      }

      final totalTime = DateTime.now().difference(startTime);

      AppLogger.logDivider('HEALTH CHECK COMPLETED');
      AppLogger.success('Total responses received: $successCount/3');
      if (failureCount > 0) {
        AppLogger.warning('Failed responses: $failureCount/3');
      }
      AppLogger.info('Total time: ${totalTime.inMilliseconds}ms');

      // Update state with results
      state = state.copyWith(
        responsesCount: successCount,
        allResponsesReceived: successCount == 3,
        isLoading: false,
        shouldNavigate: successCount == 3,
        shouldRetry: successCount < 3,
        message: successCount == 3
            ? 'All health checks passed'
            : 'Only $successCount/3 health checks passed',
      );

      if (successCount < 3) {
        AppLogger.error('Not all health checks passed. Will retry.');
        AppLogger.info('Required: 3 responses, Received: $successCount responses');
        // Schedule retry after delay
        await Future.delayed(const Duration(seconds: 2));
        start(); // Retry
      }

    } catch (e, stackTrace) {
      final totalTime = DateTime.now().difference(startTime);
      AppLogger.logDivider('HEALTH CHECK FAILED');
      AppLogger.error('Health checks failed after ${totalTime.inMilliseconds}ms', e, stackTrace);

      state = state.copyWith(
        isLoading: false,
        allResponsesReceived: false,
        responsesCount: successCount,
        message: 'Health checks failed',
        shouldRetry: true,
      );

      // Schedule retry after delay
      await Future.delayed(const Duration(seconds: 2));
      start(); // Retry
    }
  }

  Future<T?> _executeWithTiming<T>(String name, String endpoint, Future<T> Function() execute) async {
    final requestTime = DateTime.now();
    AppLogger.logRequest('$name - $endpoint');

    try {
      final result = await execute().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Request timed out after 5 seconds');
        },
      );

      final responseTime = DateTime.now();
      final duration = responseTime.difference(requestTime);

      AppLogger.logResponse('$name - $endpoint', 200, duration);

      // Update response count in real-time
      state = state.copyWith(
        responsesCount: state.responsesCount + 1,
      );

      return result;
    } catch (e) {
      final errorTime = DateTime.now();
      final duration = errorTime.difference(requestTime);

      AppLogger.logResponse('$name - $endpoint', null, duration);
      AppLogger.error('$name failed: $e');

      return null; // Return null for failed requests
    }
  }

  void _startLoadingMessages() {
    final messages = [
      'Preparing your workspace...',
      'Loading awesome features...',
      'Almost there, hang tight...',
      'Setting up your environment...',
      'Connecting to services...',
      'Optimizing performance...',
      'Finalizing setup...',
    ];

    int index = 0;
    _messageTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (state.allResponsesReceived || !state.isLoading) {
        timer.cancel();
        return;
      }
      state = state.copyWith(message: messages[index % messages.length]);
      index++;
    });
  }
}
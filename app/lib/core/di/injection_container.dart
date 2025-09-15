import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import '../infrastructure/network/api_client.dart';
import '../infrastructure/network/dio_client.dart';
import '../utils/logger_service.dart';
import '../utils/constants.dart';
import '../../features/splash/data/datasources/health_check_remote_datasource.dart';
import '../../features/splash/data/repositories/health_check_repository_impl.dart';
import '../../features/splash/domain/repositories/health_check_repository.dart';
import '../../features/splash/domain/usecases/check_system_health_usecase.dart';
import '../../features/splash/domain/usecases/check_liveness_usecase.dart';
import '../../features/splash/domain/usecases/check_readiness_usecase.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  await _initCore();
  await _initExternal();
  await _initInfrastructure();
  await _initFeatures();
}

Future<void> _initCore() async {
  sl.registerLazySingleton<LoggerService>(
    () => LoggerService(),
  );

  sl.registerLazySingleton<Constants>(
    () => Constants(),
  );
}

Future<void> _initExternal() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Secure storage not required for minimal app

  sl.registerLazySingleton<Logger>(
    () => Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 80,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
    ),
  );

  sl.registerLazySingleton<Dio>(
    () => DioClient(
      baseUrl: sl<Constants>().apiBaseUrl,
      logger: sl<LoggerService>(),
    ).dio,
  );
}

Future<void> _initInfrastructure() async {
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      dio: sl<Dio>(),
      logger: sl<LoggerService>(),
    ),
  );
}

Future<void> _initFeatures() async {
  await _initSplashFeature();
}

Future<void> _initSplashFeature() async {
  // Data source
  sl.registerLazySingleton<HealthCheckRemoteDataSource>(
    () => HealthCheckRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // Repository
  sl.registerLazySingleton<HealthCheckRepository>(
    () => HealthCheckRepositoryImpl(remote: sl<HealthCheckRemoteDataSource>()),
  );

  // Use cases
  sl.registerLazySingleton<CheckSystemHealthUseCase>(
    () => CheckSystemHealthUseCase(repository: sl<HealthCheckRepository>()),
  );
  sl.registerLazySingleton<CheckLivenessUseCase>(
    () => CheckLivenessUseCase(repository: sl<HealthCheckRepository>()),
  );
  sl.registerLazySingleton<CheckReadinessUseCase>(
    () => CheckReadinessUseCase(repository: sl<HealthCheckRepository>()),
  );
}

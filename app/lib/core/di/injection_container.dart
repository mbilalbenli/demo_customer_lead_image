import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:uuid/uuid.dart';
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

// Lead feature imports
import '../../features/lead/domain/repositories/lead_repository.dart';
import '../../features/lead/data/repositories/lead_repository_impl.dart';
import '../../features/lead/data/datasources/lead_remote_datasource.dart';
import '../../features/lead/data/datasources/lead_local_datasource.dart';
import '../../features/lead/application/use_cases/get_lead_by_id_use_case.dart';
import '../../features/lead/application/use_cases/get_leads_list_use_case.dart';

// Lead Image feature imports
import '../../features/lead_image/domain/repositories/lead_image_repository.dart';
import '../../features/lead_image/data/repositories/lead_image_repository_impl.dart';
import '../../features/lead_image/data/datasources/image_remote_datasource.dart';
import '../../features/lead_image/data/datasources/image_cache_datasource.dart';
import '../../features/lead_image/application/use_cases/get_images_by_lead_use_case.dart';
import '../../features/lead_image/application/use_cases/upload_image_use_case.dart';
import '../../features/lead_image/application/use_cases/delete_image_use_case.dart';
import '../../features/lead_image/application/use_cases/get_image_status_use_case.dart';

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

  // Additional dependencies for Lead Image feature
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<Uuid>(() => const Uuid());
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
  await _initLeadFeature();
  await _initLeadImageFeature();
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

Future<void> _initLeadFeature() async {
  // Data sources
  sl.registerLazySingleton<LeadRemoteDataSource>(
    () => LeadRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<LeadLocalDataSource>(
    () => LeadLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );

  // Repository
  sl.registerLazySingleton<LeadRepository>(
    () => LeadRepositoryImpl(
      remoteDataSource: sl<LeadRemoteDataSource>(),
      localDataSource: sl<LeadLocalDataSource>(),
      connectivity: sl<Connectivity>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetLeadByIdUseCase(sl<LeadRepository>()));
  sl.registerLazySingleton(() => GetLeadsListUseCase(sl<LeadRepository>()));
}

Future<void> _initLeadImageFeature() async {
  // Data sources
  sl.registerLazySingleton<ImageRemoteDataSource>(
    () => ImageRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<ImageCacheDataSource>(
    () => ImageCacheDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );

  // Repository
  sl.registerLazySingleton<LeadImageRepository>(
    () => LeadImageRepositoryImpl(
      remoteDataSource: sl<ImageRemoteDataSource>(),
      cacheDataSource: sl<ImageCacheDataSource>(),
      connectivity: sl<Connectivity>(),
      uuid: sl<Uuid>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetImagesByLeadUseCase(sl<LeadImageRepository>()));
  sl.registerLazySingleton(() => UploadImageUseCase(sl<LeadImageRepository>()));
  sl.registerLazySingleton(() => DeleteImageUseCase(sl<LeadImageRepository>()));
  sl.registerLazySingleton(() => GetImageStatusUseCase(sl<LeadImageRepository>()));
}

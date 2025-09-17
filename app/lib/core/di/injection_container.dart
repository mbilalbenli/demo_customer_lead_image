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

// Feature injectors
import 'feature_injectors/lead_injector.dart';
import 'feature_injectors/lead_image_injector.dart';
import 'feature_injectors/base64_processor_injector.dart';

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
  // Initialize features using feature-specific injectors
  LeadInjector.initialize(sl);
  LeadImageInjector.initialize(sl);
  Base64ProcessorInjector.initialize(sl);
}

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../security/base64_validator.dart';
import '../../infrastructure/services/permission_service.dart';
import '../../infrastructure/services/base64_media_service.dart';
import '../../infrastructure/storage/base64_cache_manager.dart';

class Base64ProcessorInjector {
  static void initialize(GetIt sl) {
    // Domain services
    sl.registerLazySingleton(() => Base64Validator());

    // Infrastructure services
    sl.registerLazySingleton(() => PermissionService());
    sl.registerLazySingleton(() => Base64MediaService());

    // Cache management
    sl.registerLazySingleton(() => Base64CacheManager(
      prefs: sl<SharedPreferences>(),
    ));
  }
}

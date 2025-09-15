import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static const String appName = 'System Monitor';
  static const String appVersion = '1.0.0';

  String get apiBaseUrl =>
      (dotenv.isInitialized ? dotenv.env['API_BASE_URL'] : null) ??
      // Use 10.0.2.2 for Android emulator to reach host machine
      'http://10.0.2.2:5000';

  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration cacheTimeout = Duration(minutes: 5);
  static const Duration refreshInterval = Duration(seconds: 10);

  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm:ss';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';

  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  static const double defaultRadius = 8.0;
  static const double smallRadius = 4.0;
  static const double largeRadius = 16.0;

  static const double defaultElevation = 2.0;
  static const double smallElevation = 1.0;
  static const double largeElevation = 4.0;
}

class ApiEndpoints {
  ApiEndpoints._();

  static const String health = '/api/health';
  static const String healthLive = '/api/health/live';
  static const String healthReady = '/api/health/ready';
}

class StorageKeys {
  StorageKeys._();

  static const String theme = 'theme';
  static const String locale = 'locale';
  static const String firstLaunch = 'first_launch';
  static const String authToken = 'auth_token';
  static const String refreshToken = 'refresh_token';
  static const String userData = 'user_data';
}

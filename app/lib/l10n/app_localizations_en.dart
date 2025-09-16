// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'System Monitor';

  @override
  String get systemMonitorTitle => 'System Monitor';

  @override
  String get systemMonitorSubtitle => 'Monitor backend health status';

  @override
  String get healthStatus => 'Health Status';

  @override
  String get overallHealth => 'Overall Health';

  @override
  String get liveStatus => 'Live Status';

  @override
  String get readyStatus => 'Ready Status';

  @override
  String get healthy => 'Healthy';

  @override
  String get unhealthy => 'Unhealthy';

  @override
  String get degraded => 'Degraded';

  @override
  String get checking => 'Checking...';

  @override
  String get unknown => 'Unknown';

  @override
  String lastUpdated(String time) {
    return 'Last updated: $time';
  }

  @override
  String get refreshing => 'Refreshing...';

  @override
  String get refresh => 'Refresh';

  @override
  String get autoRefresh => 'Auto Refresh';

  @override
  String autoRefreshInterval(int seconds) {
    return 'Refresh every $seconds seconds';
  }

  @override
  String get connectionError => 'Connection Error';

  @override
  String get connectionErrorMessage => 'Unable to connect to backend service';

  @override
  String get retry => 'Retry';

  @override
  String get details => 'Details';

  @override
  String get serviceName => 'Service Name';

  @override
  String get serviceStatus => 'Service Status';

  @override
  String get responseTime => 'Response Time';

  @override
  String responseTimeMs(int ms) {
    return '$ms ms';
  }

  @override
  String get database => 'Database';

  @override
  String get api => 'API';

  @override
  String get cache => 'Cache';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get close => 'Close';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';
}

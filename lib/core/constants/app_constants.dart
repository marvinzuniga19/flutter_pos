class AppConstants {
  static const String appName = 'POS Nicaragua';
  static const String appVersion = '1.0.0';

  // Supported locales
  static const List<String> supportedLocales = ['es-NI'];

  // Database
  static const String databaseName = 'pos_nicaragua.db';
  static const int databaseVersion = 1;

  // Pagination
  static const int defaultPageSize = 20;

  // Cache
  static const Duration defaultCacheTimeout = Duration(hours: 24);

  // API timeout
  static const Duration defaultApiTimeout = Duration(seconds: 30);

  // Bluetooth
  static const Duration bluetoothScanTimeout = Duration(seconds: 10);

  // Session
  static const Duration sessionTimeout = Duration(hours: 8);
}

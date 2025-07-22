class AppConfig {
  static const String appName = 'Restaurant POS';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = '';
  static const String apiVersion = 'v1';
  
  // App Settings
  static const int itemsPerPage = 20;
  static const int orderTimeoutMinutes = 30;
  static const String defaultCurrency = 'IDR';
  
  // Database Configuration
  static const String databaseName = 'restaurant_pos.db';
  static const int databaseVersion = 1;
  
  // Printer Configuration
  static const String defaultPrinterName = '';
  static const int printTimeout = 10000;
}

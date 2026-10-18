class ApiConstants {
  // Judge0 CE Public RapidAPI / Self-Hosted base URLs
  static const String judge0BaseUrl = 'https://judge0-ce.p.rapidapi.com';
  
  // Laravel Backend API Base URL (Configurable for local / cloud server)
  static const String backendBaseUrl = 'https://api.codeverse.dev/api/v1';

  // RapidAPI Headers (Can be configured in app settings or environment)
  static const String rapidApiKeyHeader = 'x-rapidapi-key';
  static const String rapidApiHostHeader = 'x-rapidapi-host';
  static const String judge0Host = 'judge0-ce.p.rapidapi.com';

  // Request Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 25);
}

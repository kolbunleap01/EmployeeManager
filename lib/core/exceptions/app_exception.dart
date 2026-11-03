enum AppExceptionType {
  network,
  timeout,
  server,
  invalidResponse,
  unauthorized,
  validation,
}

class AppException implements Exception {
  const AppException(this.message, this.type);

  final String message;
  final AppExceptionType type;

  @override
  String toString() => message;
}

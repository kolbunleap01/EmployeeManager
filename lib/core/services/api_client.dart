import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

import '../../app/routes/app_routes.dart';
import '../constants/api_constants.dart';
import '../exceptions/app_exception.dart';
import 'storage_service.dart';

class ApiClient {
  ApiClient(this._storage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.readToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authz'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await _storage.clearSession();
            if (Get.currentRoute != AppRoutes.login) {
              Get.offAllNamed(AppRoutes.login);
              Get.snackbar(
                'Session expired',
                'Please sign in again to continue.',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  final StorageService _storage;
  late final Dio _dio;

  Future<Response<dynamic>> get(String path, {Map<String, dynamic>? query}) =>
      _dio.get(path, queryParameters: query);
  Future<Response<dynamic>> post(String path, {Object? data}) =>
      _dio.post(path, data: data);
  Future<Response<dynamic>> put(String path, {Object? data}) =>
      _dio.put(path, data: data);
  Future<Response<dynamic>> delete(String path) => _dio.delete(path);

  static AppException mapError(Object error) {
    if (error is AppException) return error;
    if (error is DioException) {
      final status = error.response?.statusCode;
      if (status == 401) {
        return const AppException(
          'Your session has expired. Please sign in again.',
          AppExceptionType.unauthorized,
        );
      }
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return const AppException(
          'The request took too long. Check your connection and try again.',
          AppExceptionType.timeout,
        );
      }
      if (error.type == DioExceptionType.connectionError) {
        return const AppException(
          'Unable to connect. Check your internet connection.',
          AppExceptionType.network,
        );
      }
      if (status != null && status >= 500) {
        return const AppException(
          'The server is unavailable right now. Please try again later.',
          AppExceptionType.server,
        );
      }
      final data = error.response?.data;
      final message = data is Map ? data['message'] as String? : null;
      return AppException(
        message ?? 'Something went wrong. Please try again.',
        AppExceptionType.server,
      );
    }
    return const AppException(
      'Unexpected response received. Please try again.',
      AppExceptionType.invalidResponse,
    );
  }
}

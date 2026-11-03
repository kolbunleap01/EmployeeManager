import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  AuthController(this._repository, this._storage);

  final AuthRepository _repository;
  final StorageService _storage;
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController(
    text: AppConstants.defaultUsername,
  );
  final passwordController = TextEditingController(
    text: AppConstants.defaultPassword,
  );
  final isLoading = false.obs;
  final isAuthenticated = false.obs;
  final isPasswordVisible = false.obs;
  final currentUser = Rxn<UserModel>();
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    restoreSession();
  }

  Future<void> restoreSession() async {
    final token = await _storage.readToken();
    if (token == null || token.isEmpty) return;
    currentUser.value = await _storage.readUser();
    isAuthenticated.value = true;
    if (Get.currentRoute == AppRoutes.login) Get.offAllNamed(AppRoutes.home);
  }

  Future<void> login() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final response = await _repository.login(
        usernameController.text.trim(),
        passwordController.text,
      );
      if (response.accessToken.isEmpty) {
        throw const FormatException('Missing access token');
      }
      await _storage.saveSession(response.accessToken, response.user);
      currentUser.value = response.user;
      isAuthenticated.value = true;
      Get.offAllNamed(AppRoutes.home);
    } on Object catch (error) {
      final exception = error is FormatException
          ? 'Invalid server response. Please try again.'
          : ApiClient.mapError(error).message;
      errorMessage.value = exception;
      SnackbarHelper.error(exception);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _storage.clearSession();
    currentUser.value = null;
    isAuthenticated.value = false;
    Get.offAllNamed(AppRoutes.login);
  }

  String? validateUsername(String? value) =>
      Validators.required(value, field: 'Username');
  String? validatePassword(String? value) {
    final result = Validators.required(value, field: 'Password');
    if (result != null) return result;
    return value!.length < 6 ? 'Password must be at least 6 characters.' : null;
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

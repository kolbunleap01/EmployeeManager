import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract final class SnackbarHelper {
  static void success(String message) => Get.snackbar(
    'Success',
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: const Color(0xFFDCFCE7),
    colorText: const Color(0xFF166534),
    margin: const EdgeInsets.all(16),
  );

  static void error(String message) => Get.snackbar(
    'Something went wrong',
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: const Color(0xFFFEE2E2),
    colorText: const Color(0xFF991B1B),
    margin: const EdgeInsets.all(16),
  );
}

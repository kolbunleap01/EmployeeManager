import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/models/user_model.dart';
import '../constants/app_constants.dart';

class StorageService {
  StorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<String?> readToken() => _storage.read(key: AppConstants.tokenKey);

  Future<void> saveSession(String token, UserModel user) async {
    await _storage.write(key: AppConstants.tokenKey, value: token);
    await _storage.write(
      key: AppConstants.userKey,
      value: jsonEncode(user.toJson()),
    );
  }

  Future<UserModel?> readUser() async {
    final value = await _storage.read(key: AppConstants.userKey);
    if (value == null || value.isEmpty) return null;
    try {
      return UserModel.fromJson(jsonDecode(value) as Map<String, dynamic>);
    } on Object {
      return null;
    }
  }

  Future<void> clearSession() async {
    await _storage.delete(key: AppConstants.tokenKey);
    await _storage.delete(key: AppConstants.userKey);
  }
}

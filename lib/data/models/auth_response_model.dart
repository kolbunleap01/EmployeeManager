import 'user_model.dart';

class AuthResponseModel {
  const AuthResponseModel({required this.accessToken, required this.user});

  final String accessToken;
  final UserModel user;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final accessToken = json['accessToken'];
    final legacyToken = json['token'];
    return AuthResponseModel(
      accessToken: accessToken is String
          ? accessToken
          : legacyToken is String
          ? legacyToken
          : '',
      user: UserModel.fromJson(json),
    );
  }
}

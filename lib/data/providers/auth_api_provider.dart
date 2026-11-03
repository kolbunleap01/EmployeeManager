import '../../core/constants/api_constants.dart';
import '../../core/services/api_client.dart';
import '../models/auth_response_model.dart';

class AuthApiProvider {
  AuthApiProvider(this._client);

  final ApiClient _client;

  Future<AuthResponseModel> login(String username, String password) async {
    final response = await _client.post(
      ApiConstants.login,
      data: {'username': username, 'password': password},
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid login response');
    }
    return AuthResponseModel.fromJson(data);
  }
}

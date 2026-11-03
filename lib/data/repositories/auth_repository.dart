import '../models/auth_response_model.dart';
import '../providers/auth_api_provider.dart';

class AuthRepository {
  AuthRepository(this._provider);

  final AuthApiProvider _provider;

  Future<AuthResponseModel> login(String username, String password) =>
      _provider.login(username, password);
}

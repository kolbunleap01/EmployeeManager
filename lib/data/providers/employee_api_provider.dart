import '../../core/constants/api_constants.dart';
import '../../core/services/api_client.dart';
import '../models/employee_model.dart';

class EmployeeApiProvider {
  EmployeeApiProvider(this._client);

  final ApiClient _client;

  Future<List<EmployeeModel>> getEmployees() async {
    final response = await _client.get(ApiConstants.users);
    final data = response.data;
    if (data is! Map<String, dynamic> || data['users'] is! List) {
      throw const FormatException('Invalid employees response');
    }
    return (data['users'] as List)
        .whereType<Map<String, dynamic>>()
        .map(EmployeeModel.fromJson)
        .toList();
  }

  Future<EmployeeModel> addEmployee(EmployeeModel employee) async {
    final response = await _client.post(
      ApiConstants.addUser,
      data: employee.toJson(),
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid employee response');
    }
    return EmployeeModel.fromJson(data);
  }

  Future<EmployeeModel> updateEmployee(EmployeeModel employee) async {
    final response = await _client.put(
      ApiConstants.user(employee.id),
      data: employee.toJson(),
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid employee response');
    }
    return EmployeeModel.fromJson(data);
  }

  Future<void> deleteEmployee(int id) async {
    await _client.delete(ApiConstants.user(id));
  }
}

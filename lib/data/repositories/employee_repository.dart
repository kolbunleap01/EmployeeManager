import '../models/employee_model.dart';
import '../providers/employee_api_provider.dart';

class EmployeeRepository {
  EmployeeRepository(this._provider);

  final EmployeeApiProvider _provider;

  Future<List<EmployeeModel>> getEmployees() => _provider.getEmployees();
  Future<EmployeeModel> addEmployee(EmployeeModel employee) =>
      _provider.addEmployee(employee);
  Future<EmployeeModel> updateEmployee(EmployeeModel employee) =>
      _provider.updateEmployee(employee);
  Future<void> deleteEmployee(int id) => _provider.deleteEmployee(id);
}

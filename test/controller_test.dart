import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:employee_manager/core/services/api_client.dart';
import 'package:employee_manager/core/services/storage_service.dart';
import 'package:employee_manager/core/utils/validators.dart';
import 'package:employee_manager/data/providers/auth_api_provider.dart';
import 'package:employee_manager/data/providers/employee_api_provider.dart';
import 'package:employee_manager/data/models/employee_model.dart';
import 'package:employee_manager/data/repositories/auth_repository.dart';
import 'package:employee_manager/data/repositories/employee_repository.dart';
import 'package:employee_manager/modules/employees/controllers/employee_controller.dart';
import 'package:employee_manager/modules/auth/controllers/auth_controller.dart';

class _FakeEmployeeRepository extends EmployeeRepository {
  _FakeEmployeeRepository() : super(_UnusedEmployeeProvider());

  bool deleteCalled = false;

  @override
  Future<List<EmployeeModel>> getEmployees() async => const [];

  @override
  Future<void> deleteEmployee(int id) async {
    deleteCalled = true;
  }
}

class _UnusedEmployeeProvider extends EmployeeApiProvider {
  _UnusedEmployeeProvider() : super(ApiClient(StorageService()));
}

void main() {
  test('login controller validation exposes required state rules', () {
    final storage = StorageService();
    final client = ApiClient(storage);
    final repository = AuthRepository(AuthApiProvider(client));
    final controller = AuthController(repository, storage);

    expect(controller.isLoading.value, isFalse);
    expect(controller.validateUsername(null), 'Username is required.');
    expect(
      controller.validatePassword('short'),
      'Password must be at least 6 characters.',
    );
    expect(controller.validatePassword('emilyspass'), isNull);

    controller.onClose();
  });

  test('employee form validators cover required fields and age', () {
    expect(
      Validators.required(null, field: 'First name'),
      'First name is required.',
    );
    expect(Validators.age('0'), 'Enter a valid age between 1 and 120.');
    expect(Validators.age('28'), isNull);
  });

  test('employee controller starts with an empty reactive state', () {
    final controller = EmployeeController(
      repository: _FakeEmployeeRepository(),
    );

    expect(controller.employees, isEmpty);
    expect(controller.isLoading.value, isFalse);
    expect(controller.isSubmitting.value, isFalse);
    expect(controller.isEditing, isFalse);

    controller.onClose();
  });

  testWidgets('delete confirmation does not delete when cancelled', (
    tester,
  ) async {
    final repository = _FakeEmployeeRepository();
    final controller = EmployeeController(repository: repository);
    const employee = EmployeeModel(
      id: 1,
      firstName: 'Ava',
      lastName: 'Stone',
      email: 'ava@example.com',
      phone: '555-0100',
      age: 31,
      image: '',
      department: 'Engineering',
      company: 'Acme',
    );
    controller.employees.add(employee);

    await tester.pumpWidget(
      GetMaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => controller.delete(employee),
            child: const Text('Open delete'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open delete'));
    await tester.pumpAndSettle();
    expect(find.text('Delete employee?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(repository.deleteCalled, isFalse);
    expect(controller.employees, contains(employee));
    controller.onClose();
  });
}

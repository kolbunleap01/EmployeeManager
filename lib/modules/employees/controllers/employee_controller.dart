import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/services/api_client.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/employee_model.dart';
import '../../../data/repositories/employee_repository.dart';

class EmployeeController extends GetxController {
  EmployeeController({EmployeeRepository? repository})
    : _repository = repository ?? Get.find<EmployeeRepository>();

  final EmployeeRepository _repository;
  final employees = <EmployeeModel>[].obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final errorMessage = RxnString();
  final editingEmployee = Rxn<EmployeeModel>();
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();
  final departmentController = TextEditingController();
  final companyController = TextEditingController();

  bool get isEditing => editingEmployee.value != null;

  @override
  void onReady() {
    super.onReady();
    if (Get.currentRoute == AppRoutes.employees) loadEmployees();
  }

  Future<void> loadEmployees() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      employees.assignAll(await _repository.getEmployees());
    } on Object catch (error) {
      errorMessage.value = ApiClient.mapError(error).message;
    } finally {
      isLoading.value = false;
    }
  }

  void startAdd() {
    editingEmployee.value = null;
    _clearForm();
  }

  void startEdit(EmployeeModel employee) {
    editingEmployee.value = employee;
    firstNameController.text = employee.firstName;
    lastNameController.text = employee.lastName;
    emailController.text = employee.email;
    phoneController.text = employee.phone;
    ageController.text = employee.age.toString();
    departmentController.text = employee.department;
    companyController.text = employee.company;
  }

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    isSubmitting.value = true;
    try {
      final draft = EmployeeModel(
        id: editingEmployee.value?.id ?? 0,
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        age: int.parse(ageController.text.trim()),
        image: editingEmployee.value?.image ?? '',
        department: departmentController.text.trim(),
        company: companyController.text.trim(),
      );
      if (isEditing) {
        final saved = await _repository.updateEmployee(draft);
        _replaceEmployee(
          saved.copyWith(
            firstName: draft.firstName,
            lastName: draft.lastName,
            email: draft.email,
            phone: draft.phone,
            age: draft.age,
            department: draft.department,
            company: draft.company,
          ),
        );
        SnackbarHelper.success('Employee updated successfully.');
      } else {
        final saved = await _repository.addEmployee(draft);
        employees.insert(
          0,
          saved.copyWith(
            firstName: draft.firstName,
            lastName: draft.lastName,
            email: draft.email,
            phone: draft.phone,
            age: draft.age,
            department: draft.department,
            company: draft.company,
          ),
        );
        SnackbarHelper.success('Employee added successfully.');
      }
      Get.back(result: true);
    } on Object catch (error) {
      SnackbarHelper.error(ApiClient.mapError(error).message);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> delete(EmployeeModel employee) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete employee?'),
        content: Text('Remove ${employee.fullName} from the employee list?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Get.back(result: true),
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    isLoading.value = true;
    try {
      await _repository.deleteEmployee(employee.id);
      employees.removeWhere((item) => item.id == employee.id);
      SnackbarHelper.success('Employee deleted successfully.');
    } on Object catch (error) {
      SnackbarHelper.error(ApiClient.mapError(error).message);
    } finally {
      isLoading.value = false;
    }
  }

  void _replaceEmployee(EmployeeModel updated) {
    final index = employees.indexWhere((employee) => employee.id == updated.id);
    if (index >= 0) employees[index] = updated;
  }

  void _clearForm() {
    for (final controller in [
      firstNameController,
      lastNameController,
      emailController,
      phoneController,
      ageController,
      departmentController,
      companyController,
    ]) {
      controller.clear();
    }
  }

  String? required(String? value, {String field = 'This field'}) =>
      Validators.required(value, field: field);
  String? email(String? value) => Validators.email(value);
  String? phone(String? value) => Validators.phone(value);
  String? age(String? value) => Validators.age(value);

  @override
  void onClose() {
    for (final controller in [
      firstNameController,
      lastNameController,
      emailController,
      phoneController,
      ageController,
      departmentController,
      companyController,
    ]) {
      controller.dispose();
    }
    super.onClose();
  }
}

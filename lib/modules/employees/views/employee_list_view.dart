import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../shared/widgets/employee_card.dart';
import '../../../shared/widgets/empty_widget.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../controllers/employee_controller.dart';

class EmployeeListView extends GetView<EmployeeController> {
  const EmployeeListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employees')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.startAdd();
          Get.toNamed(AppRoutes.addEmployee);
        },
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text('Add employee'),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.employees.isEmpty) {
          return const LoadingWidget(message: 'Loading employees...');
        }
        final error = controller.errorMessage.value;
        if (error != null && controller.employees.isEmpty) {
          return AppErrorWidget(
            message: error,
            onRetry: controller.loadEmployees,
          );
        }
        if (controller.employees.isEmpty) {
          return const EmptyWidget(
            title: 'No employees yet',
            message: 'Add your first employee to start building your team.',
          );
        }
        return RefreshIndicator(
          onRefresh: controller.loadEmployees,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
            itemCount: controller.employees.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              final employee = controller.employees[index];
              return EmployeeCard(
                employee: employee,
                onEdit: () {
                  controller.startEdit(employee);
                  Get.toNamed(AppRoutes.editEmployee, arguments: employee);
                },
                onDelete: () => controller.delete(employee),
              );
            },
          ),
        );
      }),
    );
  }
}

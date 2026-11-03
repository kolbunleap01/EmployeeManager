import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/app_text_field.dart';
import '../controllers/employee_controller.dart';

class EmployeeFormView extends GetView<EmployeeController> {
  const EmployeeFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final editing = controller.isEditing;
    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'Edit Employee' : 'Add Employee')),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            Text(
              editing ? 'Update employee details' : 'Add someone to your team',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('Keep contact and organization information accurate.'),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final twoColumns = constraints.maxWidth >= 560;
                final fields = [
                  AppTextField(
                    controller: controller.firstNameController,
                    label: 'First name',
                    validator: (value) =>
                        controller.required(value, field: 'First name'),
                  ),
                  AppTextField(
                    controller: controller.lastNameController,
                    label: 'Last name',
                    validator: (value) =>
                        controller.required(value, field: 'Last name'),
                  ),
                  AppTextField(
                    controller: controller.emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: controller.email,
                  ),
                  AppTextField(
                    controller: controller.phoneController,
                    label: 'Phone',
                    keyboardType: TextInputType.phone,
                    validator: controller.phone,
                  ),
                  AppTextField(
                    controller: controller.ageController,
                    label: 'Age',
                    keyboardType: TextInputType.number,
                    validator: controller.age,
                  ),
                  AppTextField(
                    controller: controller.departmentController,
                    label: 'Department',
                    validator: (value) =>
                        controller.required(value, field: 'Department'),
                  ),
                  AppTextField(
                    controller: controller.companyController,
                    label: 'Company',
                    validator: (value) =>
                        controller.required(value, field: 'Company'),
                  ),
                ];
                if (!twoColumns) {
                  return Column(
                    children: [
                      for (final field in fields) ...[
                        field,
                        const SizedBox(height: 16),
                      ],
                    ],
                  );
                }
                return Wrap(
                  runSpacing: 16,
                  spacing: 16,
                  children: fields
                      .map(
                        (field) => SizedBox(
                          width: (constraints.maxWidth - 16) / 2,
                          child: field,
                        ),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 12),
            Obx(
              () => ElevatedButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : controller.submit,
                child: controller.isSubmitting.value
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(editing ? 'Save changes' : 'Add employee'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

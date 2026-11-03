import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_theme.dart';
import '../../../modules/auth/controllers/auth_controller.dart';
import '../../../shared/widgets/app_text_field.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.people_alt_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Welcome back',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sign in to manage your team and explore products.',
                    ),
                    const SizedBox(height: 32),
                    AppTextField(
                      controller: controller.usernameController,
                      label: 'Username',
                      hint: 'Enter your username',
                      validator: controller.validateUsername,
                      textInputAction: TextInputAction.next,
                      suffixIcon: const Icon(Icons.person_outline_rounded),
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => AppTextField(
                        controller: controller.passwordController,
                        label: 'Password',
                        hint: 'Enter your password',
                        validator: controller.validatePassword,
                        obscureText: !controller.isPasswordVisible.value,
                        textInputAction: TextInputAction.done,
                        suffixIcon: IconButton(
                          onPressed: controller.isPasswordVisible.toggle,
                          icon: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Demo credentials are pre-filled for convenience.',
                    ),
                    const SizedBox(height: 26),
                    Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.login,
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Sign in'),
                      ),
                    ),
                    Obx(() {
                      final error = controller.errorMessage.value;
                      return error == null
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Text(
                                error,
                                style: const TextStyle(color: Colors.redAccent),
                              ),
                            );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

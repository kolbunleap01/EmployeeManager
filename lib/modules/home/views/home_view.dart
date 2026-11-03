import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_theme.dart';
import '../../../modules/auth/controllers/auth_controller.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Manager'),
        actions: [
          IconButton(
            tooltip: 'Log out',
            onPressed: () => _confirmLogout(auth),
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.loadCounts,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
          children: [
            Obx(() {
              final name = auth.currentUser.value?.firstName;
              return Text(
                name == null || name.isEmpty
                    ? 'Welcome back'
                    : 'Welcome back, $name',
                style: Theme.of(context).textTheme.headlineMedium,
              );
            }),
            const SizedBox(height: 8),
            const Text(
              'Keep your team organized and your work moving forward.',
            ),
            const SizedBox(height: 24),
            Obx(
              () => controller.isLoading.value
                  ? const SizedBox(height: 96, child: LoadingWidget())
                  : Row(
                      children: [
                        Expanded(
                          child: _MetricCard(
                            label: 'Products',
                            value: controller.productCount.value.toString(),
                            icon: Icons.inventory_2_outlined,
                            color: const Color(0xFFE0EAFF),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MetricCard(
                            label: 'Employees',
                            value: controller.employeeCount.value.toString(),
                            icon: Icons.groups_2_outlined,
                            color: const Color(0xFFDCFCE7),
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 26),
            Text('Workspace', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 14),
            _ActionCard(
              icon: Icons.inventory_2_outlined,
              title: 'Browse products',
              description: 'Review pricing, categories, and product ratings.',
              onTap: () => Get.toNamed(AppRoutes.products),
            ),
            const SizedBox(height: 12),
            _ActionCard(
              icon: Icons.groups_2_outlined,
              title: 'Manage employees',
              description:
                  'Add, edit, and remove members of your organization.',
              onTap: () => Get.toNamed(AppRoutes.employees),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(AuthController auth) async {
    final shouldLogout = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Log out?'),
        content: const Text(
          'You will need to sign in again to access the workspace.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (shouldLogout == true) auth.logout();
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: AppTheme.primary),
            ),
            const SizedBox(height: 16),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFE0EAFF),
                child: Icon(icon, color: AppTheme.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(description),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

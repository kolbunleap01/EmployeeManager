import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/models/employee_model.dart';

class EmployeeCard extends StatelessWidget {
  const EmployeeCard({
    required this.employee,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final EmployeeModel employee;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFFE0EAFF),
              child: employee.image.isEmpty
                  ? Text(
                      employee.firstName.isEmpty
                          ? '?'
                          : employee.firstName[0].toUpperCase(),
                    )
                  : ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: employee.image,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorWidget: (_, _, _) =>
                            Text(employee.firstName[0].toUpperCase()),
                      ),
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee.fullName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 5),
                  Text(employee.email, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text(employee.phone, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: [
                      _InfoChip(
                        icon: Icons.apartment_rounded,
                        label: employee.company.isEmpty
                            ? 'Company unavailable'
                            : employee.company,
                      ),
                      if (employee.department.isNotEmpty)
                        _InfoChip(
                          icon: Icons.work_outline_rounded,
                          label: employee.department,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) => value == 'edit' ? onEdit() : onDelete(),
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 15),
      label: Text(label, overflow: TextOverflow.ellipsis),
      visualDensity: VisualDensity.compact,
      side: BorderSide.none,
      backgroundColor: const Color(0xFFF1F5F9),
    );
  }
}

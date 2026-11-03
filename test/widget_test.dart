import 'package:flutter_test/flutter_test.dart';

import 'package:employee_manager/core/utils/validators.dart';
import 'package:employee_manager/data/models/employee_model.dart';
import 'package:employee_manager/data/models/product_model.dart';

void main() {
  group('Validators', () {
    test('required validator rejects blank values', () {
      expect(Validators.required(''), 'This field is required.');
      expect(
        Validators.required('  ', field: 'Department'),
        'Department is required.',
      );
      expect(Validators.required('A', field: 'Name'), isNull);
    });

    test('email validator accepts valid email and rejects invalid email', () {
      expect(Validators.email('person@example.com'), isNull);
      expect(
        Validators.email('person@example'),
        'Enter a valid email address.',
      );
    });
  });

  test('employee model parses nested company JSON', () {
    final employee = EmployeeModel.fromJson({
      'id': 7,
      'firstName': 'Ava',
      'lastName': 'Stone',
      'email': 'ava@example.com',
      'phone': '555-0100',
      'age': 31,
      'image': 'https://example.com/ava.png',
      'company': {'name': 'Acme', 'department': 'Engineering'},
    });

    expect(employee.id, 7);
    expect(employee.fullName, 'Ava Stone');
    expect(employee.company, 'Acme');
    expect(employee.department, 'Engineering');
  });

  test('product model parses numeric fields', () {
    final product = ProductModel.fromJson({
      'id': 3,
      'title': 'Desk lamp',
      'description': 'A warm desk lamp',
      'price': 19.5,
      'category': 'lighting',
      'rating': 4.25,
      'thumbnail': 'https://example.com/lamp.png',
    });

    expect(product.id, 3);
    expect(product.price, 19.5);
    expect(product.rating, 4.25);
  });
}

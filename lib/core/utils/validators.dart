abstract final class Validators {
  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$field is required.';
    return null;
  }

  static String? email(String? value) {
    final requiredError = required(value, field: 'Email');
    if (requiredError != null) return requiredError;
    final valid = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value!.trim());
    return valid ? null : 'Enter a valid email address.';
  }

  static String? phone(String? value) => required(value, field: 'Phone');

  static String? age(String? value) {
    final requiredError = required(value, field: 'Age');
    if (requiredError != null) return requiredError;
    final parsed = int.tryParse(value!.trim());
    return parsed != null && parsed > 0 && parsed <= 120
        ? null
        : 'Enter a valid age between 1 and 120.';
  }
}

class EmployeeModel {
  const EmployeeModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.age,
    required this.image,
    required this.department,
    required this.company,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final int age;
  final String image;
  final String department;
  final String company;

  String get fullName => '$firstName $lastName'.trim();

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    final companyMap = json['company'] is Map
        ? Map<String, dynamic>.from(json['company'] as Map)
        : <String, dynamic>{};
    return EmployeeModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      age: (json['age'] as num?)?.toInt() ?? 0,
      image: json['image'] as String? ?? '',
      department:
          json['department'] as String? ??
          companyMap['department'] as String? ??
          '',
      company:
          companyMap['name'] as String? ?? json['companyName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phone': phone,
    'age': age,
    'image': image,
    'department': department,
    'company': {'name': company, 'department': department},
  };

  EmployeeModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    int? age,
    String? image,
    String? department,
    String? company,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      age: age ?? this.age,
      image: image ?? this.image,
      department: department ?? this.department,
      company: company ?? this.company,
    );
  }
}

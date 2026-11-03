import 'package:get/get.dart';

import '../../../data/repositories/employee_repository.dart';
import '../../../data/repositories/product_repository.dart';

class HomeController extends GetxController {
  HomeController({
    ProductRepository? productRepository,
    EmployeeRepository? employeeRepository,
  }) : _productRepository = productRepository ?? Get.find<ProductRepository>(),
       _employeeRepository =
           employeeRepository ?? Get.find<EmployeeRepository>();

  final ProductRepository _productRepository;
  final EmployeeRepository _employeeRepository;
  final productCount = 0.obs;
  final employeeCount = 0.obs;
  final isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    loadCounts();
  }

  Future<void> loadCounts() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        _productRepository.getProducts(),
        _employeeRepository.getEmployees(),
      ]);
      productCount.value = (results[0] as List).length;
      employeeCount.value = (results[1] as List).length;
    } on Object {
      // Dashboard counts are supplementary; destination pages expose retryable errors.
    } finally {
      isLoading.value = false;
    }
  }
}

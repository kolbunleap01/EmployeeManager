import 'package:get/get.dart';

import '../../core/services/api_client.dart';
import '../../core/services/storage_service.dart';
import '../../data/providers/auth_api_provider.dart';
import '../../data/providers/employee_api_provider.dart';
import '../../data/providers/product_api_provider.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/employee_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../../modules/auth/controllers/auth_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StorageService(), permanent: true);
    Get.put(ApiClient(Get.find<StorageService>()), permanent: true);
    Get.put(AuthApiProvider(Get.find<ApiClient>()), permanent: true);
    Get.put(ProductApiProvider(Get.find<ApiClient>()), permanent: true);
    Get.put(EmployeeApiProvider(Get.find<ApiClient>()), permanent: true);
    Get.put(AuthRepository(Get.find<AuthApiProvider>()), permanent: true);
    Get.put(ProductRepository(Get.find<ProductApiProvider>()), permanent: true);
    Get.put(
      EmployeeRepository(Get.find<EmployeeApiProvider>()),
      permanent: true,
    );
    Get.put(
      AuthController(Get.find<AuthRepository>(), Get.find<StorageService>()),
      permanent: true,
    );
  }
}

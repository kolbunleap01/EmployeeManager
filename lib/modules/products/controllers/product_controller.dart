import 'package:get/get.dart';

import '../../../core/services/api_client.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';

class ProductController extends GetxController {
  ProductController({ProductRepository? repository})
    : _repository = repository ?? Get.find<ProductRepository>();

  final ProductRepository _repository;
  final products = <ProductModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  void onReady() {
    super.onReady();
    loadProducts();
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      products.assignAll(await _repository.getProducts());
    } on Object catch (error) {
      errorMessage.value = ApiClient.mapError(error).message;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProducts() => loadProducts();

  void showError() {
    if (errorMessage.value != null) SnackbarHelper.error(errorMessage.value!);
  }
}

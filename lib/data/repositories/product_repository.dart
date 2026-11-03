import '../models/product_model.dart';
import '../providers/product_api_provider.dart';

class ProductRepository {
  ProductRepository(this._provider);

  final ProductApiProvider _provider;

  Future<List<ProductModel>> getProducts() => _provider.getProducts();
}

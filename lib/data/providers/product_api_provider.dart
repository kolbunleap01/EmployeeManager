import '../../core/constants/api_constants.dart';
import '../../core/services/api_client.dart';
import '../models/product_model.dart';

class ProductApiProvider {
  ProductApiProvider(this._client);

  final ApiClient _client;

  Future<List<ProductModel>> getProducts() async {
    final response = await _client.get(ApiConstants.products);
    final data = response.data;
    if (data is! Map<String, dynamic> || data['products'] is! List) {
      throw const FormatException('Invalid products response');
    }
    return (data['products'] as List)
        .whereType<Map<String, dynamic>>()
        .map(ProductModel.fromJson)
        .toList();
  }
}

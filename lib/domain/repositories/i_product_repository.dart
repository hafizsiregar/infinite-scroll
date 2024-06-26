import '../entities/product.dart';

abstract class IProductRepository {
  Future<List<Product>> fetchProducts(
      {required int page, required int pageSize, String? category});
  Future<List<Product>> searchProducts({required String query});
  Future<List<Product>> filterProductsByCategory({required String category});
}

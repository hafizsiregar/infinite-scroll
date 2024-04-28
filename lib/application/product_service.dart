import '../../domain/entities/product.dart';
import '../../domain/repositories/i_product_repository.dart';

class ProductService {
  final IProductRepository productRepository;

  ProductService(this.productRepository);

  Future<List<Product>> fetchProducts(int page, int pageSize,
      {String? category}) {
    return productRepository.fetchProducts(
        page: page, pageSize: pageSize, category: category);
  }

  Future<List<Product>> searchProducts(String query) {
    return productRepository.searchProducts(query: query);
  }

  Future<List<Product>> filterProductsByCategory(String category) {
    return productRepository.filterProductsByCategory(category: category);
  }
}

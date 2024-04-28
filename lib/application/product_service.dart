import '../../domain/entities/product.dart';
import '../../domain/repositories/i_product_repository.dart';

class ProductService {
  final IProductRepository productRepository;

  ProductService(this.productRepository);

  Future<List<Product>> fetchProducts(int page, int pageSize) {
    return productRepository.fetchProducts(page: page, pageSize: pageSize);
  }
}

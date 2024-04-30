import 'package:flutter/material.dart';
import 'package:infinite_scrool/application/product_service.dart';
import '../../domain/entities/product.dart';

class ProductProvider with ChangeNotifier {
  final ProductService productService;
  final List<Product> _products = [];
  bool _hasMore = true;
  String? _currentCategory;
  static const int pageSize = 10;
  int pageNumber = 1;

  ProductProvider(this.productService) {
    fetchProducts();
  }

  List<Product> get products => _products;
  bool get hasMore => _hasMore;

  Future<List<Product>> fetchProducts({int pageIndex = 0}) async {
    // Assuming pageSize is a static constant or similarly defined.
    int pageNumber =
        pageIndex + 1; // Assuming your API expects 1-based indexing for pages.
    if (!_hasMore) return <Product>[];

    try {
      final newProducts = await productService.fetchProducts(
          pageNumber, ProductProvider.pageSize,
          category: _currentCategory);
      print('Loaded ${newProducts.length} products on page $pageNumber.');

      if (pageNumber == 1) {
        _products.clear();
      }
      _products.addAll(newProducts);
      if (newProducts.length < ProductProvider.pageSize) {
        _hasMore = false;
      }
      notifyListeners();
      return newProducts;
    } catch (e) {
      print('Error fetching products: $e');
      _hasMore = false;
      notifyListeners();
      return <Product>[];
    }
  }

  Future filterProductsByCategory(String category) async {
    _currentCategory = category == 'All' ? null : category;
    pageNumber = 1;
    _hasMore = true;
    _products.clear();
    notifyListeners();
    fetchProducts();
  }
}

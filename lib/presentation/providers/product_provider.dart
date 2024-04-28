import 'package:flutter/material.dart';
import 'package:infinite_scrool/application/product_service.dart';
import '../../domain/entities/product.dart';

class ProductProvider with ChangeNotifier {
  final ProductService productService;
  final List<Product> _products = [];
  bool _hasMore = true;
  // int _pageNumber = 1;
  // final int _pageSize = 10;
  String? _currentCategory;
  static const int pageSize = 10;
  int pageNumber = 0;

  ProductProvider(this.productService) {
    fetchProducts();
  }

  List<Product> get products => _products;
  bool get hasMore => _hasMore;
  Future<List<Product>> fetchProducts() async {
    if (!_hasMore) return [];
    try {
      final newProducts = await productService
          .fetchProducts(pageNumber, pageSize, category: _currentCategory);
      _products.addAll(newProducts);
      if (newProducts.length < pageSize) {
        _hasMore = false;
      }
      pageNumber++;
      notifyListeners();
      return newProducts;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> filterProductsByCategory(String category) async {
    _currentCategory = category;
    pageNumber = 1;
    _products.clear();
    await fetchProducts();
    notifyListeners();
  }
}

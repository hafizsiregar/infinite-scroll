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

  Future<List<Product>> fetchProducts() async {
    if (!_hasMore) return <Product>[];
    try {
      final newProducts = await productService
          .fetchProducts(pageNumber, pageSize, category: _currentCategory);
      if (pageNumber == 1) {
        _products.clear();
      }
      _products.addAll(newProducts);
      if (newProducts.length < pageSize) {
        _hasMore = false;
      } else {
        pageNumber++;
      }
      notifyListeners();
      return newProducts;
    } catch (e) {
      _hasMore = false;
      notifyListeners();
      return <Product>[];
    }
  }

  Future<void> filterProductsByCategory(String category) async {
    _currentCategory = category;
    pageNumber = 1;
    _hasMore = true;
    _products.clear();
    await fetchProducts();
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:infinite_scrool/application/product_service.dart';
import '../../domain/entities/product.dart';

class ProductProvider with ChangeNotifier {
  final ProductService productService;
  final List<Product> _products = [];
  bool _hasMore = true;
  int _pageNumber = 1;
  final int _pageSize = 10;

  ProductProvider(this.productService) {
    fetchProducts();
  }

  List<Product> get products => _products;
  bool get hasMore => _hasMore;

  Future<void> fetchProducts() async {
    try {
      final newProducts =
          await productService.fetchProducts(_pageNumber, _pageSize);
      _products.addAll(newProducts);
      if (newProducts.length < _pageSize) {
        _hasMore = false;
      }
      _pageNumber++;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}

// product_api_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/product.dart';
import '../../domain/repositories/i_product_repository.dart';

class ProductApiRepository implements IProductRepository {
  final String _baseUrl = 'https://dummyjson.com/products';

  @override
  Future<List<Product>> fetchProducts(
      {required int page, required int pageSize, String? category}) async {
    String url = '$_baseUrl?page=$page&limit=$pageSize';
    if (category != null) {
      url += '&category=$category';
    }
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> productsJson = data['products'];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Future<List<Product>> searchProducts({required String query}) async {
    final response = await http.get(Uri.parse('$_baseUrl/search?q=$query'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> productsJson = data['products'];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw http.ClientException('Failed to load searched products');
    }
  }

  @override
  Future<List<Product>> filterProductsByCategory(
      {required String category}) async {
    final url = '$_baseUrl?category=$category';
    print('Fetching products from: $url');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> productsJson = data['products'];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw http.ClientException(
          'Failed to load products for category $category');
    }
  }
}

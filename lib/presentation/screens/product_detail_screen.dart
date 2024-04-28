import 'package:flutter/material.dart';
import 'package:infinite_scrool/domain/entities/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Column(
        children: [
          Image.network(product.thumbnail),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(product.description),
          ),
          Text('\$${product.price}', style: const TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}

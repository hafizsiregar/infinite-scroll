import 'package:flutter/material.dart';
import 'package:infinite_scrool/application/product_service.dart';
import 'package:infinite_scrool/presentation/screens/product_detail_screen.dart';
import 'package:infinite_scrool/presentation/screens/product_search_delegate.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String? _currentCategory = 'All';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: <Widget>[
          DropdownButton<String>(
            value: _currentCategory,
            items: <String>[
              'All',
              'Smartphones',
              'Laptops',
              'Fragrances',
              'Skincare',
              'Groceries'
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _currentCategory = newValue;
                });
                Provider.of<ProductProvider>(context, listen: false)
                    .filterProductsByCategory(newValue);
              }
            },
            hint: const Text("Select Category"),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              final productService =
                  Provider.of<ProductService>(context, listen: false);
              showSearch(
                  context: context,
                  delegate: ProductSearchDelegate(productService));
            },
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                  provider.hasMore) {
                provider.fetchProducts();
              }
              return true;
            },
            child: ListView.builder(
              itemCount: provider.products.length,
              itemBuilder: (context, index) {
                final product = provider.products[index];
                return ListTile(
                  leading: Image.network(product.thumbnail),
                  title: Text(product.title),
                  subtitle: Text('\$${product.price.toString()}'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailScreen(product: product),
                    ));
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

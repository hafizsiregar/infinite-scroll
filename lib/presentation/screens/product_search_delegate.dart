import 'package:flutter/material.dart';
import 'package:infinite_scrool/application/product_service.dart';
import 'package:infinite_scrool/domain/entities/product.dart';

class ProductSearchDelegate extends SearchDelegate<Product?> {
  final ProductService productService;

  ProductSearchDelegate(this.productService);

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text("Type something to start searching"));
    } else {
      return FutureBuilder(
        future: productService.searchProducts(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final products = snapshot.data as List<Product>;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) => ListTile(
                leading: Image.network(products[index].thumbnail),
                title: Text(products[index].title),
                subtitle: Text('\$${products[index].price.toString()}'),
                onTap: () {
                  close(context, products[index]);
                },
              ),
            );
          } else {
            return const Center(child: Text("No products found"));
          }
        },
      );
    }
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }
}

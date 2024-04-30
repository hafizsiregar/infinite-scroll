import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:infinite_scrool/application/product_service.dart';
import 'package:infinite_scrool/domain/entities/product.dart';
import 'package:infinite_scrool/presentation/screens/product_detail_screen.dart';
import 'package:infinite_scrool/presentation/screens/product_search_delegate.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String? _currentCategory = 'All';
  late PagewiseLoadController<Product> _pageLoadController;

  @override
  void initState() {
    super.initState();
    _pageLoadController = PagewiseLoadController<Product>(
      pageSize: ProductProvider.pageSize,
      pageFuture: (pageIndex) =>
          Provider.of<ProductProvider>(context, listen: false).fetchProducts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product List"),
        actions: <Widget>[
          buildDropdown(),
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
      body: PagewiseListView<Product>(
        pageLoadController: _pageLoadController,
        itemBuilder: (context, product, index) =>
            buildProductItem(product, context),
      ),
    );
  }

  Widget buildDropdown() {
    return DropdownButton<String>(
      value: _currentCategory,
      items: <String>[
        'All',
        'Smartphones',
        'Laptops',
        'Fragrances',
        'Skincare',
        'Groceries',
        'Home-decoration',
        'Furniture',
        'Tops'
      ].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null && newValue != _currentCategory) {
          Provider.of<ProductProvider>(context, listen: false)
              .filterProductsByCategory(newValue)
              .then((_) {
            if (mounted) {
              setState(() {
                _currentCategory = newValue;
              });
              _pageLoadController.reset();
            }
          }).catchError((error) {
            print("Error during filtering: $error");
          });
        }
      },
    );
  }

  Widget buildProductItem(Product product, BuildContext context) {
    return ListTile(
      leading: Image.network(product.thumbnail),
      title: Text(product.title),
      subtitle: Text('\$${product.price.toString()}'),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProductDetailScreen(product: product),
        ));
      },
    );
  }

  @override
  void dispose() {
    _pageLoadController.dispose();
    super.dispose();
  }
}

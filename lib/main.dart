import 'package:flutter/material.dart';
import 'package:infinite_scrool/application/product_service.dart';
import 'package:infinite_scrool/domain/repositories/i_product_repository.dart';
import 'package:infinite_scrool/infrastructure/api/product_api_repository.dart';
import 'package:infinite_scrool/presentation/providers/product_provider.dart';
import 'package:infinite_scrool/presentation/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<IProductRepository>(
          create: (_) => ProductApiRepository(),
        ),
        ProxyProvider<IProductRepository, ProductService>(
          update: (_, repository, __) => ProductService(repository),
        ),
        ChangeNotifierProxyProvider<ProductService, ProductProvider>(
          create: (_) =>
              ProductProvider(ProductService(ProductApiRepository())),
          update: (context, productService, previous) =>
              previous ?? ProductProvider(productService),
        ),
      ],
      child: MaterialApp(
        title: 'Infinite Scroll App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:untitled1/providers/products_provider.dart';
import 'package:untitled1/screens/product_overview_screen.dart';
import './screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductsProvider(),
      child: MaterialApp(
        title: 'Shop App',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato'),
        home: ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName : (context) => ProductDetailScreen()
        },
      ),
    );
  }
}

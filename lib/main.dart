import 'package:flutter/material.dart';
import 'package:untitled1/screens/product_overview_screen.dart';
import './screens/product_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop App',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato'),
      home: ProductOverviewScreen(),
      routes: {
        ProductDetailScreen.routeName : (context) => ProductDetailScreen()
      },
    );
  }
}

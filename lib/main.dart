import 'package:flutter/material.dart';
import 'package:untitled1/screens/product_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop App',
      home: ProductOverviewScreen(),
    );
  }
}

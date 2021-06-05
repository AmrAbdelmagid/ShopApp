import 'package:flutter/material.dart';
import 'package:untitled1/providers/auth_provider.dart';
import 'package:untitled1/providers/cart.dart';
import 'package:untitled1/providers/orders_provider.dart';
import 'package:untitled1/providers/products_provider.dart';
import 'package:untitled1/screens/auth_screen.dart';
import 'package:untitled1/screens/cart_screen.dart';
import 'package:untitled1/screens/edit_product_screen.dart';
import 'package:untitled1/screens/orders_screen.dart';
import 'package:untitled1/screens/product_overview_screen.dart';
import 'package:untitled1/screens/user_product_screen.dart';
import './screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          update: (ctx, authData, previousProducts) => ProductsProvider(
              authData.token,
              authData.userId,
              previousProducts == null ? [] : previousProducts.items),
          create: (_) => ProductsProvider(null,null, []),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          create: (_) => OrdersProvider(null,null, []),
          update: (ctx, authData, previousOrders) => OrdersProvider(
            authData.token,
            authData.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shop App',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato'),
          home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductScreen.routeName: (context) => UserProductScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
            AuthScreen.routeName: (context) => AuthScreen(),
          },
        ),
      ),
    );
  }
}

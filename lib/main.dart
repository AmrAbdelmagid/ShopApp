import 'package:flutter/material.dart';
import 'package:untitled1/helpers.dart';
import 'package:untitled1/providers/auth_provider.dart';
import 'package:untitled1/providers/cart.dart';
import 'package:untitled1/providers/orders_provider.dart';
import 'package:untitled1/providers/products_provider.dart';
import 'package:untitled1/screens/auth_screen.dart';
import 'package:untitled1/screens/cart_screen.dart';
import 'package:untitled1/screens/edit_product_screen.dart';
import 'package:untitled1/screens/orders_screen.dart';
import 'package:untitled1/screens/product_overview_screen.dart';
import 'package:untitled1/screens/splash_screen.dart';
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
          update: (ctx, authData, previousProducts) => previousProducts..updates(
              authData.token,
              authData.userId,
             ),
          create: (_) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          create: (_) => OrdersProvider(null, null, []),
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
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              },
            ),
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato'),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
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

// first version of this app was finished.
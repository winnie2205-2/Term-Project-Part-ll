import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/login.dart';
import '../screen/productpage.dart';
import '../screen/homepage.dart';
import 'package:flutter_application_8/models/cart.dart' as cart_model;

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => cart_model.ShoppingCartModel()), 
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZLEEPY',
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomePage(),
        '/login': (context) => LoginPage(),
        '/product': (context) => ProductPage(),
      },
    );
  }
}

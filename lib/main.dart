import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:untitled1/providers/Shop%20provider.dart';
import 'package:untitled1/providers/cartProvider.dart';
import 'cartScreen.dart';
import 'homeScreen.dart';

void main() {
  runApp(

      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => ShopProvider(),),
          ],
          child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        CartScreen.routeName: (context) => CartScreen(),

      },
    );
  }
}

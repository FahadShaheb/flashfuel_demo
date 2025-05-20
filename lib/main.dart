import 'package:flash_fuel/screens/cart/cart_screen.dart';
import 'package:flash_fuel/screens/home/home_screen.dart';
import 'package:flash_fuel/widgets/product_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flash_fuel/screens/auth/login_screen.dart';
import 'package:flash_fuel/screens/auth/signup_screen.dart';
import 'package:flash_fuel/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FlashFuelApp());
}

class FlashFuelApp extends StatelessWidget {
  const FlashFuelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flash Fuel',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/login',
      routes: {
        '/': (context) => const HomeScreen(), // set as the starting screen
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/cart': (context) => const CartScreen(),
        '/product_list': (context) => const ProductList(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/splash_page.dart';
import 'pages/sign_in_page.dart';
import 'pages/sign_up_page.dart';
import 'pages/home/main_page.dart';
import 'pages/product_page.dart';
import 'pages/cart_page.dart';
import 'pages/checkout_page.dart';
import 'pages/checkout_success_page.dart';
import 'pages/detail_chat_page.dart';
import 'pages/edit_profile_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qsgngjurpkxbymhzywzv.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFzZ25nanVycGt4YnltaHp5d3p2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUzODI0NzMsImV4cCI6MjA4MDk1ODQ3M30.fQ4fSsVaXLF4H-hIYNwfaHt4yfTzET1SJPWl5sUu64E',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashPage(),
        '/sign-in': (context) => const SignInPage(),
        '/sign-up': (context) => const SignUpPage(),
        '/home': (context) => const MainPage(),
        '/product': (context) => const ProductPage(),
        '/cart': (context) => const CartPage(),
        '/checkout': (context) => const CheckoutPage(),
        '/checkout-success': (context) => const CheckoutSuccessPage(),
        '/detail-chat': (context) => const DetailChatPage(),
        '/edit-profile': (context) => const EditProfilePage(),
      },
    );
  }
}
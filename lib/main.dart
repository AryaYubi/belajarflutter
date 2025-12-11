import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


import 'pages/splash_page.dart';
import 'pages/sign_in_page.dart';
import 'pages/sign_up_page.dart';
import 'pages/home/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ================================
  // INITIALIZE SUPABASE (PAKAI DATA KAMU)
  // ================================
  await Supabase.initialize(
    // URL PROYEK SUPABASE ANDA
    url: 'https://qsgngjurpkxbymhzywzv.supabase.co',
    // ANON KEY/PUBLIC KEY ANDA
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFzZ25nanVycGt4YnltaHp5d3p2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUzODI0NzMsImV4cCI6MjA4MDk1ODQ3M30.fQ4fSsVaXLF4H-hIYNwfaHt4yfTzET1SJPWl5sUu64E',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Memeriksa sesi user saat ini
    final session = Supabase.instance.client.auth.currentSession;

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Logika Routing Awal:
      // Jika user sudah login → '/home'
      // Jika tidak → '/sign-in'
      initialRoute: session != null ? '/home' : '/sign-in',

      routes: {
        '/splash': (context) => const SplashPage(),
        '/sign-in': (context) => const SignInPage(),
        '/sign-up': (context) => const SignUpPage(),
        '/home': (context) => const MainPage(),
      },
    );
  }
}
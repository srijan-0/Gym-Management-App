import 'package:flutter/material.dart';
import 'package:login/core/app_theme/app_theme.dart';
import 'package:login/view/home_page.dart';
import 'package:login/view/login_view.dart';
import 'package:login/view/onboarding_screen.dart';
import 'package:login/view/register_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/register': (context) => const RegisterView(),
        '/login': (context) => const LoginView(),
        '/dashboard': (context) => const HomePage(),
      },
    );
  }
}

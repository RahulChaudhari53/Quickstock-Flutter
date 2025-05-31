import 'package:flutter/material.dart';
import 'package:quickstock/view/signup_page.dart';
import 'package:quickstock/view/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}

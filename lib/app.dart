import 'package:flutter/material.dart';
import 'package:quickstock/view/login_view.dart';
import 'package:quickstock/view/splash_screen_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginPage());
  }
}

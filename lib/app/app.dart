import 'package:flutter/material.dart';
import 'package:quickstock/app/theme/theme_data.dart';
import 'package:quickstock/features/splash/presentation/view/splash_screen_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenView(),
      theme: getApplicationTheme(),
    );
  }
}

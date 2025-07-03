import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/app/service_locator/service_locator.dart';
import 'package:quickstock/app/theme/theme_data.dart';
import 'package:quickstock/features/splash/presentation/view/splash_view.dart';
import 'package:quickstock/features/splash/presentation/view_model/splash_view_model.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider.value(
        value: serviceLocator<SplashViewModel>(),
        child: SplashView(),
      ),
      theme: getApplicationTheme(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/app/service_locator/service_locator.dart';
import 'package:quickstock/app/theme/theme_data.dart';
import 'package:quickstock/core/services/proximity_services.dart';
import 'package:quickstock/features/splash/presentation/view/splash_view.dart';
import 'package:quickstock/features/splash/presentation/view_model/splash_view_model.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final proximityService = serviceLocator<ProximityService>();

        return Stack(
          children: [
            if (child != null) child, // entire app

            ValueListenableBuilder<bool>(
              // listening to service notifier to hide/show overlay
              valueListenable: proximityService.isNearNotifier,
              builder: (context, isNear, _) {
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: isNear ? 1.0 : 0.0,
                  child: IgnorePointer(
                    child: Container(color: Colors.black.withOpacity(0.7)),
                  ),
                );
              },
            ),
          ],
        );
      },
      home: BlocProvider.value(
        value: serviceLocator<SplashViewModel>(),
        child: SplashView(),
      ),
      theme: getApplicationTheme(),
    );
  }
}

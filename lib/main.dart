import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickstock/app/app.dart';
import 'package:quickstock/app/service_locator/service_locator.dart';
import 'package:quickstock/core/network/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  await serviceLocator<HiveService>().init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

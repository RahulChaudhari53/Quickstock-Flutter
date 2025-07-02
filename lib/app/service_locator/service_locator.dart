import 'package:get_it/get_it.dart';
import 'package:quickstock/core/network/hive_service.dart';
import 'package:quickstock/features/dashboard/presentation/view_model/dashboard_view_model.dart';
import 'package:quickstock/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:quickstock/features/user/data/data_source/local_data_source/user_local_data_source.dart';
import 'package:quickstock/features/user/data/repository/local_repository/user_local_repository.dart';
import 'package:quickstock/features/user/domain/usecase/user_login_usecase.dart';
import 'package:quickstock/features/user/domain/usecase/user_register_usecase.dart';
import 'package:quickstock/features/user/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:quickstock/features/user/presentation/view_model/register_view_model/register_view_model.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();

  await _initSplashModule();
  await _initUserModule();
  await _initDashboardModule();
}

Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton(() => HiveService());
}

// User Module
Future<void> _initUserModule() async {
  // ============== Data Source ==============
  serviceLocator.registerFactory(
    () => UserLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );

  // ============== Repository ==============
  serviceLocator.registerFactory(
    () => UserLocalRepository(
      userLocalDataSource: serviceLocator<UserLocalDataSource>(),
    ),
  );

  // ============== Usecase ==============
  serviceLocator.registerFactory(
    () => UserRegisterUsecase(
      iUserRepository: serviceLocator<UserLocalRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserLoginUsecase(
      iUserRepository: serviceLocator<UserLocalRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => RegisterViewModel(serviceLocator<UserRegisterUsecase>()),
  );

  serviceLocator.registerFactory(
    () => LoginViewModel(serviceLocator<UserLoginUsecase>()),
  );
}

// Dashboard Module
Future<void> _initDashboardModule() async {
  serviceLocator.registerFactory(() => DashboardViewModel());
}

// Splash Module
Future<void> _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
}

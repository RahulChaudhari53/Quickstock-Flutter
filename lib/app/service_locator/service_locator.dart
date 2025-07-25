import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:quickstock/app/shared_pref/token_shared_pref.dart';
import 'package:quickstock/core/network/api_service.dart';
import 'package:quickstock/core/network/hive_service.dart';
import 'package:quickstock/features/dashboard/presentation/view_model/dashboard_view_model.dart';
import 'package:quickstock/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:quickstock/features/user/data/data_source/local_data_source/user_local_data_source.dart';
import 'package:quickstock/features/user/data/data_source/remote_data_source/user_remote_data_source.dart';
import 'package:quickstock/features/user/data/repository/local_repository/user_local_repository.dart';
import 'package:quickstock/features/user/data/repository/remote_repository/user_remote_repository.dart';
import 'package:quickstock/features/user/domain/usecase/user_login_usecase.dart';
import 'package:quickstock/features/user/domain/usecase/user_register_usecase.dart';
import 'package:quickstock/features/user/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:quickstock/features/user/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  await _initApiService();
  await _initSharedPref();

  await _initSplashModule();
  await _initUserModule();
  await _initDashboardModule();
}

Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton(() => HiveService());
}

Future<void> _initApiService() async {
  serviceLocator.registerLazySingleton(() => ApiService(Dio()));
}

Future<void> _initSharedPref() async {
  final sharedPref = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPref);
  serviceLocator.registerLazySingleton(
    () =>
        TokenSharedPref(sharedPreferences: serviceLocator<SharedPreferences>()),
  );
}

// User Module
Future<void> _initUserModule() async {
  // ============== Data Source ==============
  serviceLocator.registerFactory(
    () => UserLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory(
    () => UserRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  // ============== Repository ==============
  serviceLocator.registerFactory(
    () => UserLocalRepository(
      userLocalDataSource: serviceLocator<UserLocalDataSource>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserRemoteRepository(
      userRemoteDatasource: serviceLocator<UserRemoteDatasource>(),
    ),
  );

  // ============== Usecase ==============
  // serviceLocator.registerFactory(
  //   () => UserRegisterUsecase(
  //     iUserRepository: serviceLocator<UserLocalRepository>(),
  //   ),
  // );

  // serviceLocator.registerFactory(
  //   () => UserLoginUsecase(
  //     iUserRepository: serviceLocator<UserLocalRepository>(),
  //   ),
  // );

  serviceLocator.registerFactory(
    () => UserRegisterUsecase(
      iUserRepository: serviceLocator<UserRemoteRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserLoginUsecase(
      iUserRepository: serviceLocator<UserRemoteRepository>(),
      tokenSharedPref: serviceLocator<TokenSharedPref>(),
    ),
  );

  // ============== View Models ==============
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

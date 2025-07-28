import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:quickstock/app/shared_pref/token_shared_pref.dart';
import 'package:quickstock/core/network/api_service.dart';
import 'package:quickstock/core/network/hive_service.dart';
import 'package:quickstock/features/forgot_password/data/data_source/forgot_password_data_source.dart';
import 'package:quickstock/features/forgot_password/data/data_source/remote_data_source/forgot_password_remote_data_source.dart';
import 'package:quickstock/features/forgot_password/data/repository/remote_repository/forgot_password_remote_repository.dart';
import 'package:quickstock/features/forgot_password/domain/repository/forgot_password_repository.dart';
import 'package:quickstock/features/forgot_password/domain/usecase/reset_password_usecase.dart';
import 'package:quickstock/features/forgot_password/domain/usecase/send_otp_usecase.dart';
import 'package:quickstock/features/forgot_password/domain/usecase/verify_otp_usecase.dart';
import 'package:quickstock/features/forgot_password/presentation/viewmodel/reset_password_viewmodel/reset_password_viewmodel.dart';
import 'package:quickstock/features/forgot_password/presentation/viewmodel/send_otp_viewmodel/send_otp_view_model.dart';
import 'package:quickstock/features/forgot_password/presentation/viewmodel/verify_otp_viewmodel/verify_otp_view_model.dart';
import 'package:quickstock/features/dashboard/presentation/view_model/home_view_model.dart';
import 'package:quickstock/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:quickstock/features/auth/data/data_source/local_data_source/user_local_data_source.dart';
import 'package:quickstock/features/auth/data/data_source/remote_data_source/user_remote_data_source.dart';
import 'package:quickstock/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:quickstock/features/auth/data/repository/remote_repository/user_remote_repository.dart';
import 'package:quickstock/features/auth/domain/usecase/user_login_usecase.dart';
import 'package:quickstock/features/auth/domain/usecase/user_register_usecase.dart';
import 'package:quickstock/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:quickstock/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  await _initApiService();
  await _initSharedPref();

  await _initSplashModule();
  await _initForgotPasswordModule();
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

Future<void> _initForgotPasswordModule() async {
  // ============== Data Source ==============
  serviceLocator.registerFactory<ForgotPasswordRemoteDataSource>(
    () => ForgotPasswordRemoteDataSource(
      apiService: serviceLocator<ApiService>(),
    ),
  );

  // ============== Repository ==============
  serviceLocator.registerFactory<IForgotPasswordRepository>(
    () => ForgotPasswordRemoteRepository(
      forgotPasswordRemoteDataSource:
          serviceLocator<ForgotPasswordRemoteDataSource>(),
    ),
  );

  // ============== UseCases ==============
  serviceLocator.registerFactory(
    () => SendOtpUseCase(serviceLocator<IForgotPasswordRepository>()),
  );
  serviceLocator.registerFactory(
    () => VerifyOtpUseCase(serviceLocator<IForgotPasswordRepository>()),
  );
  serviceLocator.registerFactory(
    () => ResetPasswordUseCase(serviceLocator<IForgotPasswordRepository>()),
  );

  // ============== ViewModels (BLoCs) ==============
  serviceLocator.registerFactory(
    () => SendOtpViewModel(serviceLocator<SendOtpUseCase>()),
  );
  serviceLocator.registerFactory(
    () => VerifyOtpViewModel(
      serviceLocator<VerifyOtpUseCase>(),
      serviceLocator<SendOtpUseCase>(),
    ),
  );
  serviceLocator.registerFactory(
    () => ResetPasswordViewModel(serviceLocator<ResetPasswordUseCase>()),
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

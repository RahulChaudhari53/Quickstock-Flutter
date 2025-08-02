import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:quickstock/app/shared_pref/token_shared_pref.dart';
import 'package:quickstock/core/network/api_service.dart';
import 'package:quickstock/core/network/hive_service.dart';
import 'package:quickstock/core/services/proximity_services.dart';
import 'package:quickstock/features/auth/data/data_source/local_data_source/user_local_data_source.dart';
import 'package:quickstock/features/auth/data/data_source/remote_data_source/user_remote_data_source.dart';
import 'package:quickstock/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:quickstock/features/auth/data/repository/remote_repository/user_remote_repository.dart';
import 'package:quickstock/features/auth/domain/usecase/check_auth_status_usecase.dart';
import 'package:quickstock/features/auth/domain/usecase/user_login_usecase.dart';
import 'package:quickstock/features/auth/domain/usecase/user_register_usecase.dart';
import 'package:quickstock/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:quickstock/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:quickstock/features/categories/data/data_source/category_data_source.dart';
import 'package:quickstock/features/categories/data/data_source/remote_datasource/category_remote_data_source.dart';
import 'package:quickstock/features/categories/data/repository/remote_repository/category_remote_repository.dart';
import 'package:quickstock/features/categories/domain/repository/category_repository.dart';
import 'package:quickstock/features/categories/domain/use_case/activate_category_usecase.dart';
import 'package:quickstock/features/categories/domain/use_case/create_category_usecase.dart';
import 'package:quickstock/features/categories/domain/use_case/deactivate_category_usecase.dart';
import 'package:quickstock/features/categories/domain/use_case/get_all_categories_usecase.dart';
import 'package:quickstock/features/categories/presentation/view_model/category_view_model.dart';
import 'package:quickstock/features/dashboard/data/data_source/dashboard_data_source.dart';
import 'package:quickstock/features/dashboard/data/data_source/remote_data_source/dashboard_remote_data_source.dart';
import 'package:quickstock/features/dashboard/data/repository/remote_repository/dashboard_remote_repository_impl.dart';
import 'package:quickstock/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:quickstock/features/dashboard/domain/usecase/get_dashboard_overview_usecase.dart';
import 'package:quickstock/features/dashboard/domain/usecase/user_logout_usecase.dart';
import 'package:quickstock/features/dashboard/presentation/view_model/dashboard_layout_viewmodel/dashboard_view_model.dart';
import 'package:quickstock/features/dashboard/presentation/view_model/home_viewmodel/home_view_model.dart';
import 'package:quickstock/features/forgot_password/data/data_source/remote_data_source/forgot_password_remote_data_source.dart';
import 'package:quickstock/features/forgot_password/data/repository/remote_repository/forgot_password_remote_repository.dart';
import 'package:quickstock/features/forgot_password/domain/repository/forgot_password_repository.dart';
import 'package:quickstock/features/forgot_password/domain/usecase/reset_password_usecase.dart';
import 'package:quickstock/features/forgot_password/domain/usecase/send_otp_usecase.dart';
import 'package:quickstock/features/forgot_password/domain/usecase/verify_otp_usecase.dart';
import 'package:quickstock/features/forgot_password/presentation/viewmodel/reset_password_viewmodel/reset_password_viewmodel.dart';
import 'package:quickstock/features/forgot_password/presentation/viewmodel/send_otp_viewmodel/send_otp_view_model.dart';
import 'package:quickstock/features/forgot_password/presentation/viewmodel/verify_otp_viewmodel/verify_otp_view_model.dart';
import 'package:quickstock/features/product/data/data_source/product_data_source.dart';
import 'package:quickstock/features/product/data/data_source/remote_datasource/product_remote_data_source.dart';
import 'package:quickstock/features/product/data/repository/remote_repository/product_repository_impl.dart';
import 'package:quickstock/features/product/domain/repository/product_repository.dart';
import 'package:quickstock/features/product/domain/use_case/activate_product_usecase.dart';
import 'package:quickstock/features/product/domain/use_case/create_product_usecase.dart';
import 'package:quickstock/features/product/domain/use_case/deactivate_product_usecase.dart';
import 'package:quickstock/features/product/domain/use_case/get_all_product_usecase.dart';
import 'package:quickstock/features/product/domain/use_case/get_product_by_id_usecase.dart';
import 'package:quickstock/features/product/domain/use_case/update_product_usecase.dart';
import 'package:quickstock/features/product/presentation/view_model/product_form_view_model/product_form_view_model.dart';
import 'package:quickstock/features/product/presentation/view_model/product_view_viewmodel/product_view_model.dart';
import 'package:quickstock/features/product/presentation/view_model/product_detail_view_model/product_detail_view_model.dart';
import 'package:quickstock/features/profile/data/data_source/profile_data_source.dart';
import 'package:quickstock/features/profile/data/data_source/remote_data_source/profile_remote_data_source.dart';
import 'package:quickstock/features/profile/data/repository/remote_repository/profile_remote_repository.dart';
import 'package:quickstock/features/profile/domain/repository/profile_repository.dart';
import 'package:quickstock/features/profile/domain/usecase/add_phone_number_usecase.dart';
import 'package:quickstock/features/profile/domain/usecase/deactivate_account_usecase.dart';
import 'package:quickstock/features/profile/domain/usecase/delete_phone_number_usecase.dart';
import 'package:quickstock/features/profile/domain/usecase/get_profile_usecase.dart';
import 'package:quickstock/features/profile/domain/usecase/update_email_usecase.dart';
import 'package:quickstock/features/profile/domain/usecase/update_password_usecase.dart';
import 'package:quickstock/features/profile/domain/usecase/update_profile_image_usecase.dart';
import 'package:quickstock/features/profile/domain/usecase/update_profile_info_usecase.dart';
import 'package:quickstock/features/profile/presentation/viewmodel/profile_view_model.dart';
import 'package:quickstock/features/purchase/data/data_source/purchase_data_source.dart';
import 'package:quickstock/features/purchase/data/data_source/remote_datasource/purchase_remote_data_source.dart';
import 'package:quickstock/features/purchase/data/repository/remote_repository/purchase_remote_repository.dart';
import 'package:quickstock/features/purchase/domain/repository/purchase_repository.dart';
import 'package:quickstock/features/purchase/domain/use_case/cancel_purchase_usecase.dart';
import 'package:quickstock/features/purchase/domain/use_case/create_purchase_usecase.dart';
import 'package:quickstock/features/purchase/domain/use_case/get_all_purchase_usecase.dart';
import 'package:quickstock/features/purchase/domain/use_case/get_purchase_by_id_usecase.dart';
import 'package:quickstock/features/purchase/domain/use_case/receive_purchase_usecase.dart';
import 'package:quickstock/features/purchase/domain/use_case/update_purchase_usecase.dart';
import 'package:quickstock/features/purchase/presentation/view_model/purchase_detail/purchase_detail_view_model.dart';
import 'package:quickstock/features/purchase/presentation/view_model/purchase_history/purchase_history_view_model.dart';
import 'package:quickstock/features/sales/data/data_source/remote_datasource/sale_remote_data_source.dart';
import 'package:quickstock/features/sales/data/data_source/sale_data_source.dart';
import 'package:quickstock/features/sales/data/repository/remote_repository/sale_remote_repository.dart';
import 'package:quickstock/features/sales/domain/repository/sale_repository.dart';
import 'package:quickstock/features/sales/domain/use_case/cancel_sale_usecase.dart.dart';
import 'package:quickstock/features/sales/domain/use_case/create_sale_usecase.dart';
import 'package:quickstock/features/sales/domain/use_case/get_all_sales_usecase.dart';
import 'package:quickstock/features/sales/domain/use_case/get_sale_by_id.dart';
import 'package:quickstock/features/sales/presentation/view_model/create_sale/create_sale_view_model.dart';
import 'package:quickstock/features/sales/presentation/view_model/sale_detail/sale_detail_view_model.dart';
import 'package:quickstock/features/sales/presentation/view_model/sale_history/sale_history_view_model.dart';
import 'package:quickstock/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:quickstock/features/stock/data/data_source/remote_datasource/stock_remote_data_source.dart';
import 'package:quickstock/features/stock/data/data_source/stock_data_source.dart';
import 'package:quickstock/features/stock/data/repository/remote_repository/stock_remote_repository.dart';
import 'package:quickstock/features/stock/domain/repository/stock_repository.dart';
import 'package:quickstock/features/stock/domain/use_case/get_all_stock_usecase.dart';
import 'package:quickstock/features/stock/domain/use_case/get_stock_movement_history_usecase.dart';
import 'package:quickstock/features/stock/presentation/view_model/stock_history_view_model/stock_history_view_model.dart';
import 'package:quickstock/features/stock/presentation/view_model/stock_view_model/stock_view_model.dart';
import 'package:quickstock/features/supplier/data/data_source/remote_datasource/supplier_remote_data_source_impl.dart';
import 'package:quickstock/features/supplier/data/data_source/supplier_data_source.dart';
import 'package:quickstock/features/supplier/data/repository/remote_repository/supplier_remote_repository.dart';
import 'package:quickstock/features/supplier/domain/repository/supplier_repository.dart';
import 'package:quickstock/features/supplier/domain/use_case/activate_supplier_usecase.dart';
import 'package:quickstock/features/supplier/domain/use_case/create_supplier_usecase.dart';
import 'package:quickstock/features/supplier/domain/use_case/deactivate_supplier_usecase.dart';
import 'package:quickstock/features/supplier/domain/use_case/get_supplier_by_id_usecase.dart';
import 'package:quickstock/features/supplier/domain/use_case/get_suppliers_usecase.dart';
import 'package:quickstock/features/supplier/domain/use_case/update_supplier_usecase.dart';
import 'package:quickstock/features/supplier/presentation/view_model/supplier_detail_view_model/supplier_detail_view_model.dart';
import 'package:quickstock/features/supplier/presentation/view_model/supplier_view_model/supplier_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initServices();
  await _initHiveService();
  await _initApiService();
  await _initSharedPref();

  await _initSplashModule();
  await _initForgotPasswordModule();
  await _initUserModule();
  await _initDashboardModule();
  await _initCategoryModule();
  await _initSupplierModule();
  await _initProductModule();
  await _initPurchaseModule();
  await _initStockModule();
  await _initSaleModule();
  await _initProfileModule();
}

Future<void> _initServices() async {
  serviceLocator.registerSingleton<ProximityService>(ProximityService());

  serviceLocator<ProximityService>().init();
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

  serviceLocator.registerFactory(
    () => LogoutUseCase(tokenSharedPref: serviceLocator<TokenSharedPref>()),
  );

  serviceLocator.registerFactory(
    () => CheckAuthStatusUseCase(
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

// Forgot Password Module
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

// Dashboard Module (Home & Main Dashboard Logic)
Future<void> _initDashboardModule() async {
  // ============== Data Source ==============
  serviceLocator.registerFactory<IDashboardDataSource>(
    () => DashboardRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // ============== Repository ==============
  serviceLocator.registerFactory<IDashboardRepository>(
    () => DashboardRemoteRepository(
      dataSource: serviceLocator<IDashboardDataSource>(),
    ),
  );

  // ============== Usecase ==============
  serviceLocator.registerFactory(
    () => GetDashboardOverviewUsecase(
      repository: serviceLocator<IDashboardRepository>(),
    ),
  );

  // ============== ViewModel ==============
  // For the Home page content
  serviceLocator.registerFactory(
    () => HomeViewModel(
      getDashboardOverviewUsecase:
          serviceLocator<GetDashboardOverviewUsecase>(),
    ),
  );

  // For the main Dashboard view logic (like logout)
  serviceLocator.registerFactory(
    () => DashboardViewModel(logoutUseCase: serviceLocator<LogoutUseCase>()),
  );
}

// Category Module
Future<void> _initCategoryModule() async {
  // ============== Data Source ==============
  serviceLocator.registerFactory<ICategoryDataSource>(
    () => CategoryRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // ============== Repository ==============
  serviceLocator.registerFactory<ICategoryRepository>(
    () => CategoryRemoteRepository(
      remoteDataSource: serviceLocator<ICategoryDataSource>(),
    ),
  );

  // ============== Usecases ==============
  serviceLocator.registerFactory(
    () => GetAllCategoriesUsecase(
      repository: serviceLocator<ICategoryRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => CreateCategoryUsecase(
      repository: serviceLocator<ICategoryRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => DeactivateCategoryUsecase(
      repository: serviceLocator<ICategoryRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => ActivateCategoryUsecase(
      repository: serviceLocator<ICategoryRepository>(),
    ),
  );

  // ============== ViewModel ==============
  serviceLocator.registerFactory(
    () => CategoryViewModel(
      getAllCategoriesUsecase: serviceLocator<GetAllCategoriesUsecase>(),
      createCategoryUsecase: serviceLocator<CreateCategoryUsecase>(),
      deactivateCategoryUsecase: serviceLocator<DeactivateCategoryUsecase>(),
      activateCategoryUsecase: serviceLocator<ActivateCategoryUsecase>(),
    ),
  );
}

// Supplier Module
Future<void> _initSupplierModule() async {
  // ============== Data Source ==============
  serviceLocator.registerFactory<ISupplierDataSource>(
    () => SupplierRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // ============== Repository ==============
  serviceLocator.registerFactory<ISupplierRepository>(
    () => SupplierRemoteRepository(
      remoteDataSource: serviceLocator<ISupplierDataSource>(),
    ),
  );

  // ============== Usecases ==============
  serviceLocator.registerFactory(
    () => GetSuppliersUsecase(serviceLocator<ISupplierRepository>()),
  );
  serviceLocator.registerFactory(
    () => GetSupplierByIdUsecase(serviceLocator<ISupplierRepository>()),
  );
  serviceLocator.registerFactory(
    () => CreateSupplierUsecase(serviceLocator<ISupplierRepository>()),
  );
  serviceLocator.registerFactory(
    () => UpdateSupplierUsecase(serviceLocator<ISupplierRepository>()),
  );
  serviceLocator.registerFactory(
    () => DeactivateSupplierUsecase(serviceLocator<ISupplierRepository>()),
  );
  serviceLocator.registerFactory(
    () => ActivateSupplierUsecase(serviceLocator<ISupplierRepository>()),
  );

  // ============== ViewModels (BLoCs) ==============
  serviceLocator.registerFactory(
    () => SupplierViewModel(
      getSuppliersUsecase: serviceLocator<GetSuppliersUsecase>(),
      createSupplierUsecase: serviceLocator<CreateSupplierUsecase>(),
      updateSupplierUsecase: serviceLocator<UpdateSupplierUsecase>(),
      deactivateSupplierUsecase: serviceLocator<DeactivateSupplierUsecase>(),
      activateSupplierUsecase: serviceLocator<ActivateSupplierUsecase>(),
    ),
  );

  serviceLocator.registerFactory(
    () => SupplierDetailViewModel(
      getSupplierByIdUsecase: serviceLocator<GetSupplierByIdUsecase>(),
    ),
  );
}

// Stock Module
Future<void> _initStockModule() async {
  // ============== Data Source ==============
  serviceLocator.registerFactory<IStockDataSource>(
    () => StockRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // ============== Repository ==============
  serviceLocator.registerFactory<IStockRepository>(
    () => StockRemoteRepository(
      remoteDataSource: serviceLocator<IStockDataSource>(),
    ),
  );

  // ============== Usecases ==============
  serviceLocator.registerFactory(
    () => GetAllStockUsecase(repository: serviceLocator<IStockRepository>()),
  );
  serviceLocator.registerFactory(
    () => GetStockMovementHistoryUsecase(
      repository: serviceLocator<IStockRepository>(),
    ),
  );

  // ============== View Models (BLoCs) ==============
  serviceLocator.registerFactory(
    () => StockViewModel(
      getAllStockUsecase: serviceLocator<GetAllStockUsecase>(),
    ),
  );
  serviceLocator.registerFactory(
    () => StockHistoryViewModel(
      getStockMovementHistoryUsecase:
          serviceLocator<GetStockMovementHistoryUsecase>(),
    ),
  );
}

// Sale Module
Future<void> _initSaleModule() async {
  // ============== Data Source ==============
  serviceLocator.registerFactory<ISaleDataSource>(
    () => SaleRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // ============== Repository ==============
  serviceLocator.registerFactory<ISaleRepository>(
    () => SaleRemoteRepository(
      remoteDataSource: serviceLocator<ISaleDataSource>(),
    ),
  );

  // ============== Usecases ==============
  serviceLocator.registerFactory(
    () => GetAllSalesUsecase(repository: serviceLocator<ISaleRepository>()),
  );
  serviceLocator.registerFactory(
    () => GetSaleByIdUsecase(repository: serviceLocator<ISaleRepository>()),
  );
  serviceLocator.registerFactory(
    () => CreateSaleUsecase(repository: serviceLocator<ISaleRepository>()),
  );
  serviceLocator.registerFactory(
    () => CancelSaleUsecase(repository: serviceLocator<ISaleRepository>()),
  );

  // ============== View Models (BLoCs) ==============
  serviceLocator.registerFactory(
    () => SalesHistoryViewModel(
      getAllSalesUsecase: serviceLocator<GetAllSalesUsecase>(),
      cancelSaleUsecase: serviceLocator<CancelSaleUsecase>(),
    ),
  );

  serviceLocator.registerFactory(
    () => SaleDetailViewModel(
      getSaleByIdUsecase: serviceLocator<GetSaleByIdUsecase>(),
      // cancelSaleUsecase: serviceLocator<CancelSaleUsecase>(),
    ),
  );

  serviceLocator.registerFactory(
    () => CreateSaleViewModel(
      createSaleUsecase: serviceLocator<CreateSaleUsecase>(),
      getAllProductsUsecase: serviceLocator<GetAllProductsUsecase>(),
    ),
  );
}

// Profile Module
Future<void> _initProfileModule() async {
  // ============== Data Source ==============
  serviceLocator.registerFactory<IProfileDataSource>(
    () => ProfileRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // ============== Repository ==============
  serviceLocator.registerFactory<IProfileRepository>(
    () => ProfileRemoteRepository(
      remoteDataSource: serviceLocator<IProfileDataSource>(),
    ),
  );

  // ============== Usecases ==============
  serviceLocator.registerFactory(
    () => GetProfileUsecase(serviceLocator<IProfileRepository>()),
  );
  serviceLocator.registerFactory(
    () => UpdateProfileInfoUsecase(serviceLocator<IProfileRepository>()),
  );
  serviceLocator.registerFactory(
    () => UpdatePasswordUsecase(serviceLocator<IProfileRepository>()),
  );
  serviceLocator.registerFactory(
    () => UpdateEmailUsecase(serviceLocator<IProfileRepository>()),
  );
  serviceLocator.registerFactory(
    () => UpdateProfileImageUsecase(serviceLocator<IProfileRepository>()),
  );
  serviceLocator.registerFactory(
    () => AddPhoneNumberUsecase(serviceLocator<IProfileRepository>()),
  );
  serviceLocator.registerFactory(
    () => DeletePhoneNumberUsecase(serviceLocator<IProfileRepository>()),
  );
  serviceLocator.registerFactory(
    () => DeactivateAccountUsecase(serviceLocator<IProfileRepository>()),
  );

  // ============== ViewModel (BLoC) ==============
  serviceLocator.registerFactory(
    () => ProfileViewModel(
      getProfileUsecase: serviceLocator<GetProfileUsecase>(),
      updateProfileInfoUsecase: serviceLocator<UpdateProfileInfoUsecase>(),
      updatePasswordUsecase: serviceLocator<UpdatePasswordUsecase>(),
      updateEmailUsecase: serviceLocator<UpdateEmailUsecase>(),
      updateProfileImageUsecase: serviceLocator<UpdateProfileImageUsecase>(),
      addPhoneNumberUsecase: serviceLocator<AddPhoneNumberUsecase>(),
      deletePhoneNumberUsecase: serviceLocator<DeletePhoneNumberUsecase>(),
      deactivateAccountUsecase: serviceLocator<DeactivateAccountUsecase>(),
      logoutUseCase: serviceLocator<LogoutUseCase>(),
    ),
  );
}

// Splash Module
Future<void> _initSplashModule() async {
  serviceLocator.registerFactory(
    () => SplashViewModel(
      checkAuthStatusUseCase: serviceLocator<CheckAuthStatusUseCase>(),
    ),
  );
}

// Purchase Module
Future<void> _initPurchaseModule() async {
  // ============== Data Source ==============
  serviceLocator.registerFactory<IPurchaseDataSource>(
    () => PurchaseRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // ============== Repository ==============
  serviceLocator.registerFactory<IPurchaseRepository>(
    () => PurchaseRemoteRepository(
      remoteDataSource: serviceLocator<IPurchaseDataSource>(),
    ),
  );

  // ============== Usecases ==============
  serviceLocator.registerFactory(
    () => GetAllPurchasesUsecase(serviceLocator<IPurchaseRepository>()),
  );
  serviceLocator.registerFactory(
    () => GetPurchaseByIdUsecase(serviceLocator<IPurchaseRepository>()),
  );
  serviceLocator.registerFactory(
    () => CreatePurchaseUsecase(serviceLocator<IPurchaseRepository>()),
  );
  serviceLocator.registerFactory(
    () => UpdatePurchaseUsecase(serviceLocator<IPurchaseRepository>()),
  );
  serviceLocator.registerFactory(
    () => CancelPurchaseUsecase(serviceLocator<IPurchaseRepository>()),
  );
  serviceLocator.registerFactory(
    () => ReceivePurchaseUsecase(serviceLocator<IPurchaseRepository>()),
  );

  // ============== View Models (BLoCs) ==============
  serviceLocator.registerFactory(
    () => PurchaseHistoryViewModel(serviceLocator<GetAllPurchasesUsecase>()),
  );

  serviceLocator.registerFactory(
    () => PurchaseDetailViewModel(
      getPurchaseByIdUsecase: serviceLocator<GetPurchaseByIdUsecase>(),
      cancelPurchaseUsecase: serviceLocator<CancelPurchaseUsecase>(),
      receivePurchaseUsecase: serviceLocator<ReceivePurchaseUsecase>(),
    ),
  );

  // We will register the other ViewModels here later when we create them.
  /*


  serviceLocator.registerFactory(
    () => CreatePurchaseViewModel(
      createPurchaseUsecase: serviceLocator<CreatePurchaseUsecase>(),
      updatePurchaseUsecase: serviceLocator<UpdatePurchaseUsecase>(),
      // We will also need to inject usecases for getting all products and suppliers
      // getAllProductsUsecase: serviceLocator<GetAllProductsUsecase>(),
      // getAllSuppliersUsecase: serviceLocator<GetAllSuppliersUsecase>(),
    ),
  );
  */
}

// Product Module
Future<void> _initProductModule() async {
  // ============== Data Source ==============
  serviceLocator.registerFactory<IProductDataSource>(
    () => ProductRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // ============== Repository ==============
  serviceLocator.registerFactory<IProductRepository>(
    () => ProductRemoteRepository(
      remoteDataSource: serviceLocator<IProductDataSource>(),
    ),
  );

  // ============== Usecases ==============
  serviceLocator.registerFactory(
    () =>
        GetAllProductsUsecase(repository: serviceLocator<IProductRepository>()),
  );
  serviceLocator.registerFactory(
    () =>
        GetProductByIdUsecase(repository: serviceLocator<IProductRepository>()),
  );
  serviceLocator.registerFactory(
    () =>
        CreateProductUsecase(repository: serviceLocator<IProductRepository>()),
  );
  serviceLocator.registerFactory(
    () =>
        UpdateProductUsecase(repository: serviceLocator<IProductRepository>()),
  );
  serviceLocator.registerFactory(
    () => DeactivateProductUsecase(
      repository: serviceLocator<IProductRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => ActivateProductUsecase(
      repository: serviceLocator<IProductRepository>(),
    ),
  );

  // ============== View Models (BLoCs) ==============
  serviceLocator.registerFactory(
    () => ProductViewModel(
      getAllProductsUsecase: serviceLocator<GetAllProductsUsecase>(),
      activateProductUsecase: serviceLocator<ActivateProductUsecase>(),
      deactivateProductUsecase: serviceLocator<DeactivateProductUsecase>(),
    ),
  );

  serviceLocator.registerFactory(
    () => ProductDetailViewModel(
      getProductByIdUsecase: serviceLocator<GetProductByIdUsecase>(),
      activateProductUsecase: serviceLocator<ActivateProductUsecase>(),
      deactivateProductUsecase: serviceLocator<DeactivateProductUsecase>(),
    ),
  );

  serviceLocator.registerFactory(
    () => ProductFormViewModel(
      createProductUsecase: serviceLocator<CreateProductUsecase>(),
      updateProductUsecase: serviceLocator<UpdateProductUsecase>(),
      getAllCategoriesUsecase: serviceLocator<GetAllCategoriesUsecase>(),
      getSuppliersUsecase: serviceLocator<GetSuppliersUsecase>(),
    ),
  );
}

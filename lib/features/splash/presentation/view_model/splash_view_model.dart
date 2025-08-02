import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/app/service_locator/service_locator.dart';
import 'package:quickstock/features/auth/domain/usecase/check_auth_status_usecase.dart';
import 'package:quickstock/features/auth/presentation/view/login_view.dart';
import 'package:quickstock/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:quickstock/features/dashboard/presentation/view/dashboard_layout/dashboard_view.dart';

class SplashViewModel extends Cubit<void> {
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;

  SplashViewModel({required CheckAuthStatusUseCase checkAuthStatusUseCase})
    : _checkAuthStatusUseCase = checkAuthStatusUseCase,
      super(null);

  Future<void> init(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));

    final result = await _checkAuthStatusUseCase();

    result.fold(
      (failure) {
        _navigateTo(context, const LoginRoute());
      },
      (token) {
        if (token != null && token.isNotEmpty) {
          _navigateTo(context, const DashboardRoute());
        } else {
          _navigateTo(context, const LoginRoute());
        }
      },
    );
  }

  void _navigateTo(BuildContext context, RouteInfo routeInfo) {
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: routeInfo.builder),
      );
    }
  }
}

abstract class RouteInfo {
  const RouteInfo();
  WidgetBuilder get builder;
}

class LoginRoute extends RouteInfo {
  const LoginRoute();
  @override
  WidgetBuilder get builder =>
      (context) => BlocProvider.value(
        value: serviceLocator<LoginViewModel>(),
        child: LoginView(),
      );
}

class DashboardRoute extends RouteInfo {
  const DashboardRoute();
  @override
  WidgetBuilder get builder => (context) => const DashboardView();
}

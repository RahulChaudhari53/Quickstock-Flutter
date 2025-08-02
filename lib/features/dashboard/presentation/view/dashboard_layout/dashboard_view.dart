import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/app/service_locator/service_locator.dart';
import 'package:quickstock/features/auth/presentation/view/login_view.dart';
import 'package:quickstock/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:quickstock/features/dashboard/presentation/page_content.dart';
import 'package:quickstock/features/dashboard/presentation/view/home/home_view.dart';
import 'package:quickstock/features/dashboard/presentation/view_model/dashboard_layout_viewmodel/dashboard_state.dart';
import 'package:quickstock/features/dashboard/presentation/view_model/dashboard_layout_viewmodel/dashboard_view_model.dart';
import 'package:quickstock/features/dashboard/presentation/widgets/app_drawer.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<DashboardViewModel>(),
      child: const _DashboardPage(),
    );
  }
}

class _DashboardPage extends StatefulWidget {
  const _DashboardPage();

  @override
  State<_DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<_DashboardPage> {
  late PageContent _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = const HomeView();
  }

  void _onSelectItem(PageContent page) {
    if (page.title == _currentPage.title) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      _currentPage = page;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardViewModel, DashboardState>(
      listener: (context, state) {
        if (state is DashboardLogoutSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder:
                  (context) => BlocProvider.value(
                    value: serviceLocator<LoginViewModel>(),
                    child: LoginView(),
                  ),
            ),
            (route) => false,
          );
        } else if (state is DashboardLogoutFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text('Logout failed: ${state.message}'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(_currentPage.title)),
        drawer: AppDrawer(
          currentPage: _currentPage,
          onSelectItem: _onSelectItem,
        ),
        body: _currentPage,
      ),
    );
  }
}

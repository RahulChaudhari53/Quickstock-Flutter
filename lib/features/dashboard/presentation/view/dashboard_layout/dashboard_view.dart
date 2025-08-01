// lib/features/dashboard/presentation/view/dashboard
import 'package:flutter/material.dart';
import 'package:quickstock/features/dashboard/presentation/page_content.dart';
import 'package:quickstock/features/dashboard/presentation/view/home/home_view.dart';
import 'package:quickstock/features/dashboard/presentation/widgets/app_drawer.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
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
    return Scaffold(
      appBar: AppBar(title: Text(_currentPage.title)),
      drawer: AppDrawer(currentPage: _currentPage, onSelectItem: _onSelectItem),
      body: _currentPage,
    );
  }
}

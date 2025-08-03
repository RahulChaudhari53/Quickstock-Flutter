import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/categories/presentation/view/category_view.dart';
import 'package:quickstock/features/dashboard/presentation/page_content.dart';
import 'package:quickstock/features/dashboard/presentation/view/home/home_view.dart';
import 'package:quickstock/features/dashboard/presentation/view_model/dashboard_layout_viewmodel/dashboard_event.dart';
import 'package:quickstock/features/dashboard/presentation/view_model/dashboard_layout_viewmodel/dashboard_view_model.dart';
import 'package:quickstock/features/product/presentation/view/product_view.dart';
import 'package:quickstock/features/profile/presentation/view/profile_view.dart';
import 'package:quickstock/features/sales/presentation/view/sales_history_view.dart';
import 'package:quickstock/features/stock/presentation/view/stock_view.dart';
import 'package:quickstock/features/supplier/presentation/view/supplier_view.dart';

class AppDrawer extends StatelessWidget {
  final PageContent currentPage;
  final void Function(PageContent) onSelectItem;

  const AppDrawer({
    super.key,
    required this.currentPage,
    required this.onSelectItem,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurple),
            child: Text(
              "QuickStock Menu",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),

          // home
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Home'),
            selected: currentPage.title == 'Home',
            onTap: () => onSelectItem(const HomeView()),
          ),

          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Categories'),
            selected: currentPage.title == 'Manage Categories',
            onTap: () => onSelectItem(const CategoriesView()),
          ),

          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Suppliers'),
            selected: currentPage.title == 'Manage Suppliers',
            onTap: () => onSelectItem(const SuppliersView()),
          ),

          // product selection
          ListTile(
            leading: const Icon(Icons.inventory_outlined),
            title: const Text('Products'),
            selected: currentPage.title == 'Products',
            onTap: () => onSelectItem(const ProductView()),
          ),

          // sales selection
          ListTile(
            leading: const Icon(Icons.point_of_sale_rounded),
            title: const Text('Sales'),
            selected: currentPage.title == 'Sales History',
            onTap: () => onSelectItem(const SalePage()),
          ),

          // purchase selection
          // ListTile(
          //   leading: const Icon(Icons.shopping_bag_outlined),
          //   title: const Text('Purchases'),
          //   selected: currentPage.title == const PurchasePage().title,
          //   onTap: () => onSelectItem(const PurchasePage()),
          // ),

          // stock selection
          ListTile(
            leading: const Icon(Icons.inventory_2_outlined),
            title: const Text('Stock'),
            selected: currentPage.title == 'Stock Overview',
            onTap: () => onSelectItem(const StockView()),
          ),

          //divider
          const Divider(thickness: 1, indent: 16, endIndent: 16),

          // Profile
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(const ProfileView().title),
            selected: currentPage.title == const ProfileView().title,
            onTap: () => onSelectItem(const ProfileView()),
          ),

          // logout
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: const Text('Logout'),
            onTap: () {
              context.read<DashboardViewModel>().add(
                DashboardLogoutRequested(),
              );
            },
          ),
        ],
      ),
    );
  }
}

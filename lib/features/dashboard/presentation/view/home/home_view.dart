// lib/features/dashboard/presentation/view/home

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quickstock/app/service_locator/service_locator.dart';
import 'package:quickstock/features/dashboard/presentation/page_content.dart';
import 'package:quickstock/features/dashboard/presentation/view_model/home_viewmodel/home_event.dart';
import 'package:quickstock/features/dashboard/presentation/view_model/home_viewmodel/home_state.dart';
import 'package:quickstock/features/dashboard/presentation/view_model/home_viewmodel/home_view_model.dart';

class HomeView extends PageContent {
  const HomeView({super.key});

  @override
  String get title => 'Dashboard';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              serviceLocator<HomeViewModel>()..add(const FetchHomeEvent()),
      child: const _DashboardBody(),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) {
        if (state.isLoading && state.overview == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${state.errorMessage}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<HomeViewModel>().add(const FetchHomeEvent());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state.overview == null) {
          return const Center(child: Text('No dashboard data available.'));
        }

        final overview = state.overview!;
        final currencyFormat = NumberFormat.currency(
          locale: 'ne_NP',
          // symbol: '\$',
        );

        return RefreshIndicator(
          onRefresh: () async {
            context.read<HomeViewModel>().add(const FetchHomeEvent());
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _StatCard(
                      title: 'Total Stock Items',
                      value: overview.totalStockItems.toString(),
                      subtitle: '${overview.activeProducts} distinct products',
                      icon: Icons.inventory_2_outlined,
                    ),
                    _StatCard(
                      title: 'Inventory Value (Buy)',
                      value: currencyFormat.format(
                        overview.inventoryPurchaseValue,
                      ),
                      subtitle: 'Based on purchase price',
                      icon: Icons.attach_money_outlined,
                    ),
                    _StatCard(
                      title: 'Sales Orders',
                      value: overview.totalSalesOrders.toString(),
                      subtitle: 'In the last 30 days',
                      icon: Icons.shopping_cart_outlined,
                    ),
                    _StatCard(
                      title: 'Active Suppliers',
                      value: overview.activeSuppliers.toString(),
                      subtitle: 'Verified partners',
                      icon: Icons.people_outline,
                    ),
                    _StatCard(
                      title: 'Low Stock',
                      value: overview.lowStockCount.toString(),
                      icon: Icons.warning_amber_rounded,
                      isAlert: true,
                      action: Text(
                        'View Items ->',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                    _StatCard(
                      title: 'Out of Stock',
                      value: overview.outOfStockCount.toString(),
                      icon: Icons.cancel_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const _AnalyticsPlaceholderCard(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final String? subtitle;
  final Widget? action;
  final bool isAlert;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
    this.action,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    final cardColor =
        isAlert
            ? isDarkMode
                ? Colors.red.shade900.withOpacity(0.5)
                : Colors.red.shade50
            : theme.cardColor;
    final iconColor =
        isAlert ? colorScheme.error : theme.textTheme.bodySmall?.color;
    final valueColor =
        isAlert ? colorScheme.error : theme.textTheme.displaySmall?.color;

    return Container(
      width: MediaQuery.of(context).size.width / 2 - 24,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isAlert ? colorScheme.error.withOpacity(0.3) : theme.dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Text(title, style: theme.textTheme.labelMedium),
              Expanded(child: Text(title, style: theme.textTheme.labelMedium)),
              const SizedBox(width: 8),
              Icon(icon, color: iconColor, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!, style: theme.textTheme.bodySmall),
          ],
          if (action != null) ...[const SizedBox(height: 8), action!],
        ],
      ),
    );
  }
}

class _AnalyticsPlaceholderCard extends StatelessWidget {
  const _AnalyticsPlaceholderCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Analytics', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'More detailed charts for sales, purchases, and financial reports will be available here in a future update.',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

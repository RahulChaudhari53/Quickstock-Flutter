import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/app/service_locator/service_locator.dart';
import 'package:quickstock/features/dashboard/presentation/page_content.dart';
import 'package:quickstock/features/sales/presentation/view/create_sale_view.dart';
import 'package:quickstock/features/sales/presentation/view_model/sale_history/sale_history_event.dart';
import 'package:quickstock/features/sales/presentation/view_model/sale_history/sale_history_view_model.dart';
import 'package:quickstock/features/sales/presentation/view_model/sale_history/sales_history_state.dart';
import 'package:quickstock/features/sales/presentation/widget/sale_filter_bar.dart';
import 'package:quickstock/features/sales/presentation/widget/sale_list.dart';

class SalePage extends PageContent {
  const SalePage({super.key});

  @override
  String get title => 'Sales History';

  @override
  Widget build(BuildContext context) {
    return const SalesHistoryView();
  }
}

class SalesHistoryView extends StatelessWidget {
  const SalesHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              serviceLocator<SalesHistoryViewModel>()
                ..add(const FetchSalesEvent()),
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const CreateSaleView()));
          },
          label: const Text('New Sale'),
          icon: const Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const SaleFilterBar(),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<SalesHistoryViewModel, SalesHistoryState>(
                  builder: (context, state) {
                    if (state.isLoading && state.sales.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.errorMessage != null && state.sales.isEmpty) {
                      return Center(
                        child: Text('Error: ${state.errorMessage}'),
                      );
                    }
                    if (state.sales.isEmpty && !state.isLoading) {
                      return const Center(child: Text('No sales found.'));
                    }
                    return const SaleList();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

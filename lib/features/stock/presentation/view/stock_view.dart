import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/app/service_locator/service_locator.dart';
import 'package:quickstock/features/dashboard/presentation/page_content.dart';
import 'package:quickstock/features/stock/presentation/view_model/stock_view_model/stock_event.dart';
import 'package:quickstock/features/stock/presentation/view_model/stock_view_model/stock_state.dart';
import 'package:quickstock/features/stock/presentation/view_model/stock_view_model/stock_view_model.dart';
import 'package:quickstock/features/stock/presentation/widgets/stock_filter_bar.dart';
import 'package:quickstock/features/stock/presentation/widgets/stock_list.dart';

class StockView extends PageContent {
  const StockView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              serviceLocator<StockViewModel>()
                ..add(const FetchStockListEvent()),
      child: const StockViewContent(),
    );
  }

  @override
  String get title => "Stock Overview";
}

class StockViewContent extends StatelessWidget {
  const StockViewContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const StockFilterBar(),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<StockViewModel, StockState>(
              buildWhen:
                  (previous, current) =>
                      previous.isLoading != current.isLoading ||
                      previous.errorMessage != current.errorMessage ||
                      previous.stocks.isEmpty != current.stocks.isEmpty,
              builder: (context, state) {
                if (state.isLoading && state.stocks.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.errorMessage != null && state.stocks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Failed to load stock: ${state.errorMessage}'),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            context.read<StockViewModel>().add(
                              const FetchStockListEvent(),
                            );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state.stocks.isEmpty) {
                  return const Center(child: Text('No stock items found.'));
                }

                return const StockList();
              },
            ),
          ),
        ],
      ),
    );
  }
}

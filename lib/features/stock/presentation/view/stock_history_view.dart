import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/app/service_locator/service_locator.dart';
import 'package:quickstock/features/stock/presentation/view_model/stock_history_view_model/stock_history_event.dart';
import 'package:quickstock/features/stock/presentation/view_model/stock_history_view_model/stock_history_state.dart';
import 'package:quickstock/features/stock/presentation/view_model/stock_history_view_model/stock_history_view_model.dart';
import 'package:quickstock/features/stock/presentation/widgets/history_timeline.dart';

class StockHistoryView extends StatelessWidget {
  final String productId;
  final String productName;
  final String productSku;

  const StockHistoryView({
    super.key,
    required this.productId,
    required this.productName,
    required this.productSku,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              serviceLocator<StockHistoryViewModel>()
                ..add(FetchStockHistoryEvent(productId: productId)),
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Stock Movement History'),
              Text(
                '$productName ($productSku)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
        body: const _StockHistoryContent(),
      ),
    );
  }
}

class _StockHistoryContent extends StatelessWidget {
  const _StockHistoryContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocBuilder<StockHistoryViewModel, StockHistoryState>(
        buildWhen:
            (previous, current) =>
                previous.isLoading != current.isLoading ||
                previous.errorMessage != current.errorMessage ||
                previous.history.isEmpty != current.history.isEmpty,
        builder: (context, state) {
          if (state.isLoading && state.history.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null && state.history.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Failed to load history: ${state.errorMessage}'),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      final productId =
                          context.read<StockHistoryViewModel>().state.props[0];
                      context.read<StockHistoryViewModel>().add(
                        FetchStockHistoryEvent(productId: productId as String),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.history.isEmpty) {
            return const Center(
              child: Text('No movement history found for this product.'),
            );
          }

          return const HistoryTimeline();
        },
      ),
    );
  }
}

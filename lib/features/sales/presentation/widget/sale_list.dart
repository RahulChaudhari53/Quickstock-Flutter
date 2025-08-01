import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/sales/presentation/view_model/sale_history/sale_history_event.dart';
import 'package:quickstock/features/sales/presentation/view_model/sale_history/sale_history_view_model.dart';
import 'package:quickstock/features/sales/presentation/view_model/sale_history/sales_history_state.dart';
import 'package:quickstock/features/sales/presentation/widget/sale_card.dart';

class SaleList extends StatefulWidget {
  const SaleList({super.key});

  @override
  State<SaleList> createState() => _SaleListState();
}

class _SaleListState extends State<SaleList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<SalesHistoryViewModel>().add(const FetchNextSalePageEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 50);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesHistoryViewModel, SalesHistoryState>(
      buildWhen:
          (previous, current) =>
              previous.sales != current.sales ||
              previous.isPaginating != current.isPaginating,
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<SalesHistoryViewModel>().add(const FetchSalesEvent());
          },
          child: ListView.builder(
            controller: _scrollController,
            itemCount:
                state.isPaginating
                    ? state.sales.length + 1
                    : state.sales.length,
            itemBuilder: (context, index) {
              if (index >= state.sales.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final saleItem = state.sales[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: SaleCard(saleItem: saleItem),
              );
            },
          ),
        );
      },
    );
  }
}

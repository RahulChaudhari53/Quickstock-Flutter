import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/stock/presentation/view_model/stock_view_model/stock_event.dart';
import 'package:quickstock/features/stock/presentation/view_model/stock_view_model/stock_state.dart';
import 'package:quickstock/features/stock/presentation/view_model/stock_view_model/stock_view_model.dart';
import 'package:quickstock/features/stock/presentation/widgets/stock_card.dart';

class StockList extends StatefulWidget {
  const StockList({super.key});

  @override
  State<StockList> createState() => _StockListState();
}

class _StockListState extends State<StockList> {
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
      context.read<StockViewModel>().add(const FetchNextStockPageEvent());
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
    return BlocBuilder<StockViewModel, StockState>(
      buildWhen:
          (previous, current) =>
              previous.stocks != current.stocks ||
              previous.isPaginating != current.isPaginating,
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<StockViewModel>().add(const FetchStockListEvent());
          },
          child: ListView.builder(
            controller: _scrollController,
            itemCount:
                state.isPaginating
                    ? state.stocks.length + 1
                    : state.stocks.length,
            itemBuilder: (context, index) {
              if (index >= state.stocks.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final stockItem = state.stocks[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: StockCard(stockItem: stockItem),
              );
            },
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/stock/presentation/view_model/stock_history_view_model/stock_history_event.dart';
import 'package:quickstock/features/stock/presentation/view_model/stock_history_view_model/stock_history_state.dart';
import 'package:quickstock/features/stock/presentation/view_model/stock_history_view_model/stock_history_view_model.dart';
import 'package:quickstock/features/stock/presentation/widgets/history_tile.dart';

class HistoryTimeline extends StatefulWidget {
  const HistoryTimeline({super.key});

  @override
  State<HistoryTimeline> createState() => _HistoryTimelineState();
}

class _HistoryTimelineState extends State<HistoryTimeline> {
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
      context.read<StockHistoryViewModel>().add(
        const FetchNextStockHistoryPageEvent(),
      );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    if (_scrollController.position.maxScrollExtent == 0) return false;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 50);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StockHistoryViewModel, StockHistoryState>(
      buildWhen:
          (previous, current) =>
              previous.history != current.history ||
              previous.isPaginating != current.isPaginating,
      builder: (context, state) {
        return ListView.builder(
          controller: _scrollController,
          itemCount:
              state.isPaginating
                  ? state.history.length + 1
                  : state.history.length,
          itemBuilder: (context, index) {
            if (index >= state.history.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final historyItem = state.history[index];
            return HistoryTile(historyItem: historyItem);
          },
        );
      },
    );
  }
}

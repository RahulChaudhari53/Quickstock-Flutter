import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/purchase/presentation/view_model/purchase_history/purchase_history_event.dart'
    show FetchNextPage;
import 'package:quickstock/features/purchase/presentation/view_model/purchase_history/purchase_history_state.dart';
import 'package:quickstock/features/purchase/presentation/view_model/purchase_history/purchase_history_view_model.dart';
import 'package:quickstock/features/purchase/presentation/widgets/purchase_card.dart';

class PurchaseList extends StatefulWidget {
  const PurchaseList({super.key});

  @override
  State<PurchaseList> createState() => _PurchaseListState();
}

class _PurchaseListState extends State<PurchaseList> {
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
      // --- THIS IS THE CORRECTED PART ---
      // We create a specific instance of the event to add.
      final event = FetchNextPage();
      context.read<PurchaseHistoryViewModel>().add(event);
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
    return BlocBuilder<PurchaseHistoryViewModel, PurchaseHistoryState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount:
              state.hasReachedMax
                  ? state.purchases.length
                  : state.purchases.length + 1,
          controller: _scrollController,
          itemBuilder: (context, index) {
            if (index >= state.purchases.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final purchase = state.purchases[index];
            return PurchaseCard(purchase: purchase);
          },
        );
      },
    );
  }
}

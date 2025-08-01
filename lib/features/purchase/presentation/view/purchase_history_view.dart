import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/app/service_locator/service_locator.dart';
import 'package:quickstock/features/dashboard/presentation/page_content.dart';
import 'package:quickstock/features/purchase/presentation/view/create_purchase_view.dart';
import 'package:quickstock/features/purchase/presentation/view_model/purchase_history/purchase_history_event.dart';
import 'package:quickstock/features/purchase/presentation/view_model/purchase_history/purchase_history_state.dart';
import 'package:quickstock/features/purchase/presentation/view_model/purchase_history/purchase_history_view_model.dart';
import 'package:quickstock/features/purchase/presentation/widgets/purchase_filter_bar.dart';
import 'package:quickstock/features/purchase/presentation/widgets/purchase_list.dart';

class PurchasePage extends PageContent {
  const PurchasePage({super.key});

  @override
  String get title => 'Purchase Orders';

  @override
  Widget build(BuildContext context) {
    return const PurchaseHistoryView();
  }
}

/// This is the main screen widget that provides the BLoC and Scaffold.
class PurchaseHistoryView extends StatelessWidget {
  const PurchaseHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              serviceLocator<PurchaseHistoryViewModel>()
                ..add(FetchInitialPurchases()),
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Navigate to the create screen. A result can be awaited
            // to trigger a refresh if needed when the user comes back.
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CreatePurchaseView()),
            );
          },
          label: const Text('New Purchase'),
          icon: const Icon(Icons.add),
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: 16),
              PurchaseFilterBar(), // The widget with search and dropdowns
              SizedBox(height: 16),
              Expanded(
                child:
                    PurchaseHistoryContent(), // The widget that shows the list or loaders
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// This widget builds the main content area based on the ViewModel's state.
/// It decides whether to show a loader, an error message, or the purchase list.
class PurchaseHistoryContent extends StatelessWidget {
  const PurchaseHistoryContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchaseHistoryViewModel, PurchaseHistoryState>(
      builder: (context, state) {
        // This switch statement handles what to show based on the current state.
        switch (state.status) {
          case PurchaseHistoryStatus.failure:
            // Only show a full-screen error if the list is empty.
            // Otherwise, the list will be visible, and an error can be shown as a snackbar.
            return state.purchases.isEmpty
                ? Center(
                  child: Text(
                    'Error: ${state.errorMessage ?? "An unknown error occurred"}',
                  ),
                )
                : const PurchaseList();

          case PurchaseHistoryStatus.initial:
          case PurchaseHistoryStatus.loading:
            // Only show a full-screen loader on the very first load.
            return state.purchases.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : const PurchaseList();

          case PurchaseHistoryStatus.success:
          case PurchaseHistoryStatus.loadingNextPage:
            // If the fetch was successful but the list is still empty, show a message.
            return state.purchases.isEmpty
                ? const Center(child: Text('No purchase orders found.'))
                : const PurchaseList();
        }
      },
    );
  }
}

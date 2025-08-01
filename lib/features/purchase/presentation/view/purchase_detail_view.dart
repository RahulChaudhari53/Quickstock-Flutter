import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quickstock/app/service_locator/service_locator.dart';
import 'package:quickstock/features/purchase/presentation/view_model/purchase_detail/purchase_detail_event.dart';
import 'package:quickstock/features/purchase/presentation/view_model/purchase_detail/purchase_detail_state.dart';
import 'package:quickstock/features/purchase/presentation/view_model/purchase_detail/purchase_detail_view_model.dart';
import 'package:quickstock/features/purchase/presentation/widgets/purchase_item_detail_tile.dart';

class PurchaseDetailView extends StatelessWidget {
  final String purchaseId;

  const PurchaseDetailView({super.key, required this.purchaseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // We will need to register this ViewModel in the service_locator.dart file
        // For now, assuming it will be registered like this:
        // serviceLocator.registerFactory(() => PurchaseDetailViewModel(...));
        return serviceLocator<PurchaseDetailViewModel>()
          ..add(FetchPurchaseDetails(purchaseId));
      },
      // BlocListener is used for 'one-time' actions like showing dialogs or snackbars
      child: BlocListener<PurchaseDetailViewModel, PurchaseDetailState>(
        listener: (context, state) {
          // Listen for a success message from an action
          if (state.actionStatus == ActionStatus.success &&
              state.successMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.successMessage!),
                  backgroundColor: Colors.green,
                ),
              );
          }
          // Listen for an error message from an action
          if (state.actionStatus == ActionStatus.failure &&
              state.actionErrorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.actionErrorMessage!),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Purchase Details'),
            // The action buttons in the AppBar are built based on the state
            actions: [
              BlocBuilder<PurchaseDetailViewModel, PurchaseDetailState>(
                builder: (context, state) {
                  // Only show buttons if the purchase is loaded and status is 'ordered'
                  if (state.pageStatus == PageStatus.success &&
                      state.purchase?.purchaseStatus == 'ordered') {
                    // Show a loading indicator on the buttons if an action is in progress
                    if (state.actionStatus == ActionStatus.loading) {
                      return const Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      );
                    }
                    // Otherwise, show the action buttons
                    return Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            context.read<PurchaseDetailViewModel>().add(
                              const CancelPurchaseRequested(),
                            );
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            context.read<PurchaseDetailViewModel>().add(
                              const ReceivePurchaseRequested(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Receive Items'),
                        ),
                        const SizedBox(width: 8),
                      ],
                    );
                  }
                  // Return an empty container if conditions aren't met
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          body: const PurchaseDetailContent(),
        ),
      ),
    );
  }
}

/// The main content area that builds based on the page loading status.
class PurchaseDetailContent extends StatelessWidget {
  const PurchaseDetailContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchaseDetailViewModel, PurchaseDetailState>(
      // buildWhen makes this widget only rebuild for page status changes, not action status changes.
      buildWhen:
          (previous, current) => previous.pageStatus != current.pageStatus,
      builder: (context, state) {
        switch (state.pageStatus) {
          case PageStatus.loading:
          case PageStatus.initial:
            return const Center(child: CircularProgressIndicator());
          case PageStatus.failure:
            return Center(
              child: Text(
                'Error: ${state.pageErrorMessage ?? "Could not load details."}',
              ),
            );
          case PageStatus.success:
            if (state.purchase == null) {
              return const Center(child: Text('Purchase details not found.'));
            }
            // If success and data is available, show the details.
            final purchase = state.purchase!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Details Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                purchase.purchaseNumber,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Order Date: ${DateFormat.yMd().format(purchase.orderDate)}',
                              ),
                            ],
                          ),
                          Chip(
                            label: Text(
                              purchase.purchaseStatus.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor:
                                purchase.purchaseStatus == 'ordered'
                                    ? Colors.blue.shade700
                                    : purchase.purchaseStatus == 'received'
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Supplier and Payment Method Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'SUPPLIER',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  purchase.supplier.name,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'PAYMENT METHOD',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  purchase.paymentMethod,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Items Ordered Section
                  Text(
                    'Items Ordered',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Divider(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: purchase.items.length,
                    itemBuilder: (context, index) {
                      final item = purchase.items[index];
                      return PurchaseItemDetailTile(item: item);
                    },
                  ),
                  const Divider(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Total Amount: ${NumberFormat.simpleCurrency(decimalDigits: 2, name: '\$').format(purchase.totalAmount)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/app/service_locator/service_locator.dart';
import 'package:quickstock/features/purchase/domain/entity/purchase_entity.dart';
import 'package:quickstock/features/purchase/presentation/view_model/create_purchase/create_purchase_event.dart';
import 'package:quickstock/features/purchase/presentation/view_model/create_purchase/create_purchase_state.dart';
import 'package:quickstock/features/purchase/presentation/view_model/create_purchase/create_purchase_view_model.dart';
import 'package:quickstock/features/purchase/presentation/widgets/purchase_item_row.dart';

class CreatePurchaseView extends StatelessWidget {
  final PurchaseEntity? purchaseToEdit;

  const CreatePurchaseView({super.key, this.purchaseToEdit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // The BlocProvider ONLY creates the ViewModel now. It does not dispatch any events.
      create: (context) => serviceLocator<CreatePurchaseViewModel>(),
      child: BlocListener<CreatePurchaseViewModel, CreatePurchaseState>(
        listenWhen:
            (previous, current) =>
                previous.submissionStatus != current.submissionStatus,
        listener: (context, state) {
          if (state.submissionStatus == FormSubmissionStatus.success) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.successMessage ?? 'Success!'),
                  backgroundColor: Colors.green,
                ),
              );
            Navigator.of(context).pop(true);
          }
          if (state.submissionStatus == FormSubmissionStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'An error occurred.'),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        // We pass the purchaseToEdit data to the content widget.
        child: _CreatePurchaseViewContent(purchaseToEdit: purchaseToEdit),
      ),
    );
  }
}

// --- CONVERTED TO A STATEFUL WIDGET ---
class _CreatePurchaseViewContent extends StatefulWidget {
  final PurchaseEntity? purchaseToEdit;
  const _CreatePurchaseViewContent({this.purchaseToEdit});

  @override
  State<_CreatePurchaseViewContent> createState() =>
      _CreatePurchaseViewContentState();
}

class _CreatePurchaseViewContentState
    extends State<_CreatePurchaseViewContent> {
  @override
  void initState() {
    super.initState();
    // Dispatch the event here, AFTER the widget is first inserted into the tree.
    // This allows the UI to build a loading spinner immediately without waiting for the network call.
    context.read<CreatePurchaseViewModel>().add(
      InitializeForm(purchaseToEdit: widget.purchaseToEdit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePurchaseViewModel, CreatePurchaseState>(
      builder: (context, state) {
        final bool isEditMode = state.formMode == FormMode.edit;
        final bool isSubmitting =
            state.submissionStatus == FormSubmissionStatus.loading;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              isEditMode ? 'Edit Purchase Order' : 'New Purchase Order',
            ),
          ),
          body: _buildBody(context, state),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed:
                  isSubmitting
                      ? null
                      : () => context.read<CreatePurchaseViewModel>().add(
                        const FormSubmitted(),
                      ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child:
                  isSubmitting
                      ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                      : Text(isEditMode ? 'Save Changes' : 'Create Purchase'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, CreatePurchaseState state) {
    if (state.formDataStatus == FormDataStatus.loading ||
        state.formDataStatus == FormDataStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.formDataStatus == FormDataStatus.failure) {
      return Center(child: Text(state.errorMessage ?? 'Failed to load data.'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value:
                      state.selectedSupplierId.isEmpty
                          ? null
                          : state.selectedSupplierId,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Supplier',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      state.availableSuppliers.map((supplier) {
                        return DropdownMenuItem(
                          value: supplier.id,
                          child: Text(supplier.name),
                        );
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      context.read<CreatePurchaseViewModel>().add(
                        SupplierChanged(value),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: state.selectedPaymentMethod,
                  decoration: const InputDecoration(
                    labelText: 'Payment Method',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'cash', child: Text('Cash')),
                    DropdownMenuItem(value: 'online', child: Text('Online')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      context.read<CreatePurchaseViewModel>().add(
                        PaymentMethodChanged(value),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Purchase Items', style: Theme.of(context).textTheme.titleLarge),
          const Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              return PurchaseItemRow(
                key: ValueKey(index),
                index: index,
                item: state.items[index],
                availableProducts: state.availableProducts,
              );
            },
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed:
                () => context.read<CreatePurchaseViewModel>().add(
                  const ItemAdded(),
                ),
            icon: const Icon(Icons.add),
            label: const Text('Add Item'),
          ),
          const Divider(height: 24),
          TextFormField(
            initialValue: state.notes,
            decoration: const InputDecoration(
              labelText: 'Notes (Optional)',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 4,
            onChanged:
                (value) => context.read<CreatePurchaseViewModel>().add(
                  NotesChanged(value),
                ),
          ),
        ],
      ),
    );
  }
}

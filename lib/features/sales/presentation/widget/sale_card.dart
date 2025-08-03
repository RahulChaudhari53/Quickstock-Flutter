import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quickstock/features/sales/domain/entity/sale_entity.dart';
import 'package:quickstock/features/sales/presentation/view/sale_detail_view.dart';
import 'package:quickstock/features/sales/presentation/view_model/sale_history/sale_history_event.dart';
import 'package:quickstock/features/sales/presentation/view_model/sale_history/sale_history_view_model.dart';
import 'package:quickstock/features/sales/presentation/view_model/sale_history/sales_history_state.dart';

class SaleCard extends StatelessWidget {
  final SaleEntity saleItem;

  const SaleCard({super.key, required this.saleItem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor =
        (theme.inputDecorationTheme.enabledBorder as OutlineInputBorder)
            .borderSide
            .color;
    final formattedDate = DateFormat('MMM d, yyyy').format(saleItem.saleDate);
    final formattedAmount = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    ).format(saleItem.totalAmount);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  saleItem.invoiceNumber,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  formattedAmount,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: [
                Chip(
                  avatar: Icon(Icons.calendar_today, size: 16),
                  label: Text(formattedDate),
                  labelStyle: theme.textTheme.labelMedium,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  side: BorderSide.none,
                ),
                Chip(
                  avatar: Icon(Icons.shopping_basket_outlined, size: 16),
                  label: Text('${saleItem.items.length} Items'),
                  labelStyle: theme.textTheme.labelMedium,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  side: BorderSide.none,
                ),
                Chip(
                  avatar: Icon(Icons.payment, size: 16),
                  label: Text(saleItem.paymentMethod.toUpperCase()),
                  labelStyle: theme.textTheme.labelMedium,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  side: BorderSide.none,
                ),
              ],
            ),
            const Divider(height: 24),
            BlocBuilder<SalesHistoryViewModel, SalesHistoryState>(
              builder: (context, state) {
                final isProcessing = state.processingSaleIds.contains(
                  saleItem.id,
                );

                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isProcessing)
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2.0),
                      )
                    else
                      TextButton.icon(
                        icon: const Icon(
                          Icons.cancel_outlined,
                          color: Colors.red,
                        ),
                        label: const Text(
                          'Cancel Sale',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () => _showCancelConfirmation(context),
                      ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.visibility_outlined, size: 18),
                      label: const Text('View Details'),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SaleDetailView(saleId: saleItem.id),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Cancel Sale?'),
          content: const Text(
            'Are you sure you want to cancel this sale? This will restock the items and permanently delete the sale record. This action cannot be undone.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Do Not Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            FilledButton.tonal(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.1),
              ),
              child: const Text(
                'Yes, Cancel Sale',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                context.read<SalesHistoryViewModel>().add(
                  CancelSaleEvent(saleId: saleItem.id),
                );
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

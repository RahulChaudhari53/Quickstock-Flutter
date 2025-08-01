import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickstock/features/purchase/domain/entity/purchase_entity.dart';
import 'package:quickstock/features/purchase/presentation/view/create_purchase_view.dart';
import 'package:quickstock/features/purchase/presentation/view/purchase_detail_view.dart';

class PurchaseCard extends StatelessWidget {
  final PurchaseEntity purchase;

  const PurchaseCard({super.key, required this.purchase});

  /// A helper function to determine the color of the status badge.
  Color _getStatusColor(String status) {
    switch (status) {
      case 'ordered':
        return Colors.blue.shade700;
      case 'received':
        return Colors.green.shade700;
      case 'cancelled':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      clipBehavior:
          Clip.antiAlias, // Ensures the InkWell ripple stays within the card's rounded corners
      child: InkWell(
        // The whole card is tappable to navigate to the detail view.
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PurchaseDetailView(purchaseId: purchase.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Purchase Number and Status Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    purchase.purchaseNumber,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Chip(
                    label: Text(
                      purchase.purchaseStatus.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    backgroundColor: _getStatusColor(purchase.purchaseStatus),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Middle section: Supplier and Date
              Text(
                'Supplier: ${purchase.supplier.name}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Order Date: ${DateFormat.yMd().format(purchase.orderDate)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Divider(height: 24),
              // Bottom row: Total Amount and Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    // Using NumberFormat for currency is more robust.
                    NumberFormat.simpleCurrency(
                      decimalDigits: 2,
                      name: '\$',
                    ).format(purchase.totalAmount),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildActionButtons(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// This widget builds the action buttons row conditionally.
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // The "View Details" button is always visible.
        IconButton(
          icon: const Icon(Icons.visibility_outlined),
          tooltip: 'View Details',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PurchaseDetailView(purchaseId: purchase.id),
              ),
            );
          },
        ),
        // The "Edit" button is ONLY visible if the status is 'ordered'.
        if (purchase.purchaseStatus == 'ordered')
          IconButton(
            icon: Icon(
              Icons.edit_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            tooltip: 'Edit Purchase',
            onPressed: () {
              // Navigate to the create/edit screen, passing the existing purchase
              // data to put the screen in "edit mode".
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CreatePurchaseView(purchaseToEdit: purchase),
                ),
              );
            },
          ),
      ],
    );
  }
}

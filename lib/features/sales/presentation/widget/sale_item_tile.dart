import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickstock/features/sales/domain/entity/sale_item_entity.dart';

class SaleItemTile extends StatelessWidget {
  final SaleItemEntity item;
  const SaleItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedUnitPrice = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    ).format(item.unitPrice);
    final formattedTotalPrice = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    ).format(item.totalPrice);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'SKU: ${item.product.sku}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.quantity} x $formattedUnitPrice',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                formattedTotalPrice,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickstock/features/purchase/domain/entity/purchase_item_entity.dart';

class PurchaseItemDetailTile extends StatelessWidget {
  final PurchaseItemEntity item;
  const PurchaseItemDetailTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
      title: Text(item.product.name),
      subtitle: Text('SKU: ${item.product.sku}'),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            NumberFormat.simpleCurrency(
              decimalDigits: 2,
              name: '\$',
            ).format(item.totalCost),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '${item.quantity} x ${NumberFormat.simpleCurrency(decimalDigits: 2, name: '\$').format(item.unitCost)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

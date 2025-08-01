import 'package:flutter/material.dart';
import 'package:quickstock/features/stock/domain/entity/stock_entity.dart';
import 'package:quickstock/features/stock/presentation/view/stock_history_view.dart';

class StockCard extends StatelessWidget {
  final StockEntity stockItem;

  const StockCard({super.key, required this.stockItem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = _getStockStatus(stockItem);
    final borderColor =
        (theme.inputDecorationTheme.enabledBorder as OutlineInputBorder)
            .borderSide
            .color;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start, 
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stockItem.product.name,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'SKU: ${stockItem.product.sku}',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Category: ${stockItem.product.categoryName}',
                    style: theme.textTheme.labelMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${stockItem.currentStock} / ${stockItem.product.minStockLevel}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: status.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Current / Min', style: theme.textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 12),
                Chip(
                  avatar: Icon(status.icon, color: status.color, size: 16),
                  label: Text(status.text, style: theme.textTheme.labelMedium),
                  backgroundColor: status.color.withOpacity(0.1),
                  side: BorderSide.none,
                ),
                const SizedBox(height: 8),
                IconButton(
                  icon: const Icon(Icons.visibility_outlined),
                  color: theme.primaryColor,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (_) => StockHistoryView(
                              productId: stockItem.product.id,
                              productName: stockItem.product.name,
                              productSku: stockItem.product.sku,
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _StockStatusInfo _getStockStatus(StockEntity stock) {
    if (stock.currentStock <= 0) {
      return _StockStatusInfo(
        'Out of Stock',
        Colors.red.shade600,
        Icons.cancel_rounded,
      );
    } else if (stock.currentStock <= stock.product.minStockLevel) {
      return _StockStatusInfo(
        'Low Stock',
        Colors.orange.shade700,
        Icons.warning_amber_rounded,
      );
    } else {
      return _StockStatusInfo(
        'In Stock',
        Colors.green.shade600,
        Icons.check_circle_rounded,
      );
    }
  }
}

class _StockStatusInfo {
  final String text;
  final Color color;
  final IconData icon;

  _StockStatusInfo(this.text, this.color, this.icon);
}

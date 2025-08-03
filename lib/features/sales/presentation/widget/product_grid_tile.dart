import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quickstock/features/product/domain/entity/product_entity.dart';
import 'package:quickstock/features/sales/presentation/view_model/create_sale/create_sale_event.dart';
import 'package:quickstock/features/sales/presentation/view_model/create_sale/create_sale_view_model.dart';

class ProductGridTile extends StatelessWidget {
  final ProductEntity product;
  const ProductGridTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor =
        (theme.inputDecorationTheme.enabledBorder as OutlineInputBorder)
            .borderSide
            .color;
    final formattedPrice = NumberFormat.currency(
      symbol: 'रु ',
      decimalDigits: 2,
    ).format(product.sellingPrice);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: theme.textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Stock: ${product.currentStock}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              formattedPrice,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add_shopping_cart, size: 16),
              label: const Text('Add'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              onPressed: () {
                context.read<CreateSaleViewModel>().add(
                  AddItemToCartEvent(product: product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

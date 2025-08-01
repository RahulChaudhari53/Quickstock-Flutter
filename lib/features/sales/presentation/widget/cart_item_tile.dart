import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quickstock/features/sales/presentation/view_model/create_sale/create_sale_event.dart';
import 'package:quickstock/features/sales/presentation/view_model/create_sale/create_sale_state.dart';
import 'package:quickstock/features/sales/presentation/view_model/create_sale/create_sale_view_model.dart';

class CartItemTile extends StatelessWidget {
  final CartItem cartItem;

  const CartItemTile({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedTotalPrice = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    ).format(cartItem.totalPrice);

    return ListTile(
      title: Text(cartItem.name, style: theme.textTheme.titleMedium),
      subtitle: Text(formattedTotalPrice, style: theme.textTheme.bodyMedium),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QuantitySelector(
            quantity: cartItem.quantity,
            onChanged: (newQuantity) {
              context.read<CreateSaleViewModel>().add(
                UpdateItemQuantityEvent(
                  productId: cartItem.productId,
                  newQuantity: newQuantity,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              context.read<CreateSaleViewModel>().add(
                RemoveItemFromCartEvent(productId: cartItem.productId),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Reusable Sub-Widget for Quantity Control 

class _QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;

  const _QuantitySelector({required this.quantity, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () {
            if (quantity > 0) {
              onChanged(quantity - 1);
            }
          },
        ),
        Text(
          quantity.toString(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () {
            onChanged(quantity + 1);
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/sales/presentation/view_model/create_sale/create_sale_event.dart';
import 'package:quickstock/features/sales/presentation/view_model/create_sale/create_sale_state.dart';
import 'package:quickstock/features/sales/presentation/view_model/create_sale/create_sale_view_model.dart';
import 'package:quickstock/features/sales/presentation/widget/cart_item_tile.dart';

class CurrentSaleTab extends StatelessWidget {
  const CurrentSaleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateSaleViewModel, CreateSaleState>(
      buildWhen: (previous, current) => previous.cartItems != current.cartItems,
      builder: (context, state) {
        if (state.cartItems.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text('Cart is empty'),
                Text('Add products from the "Products" tab to get started.'),
              ],
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: const Icon(Icons.clear_all, color: Colors.red),
                  label: const Text(
                    'Clear All',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    context.read<CreateSaleViewModel>().add(
                      const ClearCartEvent(),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: state.cartItems.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final cartItem = state.cartItems[index];
                  return CartItemTile(cartItem: cartItem);
                  // return ListTile(
                  //   // Placeholder
                  //   title: Text(cartItem.name),
                  //   subtitle: Text('Qty: ${cartItem.quantity}'),
                  // );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/sales/presentation/view_model/create_sale/create_sale_event.dart';
import 'package:quickstock/features/sales/presentation/view_model/create_sale/create_sale_state.dart';
import 'package:quickstock/features/sales/presentation/view_model/create_sale/create_sale_view_model.dart';
import 'package:quickstock/features/sales/presentation/widget/product_grid_tile.dart';

class ProductSelectionTab extends StatelessWidget {
  const ProductSelectionTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (query) {
              context.read<CreateSaleViewModel>().add(
                SearchProductsEvent(query: query),
              );
            },
            decoration: const InputDecoration(
              hintText: 'Search products by name or SKU...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<CreateSaleViewModel, CreateSaleState>(
            buildWhen:
                (previous, current) =>
                    previous.status != current.status ||
                    previous.filteredProducts != current.filteredProducts,
            builder: (context, state) {
              if (state.status == CreateSaleStatus.loadingProducts) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.filteredProducts.isEmpty) {
                return const Center(child: Text('No products found.'));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8, 
                ),
                itemCount: state.filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = state.filteredProducts[index];
                  return ProductGridTile(product: product);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

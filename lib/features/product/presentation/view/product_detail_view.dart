import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quickstock/app/service_locator/service_locator.dart';
import 'package:quickstock/features/product/domain/entity/product_entity.dart';
import 'package:quickstock/features/product/domain/entity/product_supplier_entity.dart';
import 'package:quickstock/features/product/presentation/view_model/product_detail_view_model/product_detail_event.dart';
import 'package:quickstock/features/product/presentation/view_model/product_detail_view_model/product_detail_state.dart';
import 'package:quickstock/features/product/presentation/view_model/product_detail_view_model/product_detail_view_model.dart';

class ProductDetailView extends StatelessWidget {
  final String productId;
  const ProductDetailView({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              serviceLocator<ProductDetailViewModel>()
                ..add(FetchProductDetails(productId)),
      child: const _ProductDetailBody(),
    );
  }
}

class _ProductDetailBody extends StatelessWidget {
  const _ProductDetailBody();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductDetailViewModel, ProductDetailState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: Colors.green,
              ),
            );
        }
        if (state.errorMessage != null && !state.isLoading) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
        }
      },
      builder: (context, state) {
        final product = state.product;
        return Scaffold(
          appBar: AppBar(
            title: Text(product?.name ?? 'Product Details'),
            actions: [
              if (product != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _ActivateDeactivateButton(
                    product: product,
                    isSubmitting: state.isSubmitting,
                  ),
                ),
            ],
          ),
          body: Builder(
            builder: (context) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (product == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Product not found.'),
                      if (state.errorMessage != null) Text(state.errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed:
                            () => context.read<ProductDetailViewModel>().add(
                              FetchProductDetails(state.product!.id),
                            ), // Assuming product is not null here
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              return _ProductDetailsContent(product: product);
            },
          ),
        );
      },
    );
  }
}

class _ActivateDeactivateButton extends StatelessWidget {
  final ProductEntity product;
  final bool isSubmitting;

  const _ActivateDeactivateButton({
    required this.product,
    required this.isSubmitting,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = product.isActive;
    return TextButton(
      onPressed:
          isSubmitting
              ? null
              : () {
                if (isActive) {
                  context.read<ProductDetailViewModel>().add(
                    DeactivateProductRequested(product.id),
                  );
                } else {
                  context.read<ProductDetailViewModel>().add(
                    ActivateProductRequested(product.id),
                  );
                }
              },
      child:
          isSubmitting
              ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              )
              : Text(isActive ? 'Deactivate' : 'Activate'),
    );
  }
}

class _ProductDetailsContent extends StatelessWidget {
  final ProductEntity product;
  const _ProductDetailsContent({required this.product});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'ne_NP',
    ); // , symbol: '\$'

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailCard(
            title: 'Product Name & SKU',
            value: product.name,
            subtitle: product.sku,
            icon: Icons.label_important_outline,
          ),
          if (product.description != null && product.description!.isNotEmpty)
            _DetailCard(
              title: 'Description',
              value: product.description!,
              icon: Icons.description_outlined,
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _DetailCard(
                  title: 'Category',
                  value: product.category.name,
                  icon: Icons.category_outlined,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: _SupplierDetailCard(supplier: product.supplier)),
            ],
          ),
          const SizedBox(height: 16),
          _DetailCard(
            title: 'Selling Price',
            value: currencyFormat.format(product.sellingPrice),
            icon: Icons.sell_outlined,
          ),
          _DetailCard(
            title: 'Purchase Price',
            value: currencyFormat.format(product.purchasePrice),
            icon: Icons.shopping_bag_outlined,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _DetailCard(
                  title: 'Current Stock',
                  value: '${product.currentStock} ${product.unit}(s)',
                  icon: Icons.inventory_2_outlined,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _DetailCard(
                  title: 'Min. Stock Level',
                  value: product.minStockLevel.toString(),
                  icon: Icons.warning_amber_rounded,
                ),
              ),
            ],
          ),
          _DetailCard(
            title: 'Status',
            value: product.isActive ? 'Active' : 'Inactive',
            icon:
                product.isActive
                    ? Icons.check_circle_outline
                    : Icons.cancel_outlined,
            valueColor:
                product.isActive
                    ? Colors.green
                    : Theme.of(context).colorScheme.error,
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? valueColor;

  const _DetailCard({
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Text(title, style: theme.textTheme.labelMedium),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
            if (subtitle != null)
              Text(subtitle!, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _SupplierDetailCard extends StatelessWidget {
  final ProductSupplierEntity supplier;
  const _SupplierDetailCard({required this.supplier});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.business_center_outlined,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text('Supplier', style: theme.textTheme.labelMedium),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              supplier.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (supplier.phone != null)
              Text(supplier.phone!, style: theme.textTheme.bodySmall),
            if (supplier.email != null)
              Text(supplier.email!, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

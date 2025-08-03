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
            // actions: [
            //   if (product != null)
            //     Padding(
            //       padding: const EdgeInsets.only(right: 8.0),
            //       child: _ActivateDeactivateButton(
            //         product: product,
            //         isSubmitting: state.isSubmitting,
            //       ),
            //     ),
            // ],
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
                            ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              return _ProductDetailsContent(product: product, context: context);
            },
          ),
        );
      },
    );
  }
}

// class _ActivateDeactivateButton extends StatelessWidget {
//   final ProductEntity product;
//   final bool isSubmitting;

//   const _ActivateDeactivateButton({
//     required this.product,
//     required this.isSubmitting,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final bool isActive = product.isActive;
//     return TextButton(
//       onPressed:
//           isSubmitting
//               ? null
//               : () {
//                 if (isActive) {
//                   context.read<ProductDetailViewModel>().add(
//                     DeactivateProductRequested(product.id),
//                   );
//                 } else {
//                   context.read<ProductDetailViewModel>().add(
//                     ActivateProductRequested(product.id),
//                   );
//                 }
//               },
//       child:
//           isSubmitting
//               ? const SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: CircularProgressIndicator(),
//               )
//               : Text(isActive ? 'Deactivate' : 'Activate'),
//     );
//   }
// }

class _ProductDetailsContent extends StatelessWidget {
  final ProductEntity product;
  final BuildContext context;

  const _ProductDetailsContent({required this.product, required this.context});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'ne_NP',
      symbol: 'NPR ',
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderCard(
            title: 'Product Name & SKU',
            name: product.name,
            sku: product.sku,
            icon: Icons.drive_file_rename_outline,
          ),
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _DetailCard(
                  title: 'Category',
                  value: product.category.name,
                  icon: Icons.widgets_outlined,
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
          const SizedBox(height: 16),
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
          const SizedBox(height: 16),

          if (product.description != null &&
              product.description!.isNotEmpty) ...[
            _DetailCard(
              title: 'Description',
              value: product.description!,
              icon: Icons.description_outlined,
            ),
            const SizedBox(height: 16),
          ],

          _StatusCard(isActive: product.isActive, context: context),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final String title;
  final String name;
  final String sku;
  final IconData icon;

  const _HeaderCard({
    required this.title,
    required this.name,
    required this.sku,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sku,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _DetailCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
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
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.storefront_outlined,
                size: 14,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text('Supplier', style: theme.textTheme.labelMedium),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            supplier.name,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          if (supplier.phone != null)
            Text(supplier.phone!, style: theme.textTheme.bodySmall),
          if (supplier.email != null)
            Text(supplier.email!, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final bool isActive;
  final BuildContext context;

  const _StatusCard({required this.isActive, required this.context});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isActive ? Colors.green : theme.colorScheme.error;
    final icon = isActive ? Icons.check_circle_outline : Icons.cancel_outlined;
    final text = isActive ? 'Active' : 'Inactive';

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 14,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text('Status', style: theme.textTheme.labelMedium),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                text,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

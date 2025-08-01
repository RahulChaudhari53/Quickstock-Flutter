import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/app/service_locator/service_locator.dart';
import 'package:quickstock/features/dashboard/presentation/page_content.dart';
import 'package:quickstock/features/product/domain/entity/product_entity.dart';
import 'package:quickstock/features/product/presentation/view/product_detail_view.dart';
import 'package:quickstock/features/product/presentation/view/product_form_view.dart';
import 'package:quickstock/features/product/presentation/view_model/product_form_view_model/product_form_state.dart';
import 'package:quickstock/features/product/presentation/view_model/product_view_viewmodel/product_event.dart';
import 'package:quickstock/features/product/presentation/view_model/product_view_viewmodel/product_state.dart';
import 'package:quickstock/features/product/presentation/view_model/product_view_viewmodel/product_view_model.dart';

class ProductView extends PageContent {
  const ProductView({super.key});

  @override
  String get title => 'Products';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              serviceLocator<ProductViewModel>()
                ..add(const FetchProducts(isRefresh: true)),
      child: const _ProductBody(),
    );
  }
}

class _ProductBody extends StatefulWidget {
  const _ProductBody();

  @override
  State<_ProductBody> createState() => _ProductBodyState();
}

class _ProductBodyState extends State<_ProductBody> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ProductViewModel>().add(FetchNextPage());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ProductFormView(mode: FormMode.create),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: BlocListener<ProductViewModel, ProductState>(
        listener: (context, state) {
          if (state.actionErrorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.actionErrorMessage!),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
          }
        },
        child: BlocBuilder<ProductViewModel, ProductState>(
          builder: (context, state) {
            if (state.isLoading && state.products.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.errorMessage != null && state.products.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.errorMessage!),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed:
                          () => context.read<ProductViewModel>().add(
                            const FetchProducts(isRefresh: true),
                          ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            if (state.products.isEmpty) {
              return const Center(child: Text('No products found.'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProductViewModel>().add(
                  const FetchProducts(isRefresh: true),
                );
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount:
                    state.hasReachedMax
                        ? state.products.length
                        : state.products.length + 1,
                itemBuilder: (context, index) {
                  if (index >= state.products.length) {
                    return state.isPaginating
                        ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                        : const SizedBox.shrink();
                  }
                  return _ProductListItem(product: state.products[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProductListItem extends StatelessWidget {
  final ProductEntity product;

  const _ProductListItem({required this.product});

  void _handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'view':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductDetailView(productId: product.id),
          ),
        );
        break;
      case 'edit':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (_) => ProductFormView(mode: FormMode.edit, product: product),
          ),
        );
        break;
      case 'activate':
      case 'deactivate':
        context.read<ProductViewModel>().add(
          ToggleProductStatus(
            productId: product.id,
            currentStatus: product.isActive,
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final togglingIds = context.select(
      (ProductViewModel vm) => vm.state.togglingProductIds,
    );
    final isToggling = togglingIds.contains(product.id);

    final stockProgress =
        product.minStockLevel > 0
            ? (product.currentStock / product.minStockLevel).clamp(0.0, 1.0)
            : 0.0;
    final stockColor =
        stockProgress < 0.3
            ? theme.colorScheme.error
            : stockProgress < 0.7
            ? Colors.orange
            : theme.colorScheme.primary;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                isToggling
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                    : PopupMenuButton<String>(
                      onSelected:
                          (value) => _handleMenuSelection(context, value),
                      itemBuilder:
                          (BuildContext context) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'view',
                              child: Text('View Details'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            PopupMenuItem<String>(
                              value:
                                  product.isActive ? 'deactivate' : 'activate',
                              child: Text(
                                product.isActive ? 'Deactivate' : 'Activate',
                              ),
                            ),
                          ],
                    ),
              ],
            ),
            Text(product.sku, style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            Row(
              children: [
                _InfoChip(
                  label: product.category.name,
                  icon: Icons.category_outlined,
                ),
                const SizedBox(width: 8),
                _InfoChip(
                  label: product.supplier.name,
                  icon: Icons.business_center_outlined,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Stock: ${product.currentStock} / ${product.minStockLevel}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: stockProgress,
              backgroundColor: stockColor.withOpacity(0.2),
              color: stockColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _InfoChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

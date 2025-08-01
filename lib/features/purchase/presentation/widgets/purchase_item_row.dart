import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/product/domain/entity/product_entity.dart';
import 'package:quickstock/features/purchase/presentation/view_model/create_purchase/create_purchase_event.dart';
import 'package:quickstock/features/purchase/presentation/view_model/create_purchase/create_purchase_state.dart';
import 'package:quickstock/features/purchase/presentation/view_model/create_purchase/create_purchase_view_model.dart';

class PurchaseItemRow extends StatefulWidget {
  final int index;
  final FormPurchaseItem item;
  final List<ProductEntity> availableProducts;

  const PurchaseItemRow({
    super.key,
    required this.index,
    required this.item,
    required this.availableProducts,
  });

  @override
  State<PurchaseItemRow> createState() => _PurchaseItemRowState();
}

class _PurchaseItemRowState extends State<PurchaseItemRow> {
  late final TextEditingController _productController;
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitCostController = TextEditingController();
  Timer? _quantityDebounce;
  Timer? _costDebounce;

  @override
  void initState() {
    super.initState();
    _productController = TextEditingController(
      text: widget.item.product?.name ?? '',
    );
    _quantityController.text = widget.item.quantity;
    _unitCostController.text = widget.item.unitCost;

    _quantityController.addListener(_onQuantityChanged);
    _unitCostController.addListener(_onCostChanged);
  }

  // We need to update the product controller if the state changes from elsewhere
  @override
  void didUpdateWidget(covariant PurchaseItemRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item.product != oldWidget.item.product) {
      _productController.text = widget.item.product?.name ?? '';
    }
  }

  @override
  void dispose() {
    _quantityDebounce?.cancel();
    _costDebounce?.cancel();
    _productController.dispose();
    _quantityController.dispose();
    _unitCostController.dispose();
    super.dispose();
  }

  void _onQuantityChanged() {
    if (_quantityDebounce?.isActive ?? false) _quantityDebounce!.cancel();
    _quantityDebounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        context.read<CreatePurchaseViewModel>().add(
          ItemUpdated(index: widget.index, quantity: _quantityController.text),
        );
      }
    });
  }

  void _onCostChanged() {
    if (_costDebounce?.isActive ?? false) _costDebounce!.cancel();
    _costDebounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        context.read<CreatePurchaseViewModel>().add(
          ItemUpdated(index: widget.index, unitCost: _unitCostController.text),
        );
      }
    });
  }

  double get _totalCost {
    final quantity = int.tryParse(widget.item.quantity) ?? 0;
    final unitCost = double.tryParse(widget.item.unitCost) ?? 0.0;
    return quantity * unitCost;
  }

  // --- Method to show the search dialog ---
  Future<void> _showProductSearch(BuildContext context) async {
    final selectedProduct = await showDialog<ProductEntity>(
      context: context,
      builder:
          (context) =>
              _ProductSearchDialog(availableProducts: widget.availableProducts),
    );

    // If the user selected a product, dispatch the event
    if (selectedProduct != null) {
      context.read<CreatePurchaseViewModel>().add(
        ItemUpdated(index: widget.index, productId: selectedProduct.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          // Product Selection TextFormField
          TextFormField(
            controller: _productController,
            readOnly: true, // Make it not directly editable
            decoration: const InputDecoration(
              labelText: 'Product',
              hintText: 'Select a Product',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
            onTap: () => _showProductSearch(context),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: _unitCostController,
                  decoration: const InputDecoration(
                    labelText: 'Unit Cost',
                    prefixText: '\$',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Total',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    '\$${_totalCost.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16, height: 2.5),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed:
                    () => context.read<CreatePurchaseViewModel>().add(
                      ItemRemoved(widget.index),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- Helper Widget: The Search Dialog ---

class _ProductSearchDialog extends StatefulWidget {
  final List<ProductEntity> availableProducts;
  const _ProductSearchDialog({required this.availableProducts});

  @override
  State<_ProductSearchDialog> createState() => _ProductSearchDialogState();
}

class _ProductSearchDialogState extends State<_ProductSearchDialog> {
  List<ProductEntity> _filteredProducts = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredProducts = widget.availableProducts;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts =
          widget.availableProducts
              .where((product) => product.name.toLowerCase().contains(query))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select a Product'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  return ListTile(
                    title: Text(product.name),
                    onTap: () {
                      // When an item is tapped, pop the dialog and return the selected product
                      Navigator.of(context).pop(product);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed:
              () =>
                  Navigator.of(context).pop(), // Pop without returning a value
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

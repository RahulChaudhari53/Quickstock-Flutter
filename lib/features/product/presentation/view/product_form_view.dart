import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/app/service_locator/service_locator.dart';
import 'package:quickstock/features/product/domain/entity/product_entity.dart';
import 'package:quickstock/features/product/presentation/view_model/product_form_view_model/product_form_event.dart';
import 'package:quickstock/features/product/presentation/view_model/product_form_view_model/product_form_state.dart';
import 'package:quickstock/features/product/presentation/view_model/product_form_view_model/product_form_view_model.dart'; // Change to ViewModel if you renamed the file

class ProductFormView extends StatelessWidget {
  final FormMode mode;
  final ProductEntity? product;

  const ProductFormView({super.key, required this.mode, this.product})
    : assert(
        mode == FormMode.create || (mode == FormMode.edit && product != null),
        'Product must be provided in edit mode.',
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              serviceLocator<ProductFormViewModel>()
                ..add(LoadProductForm(product: product)),
      child: const _ProductFormBody(),
    );
  }
}

class _ProductFormBody extends StatefulWidget {
  const _ProductFormBody();

  @override
  State<_ProductFormBody> createState() => _ProductFormBodyState();
}

class _ProductFormBodyState extends State<_ProductFormBody> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _skuController;
  late TextEditingController _descriptionController;
  late TextEditingController _purchasePriceController;
  late TextEditingController _sellingPriceController;
  late TextEditingController _minStockController;
  late TextEditingController _initialStockController;

  String? _selectedCategoryId;
  String? _selectedSupplierId;
  String? _selectedUnit;

  bool _initialDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _skuController = TextEditingController();
    _descriptionController = TextEditingController();
    _purchasePriceController = TextEditingController();
    _sellingPriceController = TextEditingController();
    _minStockController = TextEditingController();
    _initialStockController = TextEditingController(text: '0');

    _selectedUnit = 'piece';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _descriptionController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _minStockController.dispose();
    _initialStockController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final state = context.read<ProductFormViewModel>().state;
      context.read<ProductFormViewModel>().add(
        SubmitProductForm(
          productId: state.initialProduct?.id,
          name: _nameController.text,
          sku: _skuController.text,
          categoryId: _selectedCategoryId!,
          supplierId: _selectedSupplierId!,
          unit: _selectedUnit!,
          purchasePrice: double.parse(_purchasePriceController.text),
          sellingPrice: double.parse(_sellingPriceController.text),
          minStockLevel: int.parse(_minStockController.text),
          description: _descriptionController.text,
          initialStock:
              state.mode == FormMode.create
                  ? int.parse(_initialStockController.text)
                  : 0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductFormViewModel, ProductFormState>(
      // The listener handles side-effects and does NOT build UI
      listener: (context, state) {
        // Logic to set initial data ONCE
        if (state.initialProduct != null &&
            !state.isLoading &&
            !_initialDataLoaded) {
          final initialProduct = state.initialProduct!;
          _nameController.text = initialProduct.name;
          _skuController.text = initialProduct.sku;
          _descriptionController.text = initialProduct.description ?? '';
          _purchasePriceController.text =
              initialProduct.purchasePrice.toString();
          _sellingPriceController.text = initialProduct.sellingPrice.toString();
          _minStockController.text = initialProduct.minStockLevel.toString();

          // This setState is crucial to update the local variables that the dropdowns use
          setState(() {
            _selectedCategoryId = initialProduct.category.id;
            _selectedSupplierId = initialProduct.supplier.id;
            _selectedUnit = initialProduct.unit;
            _initialDataLoaded = true;
          });
        }

        // Logic for success/error messages
        if (state.status == FormSubmissionStatus.success) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: Colors.green,
              ),
            );
          Navigator.of(context).pop();
        }
        if (state.status == FormSubmissionStatus.error) {
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
      // The BlocBuilder handles building the UI based on the state
      child: BlocBuilder<ProductFormViewModel, ProductFormState>(
        builder: (context, state) {
          final isEditMode = state.mode == FormMode.edit;
          return Scaffold(
            appBar: AppBar(
              title: Text(isEditMode ? 'Edit Product' : 'Create Product'),
            ),
            body:
                state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildForm(context, state),
          );
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context, ProductFormState state) {
    final isEditMode = state.mode == FormMode.edit;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
              validator:
                  (value) => value!.isEmpty ? 'Please enter a name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _skuController,
              decoration: const InputDecoration(
                labelText: 'SKU (Stock Keeping Unit)',
              ),
              enabled: !isEditMode,
              validator:
                  (value) => value!.isEmpty ? 'Please enter a SKU' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategoryId,
              onChanged: (value) => setState(() => _selectedCategoryId = value),
              items:
                  state.categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category.id,
                          child: Text(category.name),
                        ),
                      )
                      .toList(),
              decoration: const InputDecoration(labelText: 'Category'),
              validator:
                  (value) => value == null ? 'Please select a category' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedSupplierId,
              onChanged: (value) => setState(() => _selectedSupplierId = value),
              items:
                  state.suppliers
                      .map(
                        (supplier) => DropdownMenuItem(
                          value: supplier.id,
                          child: Text(supplier.name),
                        ),
                      )
                      .toList(),
              decoration: const InputDecoration(labelText: 'Supplier'),
              validator:
                  (value) => value == null ? 'Please select a supplier' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedUnit,
              onChanged: (value) => setState(() => _selectedUnit = value),
              items:
                  const [
                        'piece',
                        'kg',
                        'gram',
                        'liter',
                        'ml',
                        'meter',
                        'cm',
                        'box',
                        'pack',
                        'dozen',
                        'pair',
                        'set',
                      ]
                      .map(
                        (unit) =>
                            DropdownMenuItem(value: unit, child: Text(unit)),
                      )
                      .toList(),
              decoration: const InputDecoration(labelText: 'Unit of Measure'),
              validator:
                  (value) => value == null ? 'Please select a unit' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _purchasePriceController,
                    decoration: const InputDecoration(
                      labelText: 'Purchase Price',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _sellingPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Selling Price',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _minStockController,
              decoration: const InputDecoration(
                labelText: 'Minimum Stock Level',
              ),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            if (!isEditMode) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _initialStockController,
                decoration: const InputDecoration(
                  labelText: 'Initial Stock Quantity',
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
            ],
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed:
                  state.status == FormSubmissionStatus.submitting
                      ? null
                      : _onSubmit,
              child:
                  state.status == FormSubmissionStatus.submitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(isEditMode ? 'Save Changes' : 'Create Product'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/product/domain/entity/product_entity.dart';
import 'package:quickstock/features/product/domain/entity/product_list_view_entity.dart';
import 'package:quickstock/features/product/domain/use_case/get_all_product_usecase.dart';
import 'package:quickstock/features/purchase/domain/use_case/create_purchase_usecase.dart';
import 'package:quickstock/features/purchase/domain/use_case/update_purchase_usecase.dart';
import 'package:quickstock/features/purchase/presentation/view_model/create_purchase/create_purchase_event.dart';
import 'package:quickstock/features/purchase/presentation/view_model/create_purchase/create_purchase_state.dart';
import 'package:quickstock/features/supplier/domain/entity/supplier_entity.dart';
import 'package:quickstock/features/supplier/domain/repository/supplier_repository.dart';
import 'package:quickstock/features/supplier/domain/use_case/get_suppliers_usecase.dart';

class CreatePurchaseViewModel
    extends Bloc<CreatePurchaseEvent, CreatePurchaseState> {
  final CreatePurchaseUsecase _createPurchaseUsecase;
  final UpdatePurchaseUsecase _updatePurchaseUsecase;
  final GetSuppliersUsecase _getSuppliersUsecase;
  final GetAllProductsUsecase _getAllProductsUsecase;

  CreatePurchaseViewModel({
    required CreatePurchaseUsecase createPurchaseUsecase,
    required UpdatePurchaseUsecase updatePurchaseUsecase,
    required GetSuppliersUsecase getAllSuppliersUsecase,
    required GetAllProductsUsecase getAllProductsUsecase,
  }) : _createPurchaseUsecase = createPurchaseUsecase,
       _updatePurchaseUsecase = updatePurchaseUsecase,
       _getSuppliersUsecase = getAllSuppliersUsecase,
       _getAllProductsUsecase = getAllProductsUsecase,
       super(const CreatePurchaseState()) {
    on<InitializeForm>(_onInitializeForm);
    on<SupplierChanged>(_onSupplierChanged);
    on<PaymentMethodChanged>(_onPaymentMethodChanged);
    on<NotesChanged>(_onNotesChanged);
    on<ItemAdded>(_onItemAdded);
    on<ItemRemoved>(_onItemRemoved);
    on<ItemUpdated>(_onItemUpdated);
    on<FormSubmitted>(_onFormSubmitted);
  }

  Future<void> _onInitializeForm(
    InitializeForm event,
    Emitter<CreatePurchaseState> emit,
  ) async {
    emit(state.copyWith(formDataStatus: FormDataStatus.loading));

    const supplierParams = GetSuppliersParams(
      page: 1,
      limit: 1000,
      isActive: true,
    );
    const productParams = GetAllProductsParams(
      page: 1,
      limit: 1000,
      isActive: true,
    );

    final results = await Future.wait([
      _getSuppliersUsecase(supplierParams),
      _getAllProductsUsecase(productParams),
    ]);

    final suppliersResult =
        results[0] as Either<Failure, PaginatedSuppliers>; // Explicit cast
    final productsResult =
        results[1] as Either<Failure, ProductListViewEntity>; // Explicit cast

    List<SupplierEntity> suppliers = [];
    suppliersResult.fold(
      (l) => null,
      // Assuming your paginated supplier entity has a 'suppliers' list. Adjust if necessary.
      (paginatedSuppliers) => suppliers = paginatedSuppliers.suppliers,
    );

    List<ProductEntity> products = [];
    productsResult.fold(
      (l) => null,
      // --- THIS IS THE CORRECTED PART ---
      // Use .items as per your entity definition
      (paginatedProducts) => products = paginatedProducts.items,
    );

    if (suppliersResult.isLeft() || productsResult.isLeft()) {
      emit(
        state.copyWith(
          formDataStatus: FormDataStatus.failure,
          errorMessage: "Failed to load required form data.",
        ),
      );
      return;
    }

    // ... (The rest of the method remains the same)

    if (event.purchaseToEdit != null) {
      final purchase = event.purchaseToEdit!;
      emit(
        state.copyWith(
          formMode: FormMode.edit,
          editPurchaseId: purchase.id,
          availableSuppliers: suppliers,
          availableProducts: products,
          selectedSupplierId: purchase.supplier.id,
          selectedPaymentMethod: purchase.paymentMethod,
          notes: purchase.notes ?? '',
          items:
              purchase.items.map((item) {
                // --- THIS IS THE FIRST CORRECTED PART ---
                // Use try-catch or a safer method to find the product.
                ProductEntity? productEntity;
                try {
                  productEntity = products.firstWhere(
                    (p) => p.id == item.product.id,
                  );
                } catch (e) {
                  // This case handles if a product in the purchase no longer exists or is inactive.
                  productEntity = null;
                }

                return FormPurchaseItem(
                  product: productEntity,
                  quantity: item.quantity.toString(),
                  unitCost: item.unitCost.toStringAsFixed(2),
                );
              }).toList(),
          formDataStatus: FormDataStatus.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          availableSuppliers: suppliers,
          availableProducts: products,
          formDataStatus: FormDataStatus.success,
        ),
      );
    }
  }

  // --- All other event handlers remain unchanged ---

  void _onSupplierChanged(
    SupplierChanged event,
    Emitter<CreatePurchaseState> emit,
  ) {
    emit(state.copyWith(selectedSupplierId: event.supplierId));
  }

  void _onPaymentMethodChanged(
    PaymentMethodChanged event,
    Emitter<CreatePurchaseState> emit,
  ) {
    emit(state.copyWith(selectedPaymentMethod: event.paymentMethod));
  }

  void _onNotesChanged(NotesChanged event, Emitter<CreatePurchaseState> emit) {
    emit(state.copyWith(notes: event.notes));
  }

  void _onItemAdded(ItemAdded event, Emitter<CreatePurchaseState> emit) {
    final updatedItems = List<FormPurchaseItem>.from(state.items)
      ..add(const FormPurchaseItem());
    emit(state.copyWith(items: updatedItems));
  }

  void _onItemRemoved(ItemRemoved event, Emitter<CreatePurchaseState> emit) {
    if (state.items.length > 1) {
      final updatedItems = List<FormPurchaseItem>.from(state.items)
        ..removeAt(event.index);
      emit(state.copyWith(items: updatedItems));
    }
  }

  void _onItemUpdated(ItemUpdated event, Emitter<CreatePurchaseState> emit) {
    final updatedItems = List<FormPurchaseItem>.from(state.items);
    final itemToUpdate = updatedItems[event.index];

    // --- THIS IS THE SECOND CORRECTED PART ---
    ProductEntity? product;
    if (event.productId != null) {
      try {
        product = state.availableProducts.firstWhere(
          (p) => p.id == event.productId,
        );
      } catch (e) {
        product = null;
      }
    } else {
      product = itemToUpdate.product;
    }

    updatedItems[event.index] = itemToUpdate.copyWith(
      product: product,
      quantity: event.quantity,
      unitCost: event.unitCost,
    );
    emit(state.copyWith(items: updatedItems));
  }

  Future<void> _onFormSubmitted(
    FormSubmitted event,
    Emitter<CreatePurchaseState> emit,
  ) async {
    if (state.selectedSupplierId.isEmpty) {
      emit(
        state.copyWith(
          submissionStatus: FormSubmissionStatus.failure,
          errorMessage: "Please select a supplier.",
        ),
      );
      return;
    }
    if (state.items.any(
      (item) =>
          item.product == null ||
          (int.tryParse(item.quantity) ?? 0) <= 0 ||
          (double.tryParse(item.unitCost) ?? -1) < 0,
    )) {
      emit(
        state.copyWith(
          submissionStatus: FormSubmissionStatus.failure,
          errorMessage:
              "Please ensure all items have a product, a valid quantity, and unit cost.",
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        submissionStatus: FormSubmissionStatus.loading,
        errorMessage: null,
        successMessage: null,
      ),
    );

    final itemsToSubmit =
        state.items
            .map(
              (item) => PurchaseCreationItem(
                productId: item.product!.id,
                quantity: int.parse(item.quantity),
                unitCost: double.parse(item.unitCost),
              ),
            )
            .toList();

    if (state.formMode == FormMode.edit) {
      final result = await _updatePurchaseUsecase(
        UpdatePurchaseParams(
          purchaseId: state.editPurchaseId!,
          supplierId: state.selectedSupplierId,
          paymentMethod: state.selectedPaymentMethod,
          notes: state.notes,
          items: itemsToSubmit,
        ),
      );
      result.fold(
        (failure) => emit(
          state.copyWith(
            submissionStatus: FormSubmissionStatus.failure,
            errorMessage: failure.message,
          ),
        ),
        (_) => emit(
          state.copyWith(
            submissionStatus: FormSubmissionStatus.success,
            successMessage: "Purchase updated successfully!",
          ),
        ),
      );
    } else {
      final result = await _createPurchaseUsecase(
        CreatePurchaseParams(
          supplierId: state.selectedSupplierId,
          paymentMethod: state.selectedPaymentMethod,
          notes: state.notes,
          items: itemsToSubmit,
        ),
      );
      result.fold(
        (failure) => emit(
          state.copyWith(
            submissionStatus: FormSubmissionStatus.failure,
            errorMessage: failure.message,
          ),
        ),
        (_) => emit(
          state.copyWith(
            submissionStatus: FormSubmissionStatus.success,
            successMessage: "Purchase created successfully!",
          ),
        ),
      );
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/categories/domain/entity/category_entity.dart';
import 'package:quickstock/features/categories/domain/use_case/get_all_categories_usecase.dart';
import 'package:quickstock/features/product/domain/use_case/create_product_usecase.dart';
import 'package:quickstock/features/product/domain/use_case/update_product_usecase.dart';
import 'package:quickstock/features/product/presentation/view_model/product_form_view_model/product_form_event.dart';
import 'package:quickstock/features/product/presentation/view_model/product_form_view_model/product_form_state.dart';
import 'package:quickstock/features/supplier/domain/entity/supplier_entity.dart';
import 'package:quickstock/features/supplier/domain/use_case/get_suppliers_usecase.dart';

class ProductFormViewModel extends Bloc<ProductFormEvent, ProductFormState> {
  final CreateProductUsecase _createProductUsecase;
  final UpdateProductUsecase _updateProductUsecase;
  final GetAllCategoriesUsecase _getAllCategoriesUsecase;
  final GetSuppliersUsecase _getSuppliersUsecase;

  ProductFormViewModel({
    required CreateProductUsecase createProductUsecase,
    required UpdateProductUsecase updateProductUsecase,
    required GetAllCategoriesUsecase getAllCategoriesUsecase,
    required GetSuppliersUsecase getSuppliersUsecase,
  }) : _createProductUsecase = createProductUsecase,
       _updateProductUsecase = updateProductUsecase,
       _getAllCategoriesUsecase = getAllCategoriesUsecase,
       _getSuppliersUsecase = getSuppliersUsecase,
       super(const ProductFormState.initial()) {
    on<LoadProductForm>(_onLoadProductForm);
    on<SubmitProductForm>(_onSubmitProductForm);
  }

  Future<void> _onLoadProductForm(
    LoadProductForm event,
    Emitter<ProductFormState> emit,
  ) async {
    // Set initial state and mode
    emit(
      state.copyWith(
        isLoading: true,
        mode: event.product == null ? FormMode.create : FormMode.edit,
        initialProduct: event.product,
        clearError: true,
      ),
    );

    try {
      // Fetch dropdown data in parallel
      final results = await Future.wait([
        _getAllCategoriesUsecase(
          const GetAllCategoriesParams(page: 1, limit: 1000, isActive: true),
        ),
        _getSuppliersUsecase(
          const GetSuppliersParams(page: 1, limit: 1000, isActive: true),
        ),
      ]);

      // extract results after await
      final categoriesResult =
          results[0] as Either<Failure, List<CategoryEntity>>;
      final suppliersResult =
          results[1] as Either<Failure, List<SupplierEntity>>;

      // process the results
      List<CategoryEntity>? finalCategories;
      List<SupplierEntity>? finalSuppliers;
      String? errorMessage;

      categoriesResult.fold(
        (failure) => errorMessage = failure.message,
        (categories) => finalCategories = categories,
      );

      // If the first call failed, don't bother checking the second
      if (errorMessage == null) {
        suppliersResult.fold(
          (failure) => errorMessage = failure.message,
          (suppliers) => finalSuppliers = suppliers,
        );
      }

      // Emit final state based on outcomes
      if (errorMessage != null) {
        emit(state.copyWith(isLoading: false, errorMessage: errorMessage));
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            categories: finalCategories,
            suppliers: finalSuppliers,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'An unexpected error occurred.',
        ),
      );
    }
  }

  Future<void> _onSubmitProductForm(
    SubmitProductForm event,
    Emitter<ProductFormState> emit,
  ) async {
    emit(
      state.copyWith(
        status: FormSubmissionStatus.submitting,
        clearError: true,
        clearSuccess: true,
      ),
    );

    final result =
        state.mode == FormMode.create
            ? await _createProductUsecase(
              CreateProductParams(
                name: event.name,
                sku: event.sku,
                categoryId: event.categoryId,
                supplierId: event.supplierId,
                unit: event.unit,
                purchasePrice: event.purchasePrice,
                sellingPrice: event.sellingPrice,
                minStockLevel: event.minStockLevel,
                description: event.description,
                initialStock: event.initialStock,
              ),
            )
            : await _updateProductUsecase(
              UpdateProductParams(
                productId: event.productId!,
                name: event.name,
                categoryId: event.categoryId,
                supplierId: event.supplierId,
                unit: event.unit,
                purchasePrice: event.purchasePrice,
                sellingPrice: event.sellingPrice,
                minStockLevel: event.minStockLevel,
                description: event.description,
              ),
            );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FormSubmissionStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (product) => emit(
        state.copyWith(
          status: FormSubmissionStatus.success,
          successMessage:
              state.mode == FormMode.create
                  ? 'Product created successfully.'
                  : 'Product updated successfully.',
        ),
      ),
    );
  }
}

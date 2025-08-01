import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/product/domain/use_case/activate_product_usecase.dart';
import 'package:quickstock/features/product/domain/use_case/deactivate_product_usecase.dart';
import 'package:quickstock/features/product/domain/use_case/get_product_by_id_usecase.dart';
import 'package:quickstock/features/product/presentation/view_model/product_detail_view_model/product_detail_event.dart';
import 'package:quickstock/features/product/presentation/view_model/product_detail_view_model/product_detail_state.dart';

class ProductDetailViewModel
    extends Bloc<ProductDetailEvent, ProductDetailState> {
  final GetProductByIdUsecase _getProductByIdUsecase;
  final ActivateProductUsecase _activateProductUsecase;
  final DeactivateProductUsecase _deactivateProductUsecase;

  ProductDetailViewModel({
    required GetProductByIdUsecase getProductByIdUsecase,
    required ActivateProductUsecase activateProductUsecase,
    required DeactivateProductUsecase deactivateProductUsecase,
  }) : _getProductByIdUsecase = getProductByIdUsecase,
       _activateProductUsecase = activateProductUsecase,
       _deactivateProductUsecase = deactivateProductUsecase,
       super(const ProductDetailState.initial()) {
    on<FetchProductDetails>(_onFetchProductDetails);
    on<DeactivateProductRequested>(_onDeactivateProduct);
    on<ActivateProductRequested>(_onActivateProduct);
  }

  Future<void> _onFetchProductDetails(
    FetchProductDetails event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _getProductByIdUsecase(event.productId);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (product) => emit(state.copyWith(isLoading: false, product: product)),
    );
  }

  Future<void> _onDeactivateProduct(
    DeactivateProductRequested event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(
      state.copyWith(isSubmitting: true, clearError: true, clearSuccess: true),
    );
    final result = await _deactivateProductUsecase(event.productId);
    result.fold(
      (failure) => emit(
        state.copyWith(isSubmitting: false, errorMessage: failure.message),
      ),
      (product) => emit(
        state.copyWith(
          isSubmitting: false,
          product: product,
          successMessage: 'Product deactivated successfully.',
        ),
      ),
    );
  }

  Future<void> _onActivateProduct(
    ActivateProductRequested event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(
      state.copyWith(isSubmitting: true, clearError: true, clearSuccess: true),
    );
    final result = await _activateProductUsecase(event.productId);
    result.fold(
      (failure) => emit(
        state.copyWith(isSubmitting: false, errorMessage: failure.message),
      ),
      (product) => emit(
        state.copyWith(
          isSubmitting: false,
          product: product,
          successMessage: 'Product activated successfully.',
        ),
      ),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/product/domain/entity/product_entity.dart';
import 'package:quickstock/features/product/domain/use_case/activate_product_usecase.dart';
import 'package:quickstock/features/product/domain/use_case/deactivate_product_usecase.dart';
import 'package:quickstock/features/product/domain/use_case/get_all_product_usecase.dart';
import 'package:quickstock/features/product/presentation/view_model/product_view_viewmodel/product_event.dart';
import 'package:quickstock/features/product/presentation/view_model/product_view_viewmodel/product_state.dart';

class ProductViewModel extends Bloc<ProductEvent, ProductState> {
  final GetAllProductsUsecase _getAllProductsUsecase;
  final ActivateProductUsecase _activateProductUsecase;
  final DeactivateProductUsecase _deactivateProductUsecase;

  ProductViewModel({
    required GetAllProductsUsecase getAllProductsUsecase,
    required ActivateProductUsecase activateProductUsecase,
    required DeactivateProductUsecase deactivateProductUsecase,
  }) : _getAllProductsUsecase = getAllProductsUsecase,
       _activateProductUsecase = activateProductUsecase,
       _deactivateProductUsecase = deactivateProductUsecase,

       super(const ProductState.initial()) {
    on<FetchProducts>(_onFetchProducts);
    on<FetchNextPage>(_onFetchNextPage);
    on<ToggleProductStatus>(_onToggleProductStatus);
  }

  Future<void> _onFetchProducts(
    FetchProducts event,
    Emitter<ProductState> emit,
  ) async {
    final int nextPage =
        event.isRefresh ? 1 : (state.pagination?.currentPage ?? 0) + 1;

    if (nextPage == 1) {
      emit(
        state.copyWith(
          isLoading: true,
          products: [],
          errorMessage: null,
          pagination: null,
          searchQuery: event.searchQuery,
          categoryId: event.categoryId,
          supplierId: event.supplierId,
          stockStatus: event.stockStatus,
        ),
      );
    } else {
      emit(state.copyWith(isPaginating: true, errorMessage: null));
    }

    final result = await _getAllProductsUsecase(
      GetAllProductsParams(
        page: nextPage,
        search: event.searchQuery,
        categoryId: event.categoryId,
        supplierId: event.supplierId,
        stockStatus: event.stockStatus,
        isActive: null,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          isPaginating: false,
          errorMessage: failure.message,
        ),
      ),
      (productListViewEntity) {
        final List<ProductEntity> newProducts =
            event.isRefresh
                ? productListViewEntity.items
                : [...state.products, ...productListViewEntity.items];

        emit(
          state.copyWith(
            isLoading: false,
            isPaginating: false,
            products: newProducts,
            pagination: productListViewEntity.pagination,
            errorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> _onFetchNextPage(
    FetchNextPage event,
    Emitter<ProductState> emit,
  ) async {
    if (state.isLoading || state.isPaginating || state.hasReachedMax) {
      return;
    }

    // final int nextPage = (state.pagination?.currentPage ?? 0) + 1;

    add(
      FetchProducts(
        isRefresh: false,
        searchQuery: state.searchQuery,
        categoryId: state.categoryId,
        supplierId: state.supplierId,
        stockStatus: state.stockStatus,
      ),
    );
  }

  Future<void> _onToggleProductStatus(
    ToggleProductStatus event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      state.copyWith(
        togglingProductIds: {...state.togglingProductIds, event.productId},
        clearActionError: true,
      ),
    );

    final result =
        event.currentStatus
            ? await _deactivateProductUsecase(event.productId)
            : await _activateProductUsecase(event.productId);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            togglingProductIds: {...state.togglingProductIds}
              ..remove(event.productId),
            actionErrorMessage: failure.message,
          ),
        );
      },
      (updatedProduct) {
        final products = List<ProductEntity>.from(state.products);
        final index = products.indexWhere((p) => p.id == event.productId);
        if (index != -1) {
          products[index] = updatedProduct;
        }

        emit(
          state.copyWith(
            products: products,
            togglingProductIds: {...state.togglingProductIds}
              ..remove(event.productId),
          ),
        );
      },
    );
  }
}

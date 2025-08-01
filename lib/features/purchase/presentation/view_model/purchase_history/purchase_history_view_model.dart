import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/purchase/domain/use_case/get_all_purchase_usecase.dart';
import 'package:quickstock/features/purchase/presentation/view_model/purchase_history/purchase_history_event.dart';
import 'package:quickstock/features/purchase/presentation/view_model/purchase_history/purchase_history_state.dart';

class PurchaseHistoryViewModel
    extends Bloc<PurchaseHistoryEvent, PurchaseHistoryState> {
  final GetAllPurchasesUsecase _getAllPurchasesUsecase;

  PurchaseHistoryViewModel(this._getAllPurchasesUsecase)
    : super(const PurchaseHistoryState()) {
    on<FetchInitialPurchases>(_onFetchInitialPurchases);
    on<FetchNextPage>(_onFetchNextPage);
    on<FiltersApplied>(_onFiltersApplied);
  }

  Future<void> _onFetchInitialPurchases(
    FetchInitialPurchases event,
    Emitter<PurchaseHistoryState> emit,
  ) async {
    emit(
      state.copyWith(
        status: PurchaseHistoryStatus.loading,
        purchases: [],
        currentPage: 1,
        hasReachedMax: false,
      ),
    );
    await _fetchPurchases(emit, page: 1);
  }

  Future<void> _onFiltersApplied(
    FiltersApplied event,
    Emitter<PurchaseHistoryState> emit,
  ) async {
    emit(
      state.copyWith(
        status: PurchaseHistoryStatus.loading,
        purchases: [],
        currentPage: 1,
        hasReachedMax: false,
        selectedSupplierId: event.supplierId,
        selectedPurchaseStatus: event.purchaseStatus,
        searchTerm: event.search,
        selectedStartDate: event.startDate,
        selectedEndDate: event.endDate,
        selectedSortBy: event.sortBy,
        selectedSortOrder: event.sortOrder,
      ),
    );
    await _fetchPurchases(emit, page: 1);
  }

  Future<void> _onFetchNextPage(
    FetchNextPage event,
    Emitter<PurchaseHistoryState> emit,
  ) async {
    if (state.hasReachedMax ||
        state.status == PurchaseHistoryStatus.loadingNextPage) {
      return;
    }
    emit(state.copyWith(status: PurchaseHistoryStatus.loadingNextPage));
    await _fetchPurchases(emit, page: state.currentPage + 1);
  }

  Future<void> _fetchPurchases(
    Emitter<PurchaseHistoryState> emit, {
    required int page,
  }) async {
    final params = GetAllPurchasesParams(
      page: page,
      supplierId: state.selectedSupplierId,
      purchaseStatus: state.selectedPurchaseStatus,
      search: state.searchTerm,
      startDate: state.selectedStartDate,
      endDate: state.selectedEndDate,
      sortBy: state.selectedSortBy,
      sortOrder: state.selectedSortOrder,
    );

    final result = await _getAllPurchasesUsecase(params);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: PurchaseHistoryStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (purchaseList) {
        final noMoreItems = purchaseList.purchases.isEmpty;
        emit(
          state.copyWith(
            status: PurchaseHistoryStatus.success,
            purchases: List.of(state.purchases)..addAll(purchaseList.purchases),
            currentPage: page,
            hasReachedMax: noMoreItems,
          ),
        );
      },
    );
  }
}

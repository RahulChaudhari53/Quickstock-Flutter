import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/stock/domain/entity/stock_entity.dart';
import 'package:quickstock/features/stock/domain/use_case/get_all_stock_usecase.dart';
import 'package:quickstock/features/stock/presentation/view_model/stock_view_model/stock_event.dart';
import 'package:quickstock/features/stock/presentation/view_model/stock_view_model/stock_state.dart';

class StockViewModel extends Bloc<StockEvent, StockState> {
  final GetAllStockUsecase _getAllStockUsecase;

  StockViewModel({required GetAllStockUsecase getAllStockUsecase})
    : _getAllStockUsecase = getAllStockUsecase,
      super(const StockState.initial()) {
    on<FetchStockListEvent>(_onFetchStockList);
    on<FetchNextStockPageEvent>(_onFetchNextStockPage);
    on<ApplyFiltersEvent>(_onApplyFilters);
  }

  Future<void> _onFetchStockList(
    FetchStockListEvent event,
    Emitter<StockState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final params = GetAllStockParams(
      page: 1,
      search: state.searchQuery,
      stockStatus: state.stockStatus,
    );
    final result = await _getAllStockUsecase(params);

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (data) => emit(
        state.copyWith(
          isLoading: false,
          stocks: data.items,
          pagination: data.pagination,
        ),
      ),
    );
  }

  Future<void> _onApplyFilters(
    ApplyFiltersEvent event,
    Emitter<StockState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query, stockStatus: event.status));
    add(const FetchStockListEvent());
  }

  Future<void> _onFetchNextStockPage(
    FetchNextStockPageEvent event,
    Emitter<StockState> emit,
  ) async {
    if (state.hasReachedMax || state.isPaginating) return;

    emit(state.copyWith(isPaginating: true));

    final params = GetAllStockParams(
      page: (state.pagination?.currentPage ?? 1) + 1,
      search: state.searchQuery,
      stockStatus: state.stockStatus,
    );

    final result = await _getAllStockUsecase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(isPaginating: false, errorMessage: failure.message),
      ),
      (data) {
        final updatedList = List<StockEntity>.from(state.stocks)
          ..addAll(data.items);
        emit(
          state.copyWith(
            isPaginating: false,
            stocks: updatedList,
            pagination: data.pagination,
          ),
        );
      },
    );
  }
}

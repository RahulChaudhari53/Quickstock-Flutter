import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/stock/domain/entity/stock_history_entity.dart';
import 'package:quickstock/features/stock/domain/use_case/get_stock_movement_history_usecase.dart';
import 'package:quickstock/features/stock/presentation/view_model/stock_history_view_model/stock_history_state.dart';
import 'package:quickstock/features/stock/presentation/view_model/stock_history_view_model/stock_history_event.dart';

class StockHistoryViewModel extends Bloc<StockHistoryEvent, StockHistoryState> {
  final GetStockMovementHistoryUsecase _getStockMovementHistoryUsecase;

  StockHistoryViewModel({
    required GetStockMovementHistoryUsecase getStockMovementHistoryUsecase,
  }) : _getStockMovementHistoryUsecase = getStockMovementHistoryUsecase,
       super(const StockHistoryState.initial()) {
    on<FetchStockHistoryEvent>(_onFetchStockHistory);
    on<FetchNextStockHistoryPageEvent>(_onFetchNextStockHistoryPage);
  }

  Future<void> _onFetchStockHistory(
    FetchStockHistoryEvent event,
    Emitter<StockHistoryState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        clearError: true,
        productId: event.productId,
      ),
    );

    final params = GetStockHistoryParams(productId: event.productId, page: 1);
    final result = await _getStockMovementHistoryUsecase(params);

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (data) => emit(
        state.copyWith(
          isLoading: false,
          history: data.history,
          pagination: data.pagination,
        ),
      ),
    );
  }

  Future<void> _onFetchNextStockHistoryPage(
    FetchNextStockHistoryPageEvent event,
    Emitter<StockHistoryState> emit,
  ) async {
    if (state.hasReachedMax || state.isPaginating || state.productId == null) {
      return;
    }

    emit(state.copyWith(isPaginating: true));

    final params = GetStockHistoryParams(
      productId: state.productId!,
      page: (state.pagination?.currentPage ?? 1) + 1,
    );
    final result = await _getStockMovementHistoryUsecase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(isPaginating: false, errorMessage: failure.message),
      ),
      (data) {
        final updatedList = List<StockHistoryEntity>.from(state.history)
          ..addAll(data.history);
        emit(
          state.copyWith(
            isPaginating: false,
            history: updatedList,
            pagination: data.pagination,
          ),
        );
      },
    );
  }
}

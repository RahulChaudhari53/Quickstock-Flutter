import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/sales/domain/entity/sale_entity.dart';
import 'package:quickstock/features/sales/domain/use_case/cancel_sale_usecase.dart.dart';
import 'package:quickstock/features/sales/domain/use_case/get_all_sales_usecase.dart';
import 'package:quickstock/features/sales/presentation/view_model/sale_history/sale_history_event.dart';
import 'package:quickstock/features/sales/presentation/view_model/sale_history/sales_history_state.dart';

class SalesHistoryViewModel extends Bloc<SalesHistoryEvent, SalesHistoryState> {
  final GetAllSalesUsecase _getAllSalesUsecase;
  final CancelSaleUsecase _cancelSaleUsecase;

  SalesHistoryViewModel({
    required GetAllSalesUsecase getAllSalesUsecase,
    required CancelSaleUsecase cancelSaleUsecase,
  }) : _getAllSalesUsecase = getAllSalesUsecase,
       _cancelSaleUsecase = cancelSaleUsecase,
       super(const SalesHistoryState.initial()) {
    on<FetchSalesEvent>(_onFetchSales);
    on<ApplySalesFilterEvent>(_onApplySalesFilter);
    on<FetchNextSalePageEvent>(_onFetchNextSalePage);
    on<CancelSaleEvent>(_onCancelSale);
  }

  Future<void> _onFetchSales(
    FetchSalesEvent event,
    Emitter<SalesHistoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final params = GetAllSalesParams(
      page: 1,
      search: state.searchQuery,
      paymentMethod: state.paymentMethod,
      sortBy: state.sortBy,
      sortOrder: state.sortOrder,
    );
    final result = await _getAllSalesUsecase(params);

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (data) => emit(
        state.copyWith(
          isLoading: false,
          sales: data.sales,
          pagination: data.pagination,
        ),
      ),
    );
  }

  Future<void> _onApplySalesFilter(
    ApplySalesFilterEvent event,
    Emitter<SalesHistoryState> emit,
  ) async {
    emit(
      state.copyWith(
        searchQuery: event.search,
        paymentMethod: event.paymentMethod,
        sortBy: event.sortBy,
        sortOrder: event.sortOrder,
      ),
    );
    add(const FetchSalesEvent());
  }

  Future<void> _onFetchNextSalePage(
    FetchNextSalePageEvent event,
    Emitter<SalesHistoryState> emit,
  ) async {
    if (state.hasReachedMax || state.isPaginating) return;

    emit(state.copyWith(isPaginating: true));

    final params = GetAllSalesParams(
      page: (state.pagination?.currentPage ?? 1) + 1,
      search: state.searchQuery,
      paymentMethod: state.paymentMethod,
      sortBy: state.sortBy,
      sortOrder: state.sortOrder,
    );
    final result = await _getAllSalesUsecase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(isPaginating: false, errorMessage: failure.message),
      ),
      (data) {
        final updatedList = List<SaleEntity>.from(state.sales)
          ..addAll(data.sales);
        emit(
          state.copyWith(
            isPaginating: false,
            sales: updatedList,
            pagination: data.pagination,
          ),
        );
      },
    );
  }

  Future<void> _onCancelSale(
    CancelSaleEvent event,
    Emitter<SalesHistoryState> emit,
  ) async {
    // Add the saleId to the processing set to show a loading indicator on the card
    final processingIds = Set<String>.from(state.processingSaleIds)
      ..add(event.saleId);
    emit(state.copyWith(processingSaleIds: processingIds));

    final result = await _cancelSaleUsecase(
      CancelSaleParams(saleId: event.saleId),
    );

    result.fold(
      (failure) {
        // On failure, remove from processing and show an error
        final updatedProcessingIds = Set<String>.from(state.processingSaleIds)
          ..remove(event.saleId);
        emit(
          state.copyWith(
            processingSaleIds: updatedProcessingIds,
            errorMessage: failure.message,
          ),
        );
      },
      (success) {
        add(const FetchSalesEvent());
      },
    );
  }
}

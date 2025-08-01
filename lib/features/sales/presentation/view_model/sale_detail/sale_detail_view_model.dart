import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/sales/domain/use_case/get_sale_by_id.dart';
import 'package:quickstock/features/sales/presentation/view_model/sale_detail/sale_detail_event.dart';
import 'package:quickstock/features/sales/presentation/view_model/sale_detail/sale_detail_state.dart';

class SaleDetailViewModel extends Bloc<SaleDetailEvent, SaleDetailState> {
  final GetSaleByIdUsecase _getSaleByIdUsecase;

  SaleDetailViewModel({
    required GetSaleByIdUsecase getSaleByIdUsecase,
  })  : _getSaleByIdUsecase = getSaleByIdUsecase,
        super(const SaleDetailState.initial()) {
    on<FetchSaleDetailEvent>(_onFetchSaleDetail);
  }

  Future<void> _onFetchSaleDetail(
    FetchSaleDetailEvent event,
    Emitter<SaleDetailState> emit,
  ) async {
    emit(state.copyWith(status: SaleDetailStatus.loading));

    final result = await _getSaleByIdUsecase(GetSaleByIdParams(saleId: event.saleId));

    result.fold(
      (failure) => emit(state.copyWith(
        status: SaleDetailStatus.failure,
        errorMessage: failure.message,
      )),
      (saleEntity) => emit(state.copyWith(
        status: SaleDetailStatus.success,
        sale: saleEntity,
      )),
    );
  }
}
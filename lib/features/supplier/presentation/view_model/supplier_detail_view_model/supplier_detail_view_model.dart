import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/supplier/domain/use_case/get_supplier_by_id_usecase.dart';
import 'package:quickstock/features/supplier/presentation/view_model/supplier_detail_view_model/supplier_detail_event.dart';
import 'package:quickstock/features/supplier/presentation/view_model/supplier_detail_view_model/supplier_detail_state.dart';

class SupplierDetailViewModel
    extends Bloc<SupplierDetailEvent, SupplierDetailState> {
  final GetSupplierByIdUsecase _getSupplierByIdUsecase;

  SupplierDetailViewModel({
    required GetSupplierByIdUsecase getSupplierByIdUsecase,
  }) : _getSupplierByIdUsecase = getSupplierByIdUsecase,
       super(const SupplierDetailState.initial()) {
    on<FetchSupplierDetailsEvent>(_onFetchSupplierDetails);
  }

  Future<void> _onFetchSupplierDetails(
    FetchSupplierDetailsEvent event,
    Emitter<SupplierDetailState> emit,
  ) async {
    // emitting isLoading true incase of pull to refresh in future
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));

    final result = await _getSupplierByIdUsecase(event.supplierId);

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (supplier) => emit(state.copyWith(isLoading: false, supplier: supplier)),
    );
  }
}

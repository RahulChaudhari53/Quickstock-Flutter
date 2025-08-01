import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/supplier/domain/entity/supplier_entity.dart';
import 'package:quickstock/features/supplier/domain/use_case/activate_supplier_usecase.dart';
import 'package:quickstock/features/supplier/domain/use_case/create_supplier_usecase.dart';
import 'package:quickstock/features/supplier/domain/use_case/deactivate_supplier_usecase.dart';
import 'package:quickstock/features/supplier/domain/use_case/get_suppliers_usecase.dart';
import 'package:quickstock/features/supplier/domain/use_case/update_supplier_usecase.dart';
import 'package:quickstock/features/supplier/presentation/view_model/supplier_view_model/supplier_event.dart';
import 'package:quickstock/features/supplier/presentation/view_model/supplier_view_model/supplier_state.dart';

class SupplierViewModel extends Bloc<SupplierEvent, SupplierState> {
  final GetSuppliersUsecase _getSuppliersUsecase;
  final CreateSupplierUsecase _createSupplierUsecase;
  final UpdateSupplierUsecase _updateSupplierUsecase;
  final DeactivateSupplierUsecase _deactivateSupplierUsecase;
  final ActivateSupplierUsecase _activateSupplierUsecase;

  SupplierViewModel({
    required GetSuppliersUsecase getSuppliersUsecase,
    required CreateSupplierUsecase createSupplierUsecase,
    required UpdateSupplierUsecase updateSupplierUsecase,
    required DeactivateSupplierUsecase deactivateSupplierUsecase,
    required ActivateSupplierUsecase activateSupplierUsecase,
  }) : _getSuppliersUsecase = getSuppliersUsecase,
       _createSupplierUsecase = createSupplierUsecase,
       _updateSupplierUsecase = updateSupplierUsecase,
       _deactivateSupplierUsecase = deactivateSupplierUsecase,
       _activateSupplierUsecase = activateSupplierUsecase,
       super(const SupplierState.initial()) {
    on<FetchSuppliersEvent>(_onFetchSuppliers);
    on<SupplierFiltersEvent>(_onSupplierFiltersChanged);
    on<FetchNextPageEvent>(_onFetchNextPage);
    on<CreateSupplierEvent>(_onCreateSupplier);
    on<UpdateSupplierEvent>(_onUpdateSupplier);
    on<DeactivateSupplierEvent>(_onDeactivateSupplier);
    on<ActivateSupplierEvent>(_onActivateSupplier);
    on<SupplierActionErrorHandled>(_onActionErrorHandled);
  }

  Future<void> _onFetchSuppliers(
    FetchSuppliersEvent event,
    Emitter<SupplierState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        clearErrorMessage: true,
      ),
    );

    final params = GetSuppliersParams(
      page: 1,
      limit: 10,
      search: state.searchTerm,
      sortBy: state.sortBy,
      sortOrder: state.sortOrder,
      isActive: state.isActive,
    );

    final result = await _getSuppliersUsecase(params);

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (paginatedData) => emit(
        state.copyWith(
          isLoading: false,
          suppliers: paginatedData.suppliers,
          paginationInfo: paginatedData.paginationInfo,
        ),
      ),
    );
  }

  Future<void> _onSupplierFiltersChanged(
    SupplierFiltersEvent event,
    Emitter<SupplierState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        searchTerm: event.searchTerm,
        sortBy: event.sortBy,
        sortOrder: event.sortOrder,
        isActive: event.isActive,
        clearIsActiveFilter: event.isActive == null,
        processingSupplierIds: {},
        errorMessage: null,
        clearErrorMessage: true,
      ),
    );

    add(FetchSuppliersEvent());
  }

  Future<void> _onFetchNextPage(
    FetchNextPageEvent event,
    Emitter<SupplierState> emit,
  ) async {
    if (state.isPaginating || state.paginationInfo?.hasNextPage == false) {
      return;
    }

    emit(state.copyWith(isPaginating: true));

    final params = GetSuppliersParams(
      page: state.paginationInfo!.currentPage + 1,
      limit: 10,
      search: state.searchTerm,
      sortBy: state.sortBy,
      sortOrder: state.sortOrder,
      isActive: state.isActive,
    );

    final result = await _getSuppliersUsecase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(isPaginating: false, actionError: failure.message),
      ),
      (paginatedData) {
        final updatedList = List<SupplierEntity>.from(state.suppliers)
          ..addAll(paginatedData.suppliers);
        emit(
          state.copyWith(
            isPaginating: false,
            suppliers: updatedList,
            paginationInfo: paginatedData.paginationInfo,
          ),
        );
      },
    );
  }

  Future<void> _onCreateSupplier(
    CreateSupplierEvent event,
    Emitter<SupplierState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        actionError: null,
        clearActionError: true,
      ),
    );

    final params = CreateSupplierParams(
      name: event.name,
      email: event.email,
      phone: event.phone,
      notes: event.notes,
    );
    final result = await _createSupplierUsecase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(isSubmitting: false, actionError: failure.message),
      ),
      (success) {
        emit(state.copyWith(isSubmitting: false));
        add(FetchSuppliersEvent());
      },
    );
  }

  Future<void> _onUpdateSupplier(
    UpdateSupplierEvent event,
    Emitter<SupplierState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        actionError: null,
        clearActionError: true,
      ),
    );
    final params = UpdateSupplierParams(
      id: event.id,
      name: event.name,
      email: event.email,
      phone: event.phone,
      notes: event.notes,
    );
    final result = await _updateSupplierUsecase(params);
    result.fold(
      (failure) => emit(
        state.copyWith(isSubmitting: false, actionError: failure.message),
      ),
      (success) {
        emit(state.copyWith(isSubmitting: false));
        add(FetchSuppliersEvent());
      },
    );
  }

  Future<void> _onDeactivateSupplier(
    DeactivateSupplierEvent event,
    Emitter<SupplierState> emit,
  ) async {
    await _handleStatusChange(
      event.supplierId,
      _deactivateSupplierUsecase.call,
      emit,
    );
  }

  Future<void> _onActivateSupplier(
    ActivateSupplierEvent event,
    Emitter<SupplierState> emit,
  ) async {
    await _handleStatusChange(
      event.supplierId,
      _activateSupplierUsecase.call,
      emit,
    );
  }

  // --- Helper for activate/deactivate ---
  Future<void> _handleStatusChange(
    String supplierId,
    Future<dynamic> Function(String) usecase,
    Emitter<SupplierState> emit,
  ) async {
    final processingIds = Set<String>.from(state.processingSupplierIds)
      ..add(supplierId);
    emit(state.copyWith(processingSupplierIds: processingIds));

    final result = await usecase(supplierId);

    result.fold(
      (failure) {
        final updatedProcessingIds = Set<String>.from(
          state.processingSupplierIds,
        )..remove(supplierId);
        emit(
          state.copyWith(
            processingSupplierIds: updatedProcessingIds,
            actionError: failure.message,
          ),
        );
      },
      (success) {
        add(FetchSuppliersEvent());
      },
    );
  }

  void _onActionErrorHandled(
    SupplierActionErrorHandled event,
    Emitter<SupplierState> emit,
  ) {
    emit(state.copyWith(clearActionError: true));
  }
}

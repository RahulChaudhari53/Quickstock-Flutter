import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/purchase/domain/use_case/cancel_purchase_usecase.dart';
import 'package:quickstock/features/purchase/domain/use_case/get_purchase_by_id_usecase.dart';
import 'package:quickstock/features/purchase/domain/use_case/receive_purchase_usecase.dart';
import 'package:quickstock/features/purchase/presentation/view_model/purchase_detail/purchase_detail_event.dart';
import 'package:quickstock/features/purchase/presentation/view_model/purchase_detail/purchase_detail_state.dart';

class PurchaseDetailViewModel
    extends Bloc<PurchaseDetailEvent, PurchaseDetailState> {
  final GetPurchaseByIdUsecase _getPurchaseByIdUsecase;
  final CancelPurchaseUsecase _cancelPurchaseUsecase;
  final ReceivePurchaseUsecase _receivePurchaseUsecase;

  PurchaseDetailViewModel({
    required GetPurchaseByIdUsecase getPurchaseByIdUsecase,
    required CancelPurchaseUsecase cancelPurchaseUsecase,
    required ReceivePurchaseUsecase receivePurchaseUsecase,
  })  : _getPurchaseByIdUsecase = getPurchaseByIdUsecase,
        _cancelPurchaseUsecase = cancelPurchaseUsecase,
        _receivePurchaseUsecase = receivePurchaseUsecase,
        super(const PurchaseDetailState()) {
    // Register the event handlers
    on<FetchPurchaseDetails>(_onFetchPurchaseDetails);
    on<CancelPurchaseRequested>(_onCancelPurchaseRequested);
    on<ReceivePurchaseRequested>(_onReceivePurchaseRequested);
  }

  /// Handles fetching the initial purchase details.
  Future<void> _onFetchPurchaseDetails(
    FetchPurchaseDetails event,
    Emitter<PurchaseDetailState> emit,
  ) async {
    // Emit page loading status
    emit(state.copyWith(pageStatus: PageStatus.loading));

    final result =
        await _getPurchaseByIdUsecase(GetPurchaseByIdParams(purchaseId: event.purchaseId));

    result.fold(
      (failure) => emit(state.copyWith(
        pageStatus: PageStatus.failure,
        pageErrorMessage: failure.message,
      )),
      (purchase) => emit(state.copyWith(
        pageStatus: PageStatus.success,
        purchase: purchase,
      )),
    );
  }

  /// Handles the request to cancel a purchase.
  Future<void> _onCancelPurchaseRequested(
    CancelPurchaseRequested event,
    Emitter<PurchaseDetailState> emit,
  ) async {
    // Guard against multiple clicks
    if (state.actionStatus == ActionStatus.loading) return;
    
    // Ensure we have a purchase loaded before attempting an action
    final purchaseId = state.purchase?.id;
    if (purchaseId == null) {
      emit(state.copyWith(actionStatus: ActionStatus.failure, actionErrorMessage: "Error: Purchase not loaded."));
      return;
    }

    // Emit action loading status
    emit(state.copyWith(actionStatus: ActionStatus.loading));

    final result = await _cancelPurchaseUsecase(CancelPurchaseParams(purchaseId: purchaseId));

    result.fold(
      (failure) => emit(state.copyWith(
        actionStatus: ActionStatus.failure,
        actionErrorMessage: failure.message,
      )),
      (_) {
        // On success, show a success message and then immediately trigger a
        // refresh of the data to get the updated purchase status.
        emit(state.copyWith(
          actionStatus: ActionStatus.success,
          successMessage: "Purchase successfully cancelled.",
        ));
        add(FetchPurchaseDetails(purchaseId));
      },
    );
  }

  /// Handles the request to receive a purchase.
  Future<void> _onReceivePurchaseRequested(
    ReceivePurchaseRequested event,
    Emitter<PurchaseDetailState> emit,
  ) async {
    if (state.actionStatus == ActionStatus.loading) return;
    
    final purchaseId = state.purchase?.id;
    if (purchaseId == null) {
       emit(state.copyWith(actionStatus: ActionStatus.failure, actionErrorMessage: "Error: Purchase not loaded."));
      return;
    }
    
    emit(state.copyWith(actionStatus: ActionStatus.loading));

    final result = await _receivePurchaseUsecase(ReceivePurchaseParams(purchaseId: purchaseId));

    result.fold(
      (failure) => emit(state.copyWith(
        actionStatus: ActionStatus.failure,
        actionErrorMessage: failure.message,
      )),
      (updatedPurchase) {
        // The API returns the updated purchase, so we can directly update the state
        // without needing to re-fetch. This is more efficient.
        emit(state.copyWith(
          actionStatus: ActionStatus.success,
          successMessage: "Purchase successfully received.",
          purchase: updatedPurchase, // Update the purchase object in the state
          pageStatus: PageStatus.success, // Ensure page status is success
        ));
      },
    );
  }
}
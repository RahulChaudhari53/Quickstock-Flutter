import 'package:equatable/equatable.dart';

abstract class PurchaseDetailEvent extends Equatable {
  const PurchaseDetailEvent();

  @override
  List<Object> get props => [];
}

/// Event triggered to fetch the full details of a specific purchase.
/// This will be dispatched when the view is first loaded, carrying the ID.
class FetchPurchaseDetails extends PurchaseDetailEvent {
  final String purchaseId;

  const FetchPurchaseDetails(this.purchaseId);

  @override
  List<Object> get props => [purchaseId];
}

/// Event triggered when the user presses the 'Cancel Purchase' button.
class CancelPurchaseRequested extends PurchaseDetailEvent {
  const CancelPurchaseRequested();
}

/// Event triggered when the user presses the 'Receive Items' button.
class ReceivePurchaseRequested extends PurchaseDetailEvent {
  const ReceivePurchaseRequested();
}
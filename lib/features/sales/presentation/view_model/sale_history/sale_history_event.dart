import 'package:equatable/equatable.dart';

abstract class SalesHistoryEvent extends Equatable {
  const SalesHistoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchSalesEvent extends SalesHistoryEvent {
  const FetchSalesEvent();
}

class FetchNextSalePageEvent extends SalesHistoryEvent {
  const FetchNextSalePageEvent();
}

class ApplySalesFilterEvent extends SalesHistoryEvent {
  final String? search;
  final String? paymentMethod;
  final String? sortBy;
  final String? sortOrder;

  const ApplySalesFilterEvent({
    this.search,
    this.paymentMethod,
    this.sortBy,
    this.sortOrder,
  });

  @override
  List<Object?> get props => [search, paymentMethod, sortBy, sortOrder];
}

class CancelSaleEvent extends SalesHistoryEvent {
  final String saleId;

  const CancelSaleEvent({required this.saleId});

  @override
  List<Object?> get props => [saleId];
}

import 'package:equatable/equatable.dart';

abstract class SaleDetailEvent extends Equatable {
  const SaleDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchSaleDetailEvent extends SaleDetailEvent {
  final String saleId;

  const FetchSaleDetailEvent({required this.saleId});

  @override
  List<Object> get props => [saleId];
}

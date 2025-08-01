import 'package:equatable/equatable.dart';

abstract class StockEvent extends Equatable {
  const StockEvent();
  @override
  List<Object?> get props => [];
}

class FetchStockListEvent extends StockEvent {
  const FetchStockListEvent();
}

class FetchNextStockPageEvent extends StockEvent {
  const FetchNextStockPageEvent();
}

class ApplyFiltersEvent extends StockEvent {
  final String query;
  final String status;

  const ApplyFiltersEvent({required this.query, required this.status});

  @override
  List<Object?> get props => [query, status];
}

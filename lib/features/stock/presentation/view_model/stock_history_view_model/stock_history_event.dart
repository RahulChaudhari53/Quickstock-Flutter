import 'package:equatable/equatable.dart';

abstract class StockHistoryEvent extends Equatable {
  const StockHistoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchStockHistoryEvent extends StockHistoryEvent {
  final String productId;

  const FetchStockHistoryEvent({required this.productId});

  @override
  List<Object?> get props => [productId];
}

// class FetchNextStockHistoryPageEvent extends StockHistoryEvent {
//   final String productId;

//   const FetchNextStockHistoryPageEvent({required this.productId});

//   @override
//   List<Object?> get props => [productId];
// }

class FetchNextStockHistoryPageEvent extends StockHistoryEvent {
  const FetchNextStockHistoryPageEvent();
}

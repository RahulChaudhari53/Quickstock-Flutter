import 'package:equatable/equatable.dart';
import 'package:quickstock/features/stock/domain/entity/stock_history_entity.dart';
import 'package:quickstock/features/stock/domain/entity/stock_pagination_entity.dart';

class StockHistoryViewEntity extends Equatable {
  final List<StockHistoryEntity> history;
  final StockPaginationEntity pagination;

  const StockHistoryViewEntity({
    required this.history,
    required this.pagination,
  });

  @override
  List<Object?> get props => [history, pagination];
}

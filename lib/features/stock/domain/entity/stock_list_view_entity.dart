// entire payload that view model will hold state in.
import 'package:equatable/equatable.dart';
import 'package:quickstock/features/stock/domain/entity/stock_entity.dart';
import 'package:quickstock/features/stock/domain/entity/stock_pagination_entity.dart';

class StockListViewEntity extends Equatable {
  final List<StockEntity> items;
  final StockPaginationEntity pagination;

  const StockListViewEntity({required this.items, required this.pagination});

  @override
  List<Object?> get props => [items, pagination];
}

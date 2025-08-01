import 'package:equatable/equatable.dart';
import 'package:quickstock/features/stock/domain/entity/stock_product_info_entity.dart';

// this is a single item in stock list
class StockEntity extends Equatable {
  final String id;
  final int currentStock;
  final StockProductInfoEntity product;

  const StockEntity({
    required this.id,
    required this.currentStock,
    required this.product,
  });

  @override
  List<Object?> get props => [id, currentStock, product];
}

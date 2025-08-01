import 'package:equatable/equatable.dart';

// represents nested product object that comes with each stock item
class StockProductInfoEntity extends Equatable {
  final String id;
  final String name;
  final String sku;
  final int minStockLevel;
  final String categoryName;

  const StockProductInfoEntity({
    required this.id,
    required this.name,
    required this.sku,
    required this.minStockLevel,
    required this.categoryName,
  });

  @override
  List<Object?> get props => [id, name, sku, minStockLevel, categoryName];
}

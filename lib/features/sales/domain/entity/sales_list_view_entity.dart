import 'package:equatable/equatable.dart';
import 'package:quickstock/features/sales/domain/entity/sale_entity.dart';
import 'package:quickstock/features/sales/domain/entity/sale_pagination_entity.dart';

// represents the entire payload for the sales history list view.
class SalesListViewEntity extends Equatable {
  final List<SaleEntity> sales;
  final SalePaginationEntity pagination;

  const SalesListViewEntity({required this.sales, required this.pagination});

  @override
  List<Object?> get props => [sales, pagination];
}

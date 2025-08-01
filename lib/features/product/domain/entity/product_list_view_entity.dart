import 'package:equatable/equatable.dart';
import 'package:quickstock/features/product/domain/entity/product_entity.dart';
import 'package:quickstock/features/product/domain/entity/product_pagination_entity.dart';

class ProductListViewEntity extends Equatable {
  final List<ProductEntity> items;
  final ProductPaginationEntity pagination;

  const ProductListViewEntity({required this.items, required this.pagination});

  @override
  List<Object?> get props => [items, pagination];
}

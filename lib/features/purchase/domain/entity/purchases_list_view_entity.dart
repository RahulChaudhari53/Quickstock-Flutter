import 'package:equatable/equatable.dart';
import 'package:quickstock/features/purchase/domain/entity/purchase_entity.dart';
import 'package:quickstock/features/purchase/domain/entity/purchase_pagination_entity.dart';

class PurchasesListViewEntity extends Equatable {
  final List<PurchaseEntity> purchases;
  final PurchasePaginationEntity pagination;

  const PurchasesListViewEntity({
    required this.purchases,
    required this.pagination,
  });

  @override
  List<Object?> get props => [purchases, pagination];
}

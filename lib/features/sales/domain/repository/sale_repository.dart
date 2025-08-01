// lib/features/sales/domain/repository/sale_repository.dart

import 'package:dartz/dartz.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/sales/domain/entity/sale_entity.dart';
import 'package:quickstock/features/sales/domain/entity/sales_list_view_entity.dart';

class SaleItemCreationData {
  final String productId;
  final int quantity;
  final double unitPrice;

  SaleItemCreationData({
    required this.productId,
    required this.quantity,
    required this.unitPrice,
  });
}

abstract class ISaleRepository {
  Future<Either<Failure, SalesListViewEntity>> getAllSales({
    required int page,
    int? limit,
    String? sortBy,
    String? sortOrder,
    String? paymentMethod,
    String? startDate,
    String? endDate,
    String? search,
  });

  Future<Either<Failure, SaleEntity>> getSaleById({required String saleId});

  Future<Either<Failure, SaleEntity>> createSale({
    required List<SaleItemCreationData> items,
    required String paymentMethod,
    String? notes,
  });

  Future<Either<Failure, void>> cancelSale({required String saleId});
}

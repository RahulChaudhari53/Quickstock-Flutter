import 'package:dartz/dartz.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/stock/domain/entity/stock_history_view_entity.dart';
import 'package:quickstock/features/stock/domain/entity/stock_list_view_entity.dart';

abstract class IStockRepository {
  Future<Either<Failure, StockListViewEntity>> getAllStock({
    required int page,
    int? limit,
    String? search,
    String? stockStatus,
  });

  Future<Either<Failure, StockHistoryViewEntity>> getStockMovementHistory({
    required String productId,
    required int page,
    int? limit,
  });
}

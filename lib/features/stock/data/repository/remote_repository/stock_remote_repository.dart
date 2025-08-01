import 'package:dartz/dartz.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/stock/data/data_source/stock_data_source.dart';
import 'package:quickstock/features/stock/domain/entity/stock_history_view_entity.dart';
import 'package:quickstock/features/stock/domain/entity/stock_list_view_entity.dart';
import 'package:quickstock/features/stock/domain/repository/stock_repository.dart';

class StockRemoteRepository implements IStockRepository {
  final IStockDataSource remoteDataSource;

  StockRemoteRepository({required this.remoteDataSource});

  @override
  Future<Either<Failure, StockListViewEntity>> getAllStock({
    required int page,
    int? limit,
    String? search,
    String? stockStatus,
  }) async {
    try {
      final stockListViewApiModel = await remoteDataSource.getAllStock(
        page: page,
        limit: limit,
        search: search,
        stockStatus: stockStatus,
      );
      return Right(stockListViewApiModel.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, StockHistoryViewEntity>> getStockMovementHistory({
    required String productId,
    required int page,
    int? limit,
  }) async {
    try {
      final stockHistoryViewApiModel = await remoteDataSource
          .getStockMovementHistory(
            productId: productId,
            page: page,
            limit: limit,
          );
      return Right(stockHistoryViewApiModel.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}

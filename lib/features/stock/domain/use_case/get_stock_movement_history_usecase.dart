import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/stock/domain/entity/stock_history_view_entity.dart';
import 'package:quickstock/features/stock/domain/repository/stock_repository.dart';

class GetStockHistoryParams extends Equatable {
  final String productId;
  final int page;
  final int? limit;

  const GetStockHistoryParams({
    required this.productId,
    required this.page,
    this.limit,
  });

  @override
  List<Object?> get props => [productId, page, limit];
}

class GetStockMovementHistoryUsecase
    implements
        UsecaseWithParams<StockHistoryViewEntity, GetStockHistoryParams> {
  final IStockRepository _repository;

  GetStockMovementHistoryUsecase({required IStockRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, StockHistoryViewEntity>> call(
    GetStockHistoryParams params,
  ) async {
    return await _repository.getStockMovementHistory(
      productId: params.productId,
      page: params.page,
      limit: params.limit,
    );
  }
}


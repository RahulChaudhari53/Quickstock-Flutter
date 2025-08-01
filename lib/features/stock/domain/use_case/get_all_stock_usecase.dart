import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/stock/domain/entity/stock_list_view_entity.dart';
import 'package:quickstock/features/stock/domain/repository/stock_repository.dart';

class GetAllStockParams extends Equatable {
  final int page;
  final int? limit;
  final String? search;
  final String? stockStatus;

  const GetAllStockParams({
    required this.page,
    this.limit,
    this.search,
    this.stockStatus,
  });

  @override
  List<Object?> get props => [page, limit, search, stockStatus];
}

class GetAllStockUsecase
    implements UsecaseWithParams<StockListViewEntity, GetAllStockParams> {
  final IStockRepository _repository;

  GetAllStockUsecase({required IStockRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, StockListViewEntity>> call(
    GetAllStockParams params,
  ) async {
    return await _repository.getAllStock(
      page: params.page,
      limit: params.limit,
      search: params.search,
      stockStatus: params.stockStatus,
    );
  }
}

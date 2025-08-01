import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/sales/domain/entity/sales_list_view_entity.dart';
import 'package:quickstock/features/sales/domain/repository/sale_repository.dart';

class GetAllSalesParams extends Equatable {
  final int page;
  final int? limit;
  final String? sortBy;
  final String? sortOrder;
  final String? paymentMethod;
  final String? startDate;
  final String? endDate;
  final String? search;

  const GetAllSalesParams({
    required this.page,
    this.limit,
    this.sortBy,
    this.sortOrder,
    this.paymentMethod,
    this.startDate,
    this.endDate,
    this.search,
  });

  @override
  List<Object?> get props => [
    page,
    limit,
    sortBy,
    sortOrder,
    paymentMethod,
    startDate,
    endDate,
    search,
  ];
}

class GetAllSalesUsecase
    implements UsecaseWithParams<SalesListViewEntity, GetAllSalesParams> {
  final ISaleRepository _repository;

  GetAllSalesUsecase({required ISaleRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, SalesListViewEntity>> call(
    GetAllSalesParams params,
  ) async {
    return await _repository.getAllSales(
      page: params.page,
      limit: params.limit,
      sortBy: params.sortBy,
      sortOrder: params.sortOrder,
      paymentMethod: params.paymentMethod,
      startDate: params.startDate,
      endDate: params.endDate,
      search: params.search,
    );
  }
}

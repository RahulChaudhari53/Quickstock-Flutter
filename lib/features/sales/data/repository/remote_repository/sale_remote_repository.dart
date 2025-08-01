import 'package:dartz/dartz.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/sales/data/data_source/sale_data_source.dart';
import 'package:quickstock/features/sales/data/dto/create_sale_dto.dart';
import 'package:quickstock/features/sales/domain/entity/sale_entity.dart';
import 'package:quickstock/features/sales/domain/entity/sales_list_view_entity.dart';
import 'package:quickstock/features/sales/domain/repository/sale_repository.dart';

class SaleRemoteRepository implements ISaleRepository {
  final ISaleDataSource remoteDataSource;

  SaleRemoteRepository({required this.remoteDataSource});

  @override
  Future<Either<Failure, SalesListViewEntity>> getAllSales({
    required int page,
    int? limit,
    String? sortBy,
    String? sortOrder,
    String? paymentMethod,
    String? startDate,
    String? endDate,
    String? search,
  }) async {
    try {
      final salesListViewApiModel = await remoteDataSource.getAllSales(
        page: page,
        limit: limit,
        sortBy: sortBy,
        sortOrder: sortOrder,
        paymentMethod: paymentMethod,
        startDate: startDate,
        endDate: endDate,
        search: search,
      );
      return Right(salesListViewApiModel.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SaleEntity>> getSaleById({
    required String saleId,
  }) async {
    try {
      final saleApiModel = await remoteDataSource.getSaleById(saleId: saleId);
      return Right(saleApiModel.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SaleEntity>> createSale({
    required String paymentMethod,
    required List<SaleItemCreationData> items,
    String? notes,
  }) async {
    try {
      final createSaleDto = CreateSaleDto(
        paymentMethod: paymentMethod,
        notes: notes,
        items:
            items
                .map(
                  (item) => CreateSaleItemDto(
                    product: item.productId,
                    quantity: item.quantity,
                    unitPrice: item.unitPrice,
                  ),
                )
                .toList(),
      );

      final saleApiModel = await remoteDataSource.createSale(
        createSaleDto: createSaleDto,
      );
      return Right(saleApiModel.toEntity());
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelSale({required String saleId}) async {
    try {
      await remoteDataSource.cancelSale(saleId: saleId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}

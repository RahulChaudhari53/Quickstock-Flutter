import 'package:dartz/dartz.dart';
import 'package:quickstock/app/usecase/usecase.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/sales/domain/entity/sale_entity.dart';
import 'package:quickstock/features/sales/domain/repository/sale_repository.dart';
import 'package:quickstock/features/sales/domain/use_case/create_sale_params.dart';

class CreateSaleUsecase
    implements UsecaseWithParams<SaleEntity, CreateSaleParams> {
  final ISaleRepository _repository;

  CreateSaleUsecase({required ISaleRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, SaleEntity>> call(CreateSaleParams params) async {
    final itemsData =
        params.items
            .map(
              (item) => SaleItemCreationData(
                productId: item.productId,
                quantity: item.quantity,
                unitPrice: item.unitPrice,
              ),
            )
            .toList();

    return await _repository.createSale(
      paymentMethod: params.paymentMethod,
      notes: params.notes,
      items: itemsData,
    );
  }
}

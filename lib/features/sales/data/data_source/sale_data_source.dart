import 'package:quickstock/features/sales/data/dto/create_sale_dto.dart';
import 'package:quickstock/features/sales/data/model/sale_api_model.dart';

abstract class ISaleDataSource {
  Future<SalesListViewApiModel> getAllSales({
    required int page,
    int? limit,
    String? sortBy,
    String? sortOrder,
    String? paymentMethod,
    String? startDate,
    String? endDate,
    String? search,
  });

  Future<SaleApiModel> getSaleById({required String saleId});

  Future<SaleApiModel> createSale({required CreateSaleDto createSaleDto});

  Future<void> cancelSale({required String saleId});
}

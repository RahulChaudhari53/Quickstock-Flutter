import 'package:quickstock/features/supplier/data/dto/create_supplier_dto.dart';
import 'package:quickstock/features/supplier/data/dto/get_all_suppliers_dto.dart';
import 'package:quickstock/features/supplier/data/dto/update_supplier_dto.dart';
import 'package:quickstock/features/supplier/data/model/supplier_api_model.dart';

abstract interface class ISupplierDataSource {
  Future<GetAllSuppliersDto> getSuppliers({
    required int page,
    required int limit,
    String? search,
    String? sortBy,
    String? sortOrder,
    bool? isActive,
  });

  Future<SupplierApiModel> getSupplierById(String id);

  Future<SupplierApiModel> createSupplier(CreateSupplierDto createSupplierDto);

  Future<SupplierApiModel> updateSupplier(
    String id,
    UpdateSupplierDto updateSupplierDto,
  );
  Future<SupplierApiModel> deactivateSupplier(String id);

  Future<SupplierApiModel> activateSupplier(String id);
}

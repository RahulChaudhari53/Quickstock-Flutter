import 'package:equatable/equatable.dart';

class ProductSupplierEntity extends Equatable {
  final String id;
  final String name;
  final String? phone;
  final String? email;

  const ProductSupplierEntity({
    required this.id,
    required this.name,
    this.phone,
    this.email,
  });

  @override
  List<Object?> get props => [id, name, phone, email];
}

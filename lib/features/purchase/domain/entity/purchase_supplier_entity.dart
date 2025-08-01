import 'package:equatable/equatable.dart';

class PurchaseSupplierEntity extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String? email;

  const PurchaseSupplierEntity({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
  });

  @override
  List<Object?> get props => [id, name, phone, email];
}

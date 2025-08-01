import 'package:equatable/equatable.dart';

class ProductCategoryEntity extends Equatable {
  final String id;
  final String name;

  const ProductCategoryEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

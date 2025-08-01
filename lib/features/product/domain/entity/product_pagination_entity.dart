import 'package:equatable/equatable.dart';

class ProductPaginationEntity extends Equatable {
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;

  const ProductPaginationEntity({
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
  });

  @override
  List<Object?> get props => [currentPage, totalPages, hasNextPage];
}

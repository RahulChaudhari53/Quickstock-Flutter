import 'package:equatable/equatable.dart';

class SupplierPaginationInfoEntity extends Equatable {
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  const SupplierPaginationInfoEntity({
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  @override
  List<Object?> get props => [
    currentPage,
    totalPages,
    hasNextPage,
    hasPrevPage,
  ];
}

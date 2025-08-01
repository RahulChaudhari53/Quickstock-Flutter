import 'package:equatable/equatable.dart';

class StockPaginationEntity extends Equatable {
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  const StockPaginationEntity({
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

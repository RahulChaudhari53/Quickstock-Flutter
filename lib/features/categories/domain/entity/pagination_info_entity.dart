import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class PaginationInfoEntity extends Equatable {
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  const PaginationInfoEntity({
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

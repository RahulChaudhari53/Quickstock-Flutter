import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:quickstock/features/supplier/domain/entity/supplier_entity.dart';
import 'package:quickstock/features/supplier/domain/entity/supplier_pagination_info_entity.dart';

@immutable
class SupplierState extends Equatable {
  final List<SupplierEntity> suppliers;
  final SupplierPaginationInfoEntity? paginationInfo;

  final String? searchTerm;
  final String sortBy;
  final String sortOrder;
  final bool? isActive;

  final bool isLoading;
  final bool isPaginating;
  final Set<String> processingSupplierIds;
  final bool isSubmitting;

  final String? errorMessage;
  final String? actionError;

  const SupplierState({
    required this.suppliers,
    this.paginationInfo,
    this.searchTerm,
    required this.sortBy,
    required this.sortOrder,
    this.isActive,
    this.isLoading = false,
    this.isPaginating = false,
    this.processingSupplierIds = const {},
    this.isSubmitting = false,
    this.errorMessage,
    this.actionError,
  });

  const SupplierState.initial()
    : suppliers = const [],
      paginationInfo = null,
      searchTerm = null,
      sortBy = 'createdAt',
      sortOrder = 'desc',
      isActive = true,
      isLoading = true,
      isPaginating = false,
      processingSupplierIds = const {},
      isSubmitting = false,
      errorMessage = null,
      actionError = null;

  SupplierState copyWith({
    List<SupplierEntity>? suppliers,
    SupplierPaginationInfoEntity? paginationInfo,
    String? searchTerm,
    String? sortBy,
    String? sortOrder,
    bool? isActive,
    bool clearSearchTerm = false,
    bool clearIsActiveFilter = false,
    bool? isLoading,
    bool? isPaginating,
    Set<String>? processingSupplierIds,
    bool? isSubmitting,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? actionError,
    bool clearActionError = false,
  }) {
    return SupplierState(
      suppliers: suppliers ?? this.suppliers,
      paginationInfo: paginationInfo ?? this.paginationInfo,
      searchTerm: clearSearchTerm ? null : searchTerm ?? this.searchTerm,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: clearIsActiveFilter ? null : isActive ?? this.isActive,
      isLoading: isLoading ?? this.isLoading,
      isPaginating: isPaginating ?? this.isPaginating,
      processingSupplierIds:
          processingSupplierIds ?? this.processingSupplierIds,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      actionError: clearActionError ? null : actionError ?? this.actionError,
    );
  }

  @override
  List<Object?> get props => [
    suppliers,
    paginationInfo,
    searchTerm,
    sortBy,
    sortOrder,
    isActive,
    isLoading,
    isPaginating,
    processingSupplierIds,
    isSubmitting,
    errorMessage,
    actionError,
  ];
}

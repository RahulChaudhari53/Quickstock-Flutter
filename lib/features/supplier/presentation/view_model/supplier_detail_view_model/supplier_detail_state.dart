import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:quickstock/features/supplier/domain/entity/supplier_entity.dart';

@immutable
class SupplierDetailState extends Equatable {
  final SupplierEntity? supplier; // nullable if nto loaded yet

  final bool isLoading;
  final String? errorMessage;

  const SupplierDetailState({
    this.supplier,
    this.isLoading = false,
    this.errorMessage,
  });

  const SupplierDetailState.initial()
    : supplier = null,
      isLoading = true,
      errorMessage = null;

  SupplierDetailState copyWith({
    SupplierEntity? supplier,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return SupplierDetailState(
      supplier: supplier ?? this.supplier,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [supplier, isLoading, errorMessage];
}

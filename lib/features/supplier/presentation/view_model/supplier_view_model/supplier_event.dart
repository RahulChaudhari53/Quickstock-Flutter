import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class SupplierEvent extends Equatable {
  const SupplierEvent();

  @override
  List<Object?> get props => [];
}

class FetchSuppliersEvent extends SupplierEvent {}

class SupplierFiltersEvent extends SupplierEvent {
  final String? searchTerm;
  final String? sortBy;
  final String? sortOrder;
  final bool? isActive;

  const SupplierFiltersEvent({
    this.searchTerm,
    this.sortBy,
    this.sortOrder,
    this.isActive,
  });

  @override
  List<Object?> get props => [searchTerm, sortBy, sortOrder, isActive];
}

class FetchNextPageEvent extends SupplierEvent {}

class CreateSupplierEvent extends SupplierEvent {
  final String name;
  final String email;
  final String phone;
  final String? notes;

  const CreateSupplierEvent({
    required this.name,
    required this.email,
    required this.phone,
    this.notes,
  });

  @override
  List<Object?> get props => [name, email, phone, notes];
}

class UpdateSupplierEvent extends SupplierEvent {
  final String id;
  final String? name;
  final String? email;
  final String? phone;
  final String? notes;

  const UpdateSupplierEvent({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.notes,
  });

  @override
  List<Object?> get props => [id, name, email, phone, notes];
}

class DeactivateSupplierEvent extends SupplierEvent {
  final String supplierId;

  const DeactivateSupplierEvent({required this.supplierId});

  @override
  List<Object?> get props => [supplierId];
}

class ActivateSupplierEvent extends SupplierEvent {
  final String supplierId;

  const ActivateSupplierEvent({required this.supplierId});

  @override
  List<Object?> get props => [supplierId];
}

class SupplierActionErrorHandled extends SupplierEvent {}

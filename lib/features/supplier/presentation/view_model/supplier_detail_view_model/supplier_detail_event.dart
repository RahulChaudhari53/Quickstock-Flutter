import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class SupplierDetailEvent extends Equatable {
  const SupplierDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchSupplierDetailsEvent extends SupplierDetailEvent {
  final String supplierId;

  const FetchSupplierDetailsEvent({required this.supplierId});

  @override
  List<Object> get props => [supplierId];
}

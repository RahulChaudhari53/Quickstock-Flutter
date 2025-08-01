import 'package:equatable/equatable.dart';
import 'package:quickstock/features/sales/domain/entity/sale_entity.dart';

enum SaleDetailStatus { initial, loading, success, failure }

class SaleDetailState extends Equatable {
  final SaleDetailStatus status;
  final SaleEntity? sale;
  final String? errorMessage;

  const SaleDetailState({
    this.status = SaleDetailStatus.initial,
    this.sale,
    this.errorMessage,
  });

  const SaleDetailState.initial()
    : status = SaleDetailStatus.initial,
      sale = null,
      errorMessage = null;

  SaleDetailState copyWith({
    SaleDetailStatus? status,
    SaleEntity? sale,
    String? errorMessage,
  }) {
    return SaleDetailState(
      status: status ?? this.status,
      sale: sale ?? this.sale,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, sale, errorMessage];
}

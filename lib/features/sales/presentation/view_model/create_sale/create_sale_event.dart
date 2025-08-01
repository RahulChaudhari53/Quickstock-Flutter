import 'package:equatable/equatable.dart';
import 'package:quickstock/features/product/domain/entity/product_entity.dart';

abstract class CreateSaleEvent extends Equatable {
  const CreateSaleEvent();

  @override
  List<Object?> get props => [];
}

// event to load the initial list of all available products.
class LoadProductsEvent extends CreateSaleEvent {
  const LoadProductsEvent();
}

// triggered when the user types in the product search bar.
class SearchProductsEvent extends CreateSaleEvent {
  final String query;

  const SearchProductsEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

// add a product to the "Current Sale" cart.
class AddItemToCartEvent extends CreateSaleEvent {
  final ProductEntity product;

  const AddItemToCartEvent({required this.product});

  @override
  List<Object?> get props => [product];
}

// change the quantity of an item already in the cart.
class UpdateItemQuantityEvent extends CreateSaleEvent {
  final String productId;
  final int newQuantity;

  const UpdateItemQuantityEvent({
    required this.productId,
    required this.newQuantity,
  });

  @override
  List<Object?> get props => [productId, newQuantity];
}

// remove an item completely from the cart.
class RemoveItemFromCartEvent extends CreateSaleEvent {
  final String productId;

  const RemoveItemFromCartEvent({required this.productId});

  @override
  List<Object?> get props => [productId];
}

// clear all items from the cart.
class ClearCartEvent extends CreateSaleEvent {
  const ClearCartEvent();
}

// triggered when the user selects a new payment method.
class PaymentMethodChangedEvent extends CreateSaleEvent {
  final String paymentMethod;

  const PaymentMethodChangedEvent({required this.paymentMethod});

  @override
  List<Object?> get props => [paymentMethod];
}

// submit the final sale to the backend.
class SubmitSaleEvent extends CreateSaleEvent {
  final String? notes;

  const SubmitSaleEvent({this.notes});

  @override
  List<Object?> get props => [notes];
}

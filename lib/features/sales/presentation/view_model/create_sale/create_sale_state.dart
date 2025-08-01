import 'package:equatable/equatable.dart';
import 'package:quickstock/features/product/domain/entity/product_entity.dart';

// an item that has been added to the current sale cart.
class CartItem extends Equatable {
  final String productId;
  final String name;
  final int quantity;
  final double unitPrice;

  const CartItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });

  double get totalPrice => quantity * unitPrice;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      productId: productId,
      name: name,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice,
    );
  }

  @override
  List<Object?> get props => [productId, name, quantity, unitPrice];
}

// enum for the different statuses of the Create Sale screen
enum CreateSaleStatus {
  initial,
  loadingProducts,
  productsLoaded,
  submitting,
  success,
  failure,
}

class CreateSaleState extends Equatable {
  final CreateSaleStatus status;
  final String? errorMessage;

  // Data for the "Products" tab
  final List<ProductEntity> allProducts; //  master list of products
  final List<ProductEntity>
  filteredProducts; //  list to display after search
  final String searchQuery;

  // Data for the "Current Sale" tab (the cart)
  final List<CartItem> cartItems;
  final double cartTotal;
  final String paymentMethod;

  const CreateSaleState({
    required this.status,
    this.errorMessage,
    required this.allProducts,
    required this.filteredProducts,
    required this.searchQuery,
    required this.cartItems,
    required this.cartTotal,
    required this.paymentMethod,
  });

  const CreateSaleState.initial()
    : status = CreateSaleStatus.initial,
      errorMessage = null,
      allProducts = const [],
      filteredProducts = const [],
      searchQuery = '',
      cartItems = const [],
      cartTotal = 0.0,
      paymentMethod = 'cash'; 

  CreateSaleState copyWith({
    CreateSaleStatus? status,
    String? errorMessage,
    bool clearError = false,
    List<ProductEntity>? allProducts,
    List<ProductEntity>? filteredProducts,
    String? searchQuery,
    List<CartItem>? cartItems,
    double? cartTotal,
    String? paymentMethod,
  }) {
    return CreateSaleState(
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      searchQuery: searchQuery ?? this.searchQuery,
      cartItems: cartItems ?? this.cartItems,
      cartTotal: cartTotal ?? this.cartTotal,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    allProducts,
    filteredProducts,
    searchQuery,
    cartItems,
    cartTotal,
    paymentMethod,
  ];
}

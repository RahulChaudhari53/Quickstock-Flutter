import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/product/domain/use_case/get_all_product_usecase.dart';
import 'package:quickstock/features/sales/domain/use_case/create_sale_params.dart';
import 'package:quickstock/features/sales/domain/use_case/create_sale_usecase.dart';
import 'package:quickstock/features/sales/presentation/view_model/create_sale/create_sale_event.dart';
import 'package:quickstock/features/sales/presentation/view_model/create_sale/create_sale_state.dart';

class CreateSaleViewModel extends Bloc<CreateSaleEvent, CreateSaleState> {
  final GetAllProductsUsecase _getAllProductsUsecase;
  final CreateSaleUsecase _createSaleUsecase;

  CreateSaleViewModel({
    required GetAllProductsUsecase getAllProductsUsecase,
    required CreateSaleUsecase createSaleUsecase,
  }) : _getAllProductsUsecase = getAllProductsUsecase,
       _createSaleUsecase = createSaleUsecase,
       super(const CreateSaleState.initial()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<SearchProductsEvent>(_onSearchProducts);
    on<AddItemToCartEvent>(_onAddItemToCart);
    on<UpdateItemQuantityEvent>(_onUpdateItemQuantity);
    on<RemoveItemFromCartEvent>(_onRemoveItemFromCart);
    on<ClearCartEvent>(_onClearCart);
    on<PaymentMethodChangedEvent>(_onPaymentMethodChanged);
    on<SubmitSaleEvent>(_onSubmitSale);
  }

  // --- Product List Management ---

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<CreateSaleState> emit,
  ) async {
    emit(state.copyWith(status: CreateSaleStatus.loadingProducts));

    // Make one single call with a limit high enough to get all products
    final params = GetAllProductsParams(page: 1, limit: 1000, isActive: true);
    final result = await _getAllProductsUsecase.call(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CreateSaleStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (productData) {
        emit(
          state.copyWith(
            status: CreateSaleStatus.productsLoaded,
            allProducts: productData.items,
            filteredProducts: productData.items,
          ),
        );
      },
    );
  }

  void _onSearchProducts(
    SearchProductsEvent event,
    Emitter<CreateSaleState> emit,
  ) {
    final query = event.query.toLowerCase();
    if (query.isEmpty) {
      emit(
        state.copyWith(filteredProducts: state.allProducts, searchQuery: ''),
      );
      return;
    }

    final filtered =
        state.allProducts.where((product) {
          return product.name.toLowerCase().contains(query) ||
              product.sku.toLowerCase().contains(query);
        }).toList();

    emit(state.copyWith(filteredProducts: filtered, searchQuery: query));
  }

  // --- Cart Management ---

  void _onAddItemToCart(
    AddItemToCartEvent event,
    Emitter<CreateSaleState> emit,
  ) {
    final newCart = List<CartItem>.from(state.cartItems);
    final productToAdd = event.product;

    final existingItemIndex = newCart.indexWhere(
      (item) => item.productId == productToAdd.id,
    );

    if (existingItemIndex != -1) {
      // If item already exists, just increase quantity
      final existingItem = newCart[existingItemIndex];
      newCart[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
    } else {
      // Otherwise, add new item to cart
      newCart.add(
        CartItem(
          productId: productToAdd.id,
          name: productToAdd.name,
          quantity: 1,
          unitPrice: productToAdd.sellingPrice,
        ),
      );
    }
    _emitCartUpdate(emit, newCart);
  }

  void _onUpdateItemQuantity(
    UpdateItemQuantityEvent event,
    Emitter<CreateSaleState> emit,
  ) {
    final newCart = List<CartItem>.from(state.cartItems);
    final itemIndex = newCart.indexWhere(
      (item) => item.productId == event.productId,
    );

    if (itemIndex != -1) {
      if (event.newQuantity > 0) {
        newCart[itemIndex] = newCart[itemIndex].copyWith(
          quantity: event.newQuantity,
        );
      } else {
        // If quantity is 0 or less, remove the item
        newCart.removeAt(itemIndex);
      }
    }
    _emitCartUpdate(emit, newCart);
  }

  void _onRemoveItemFromCart(
    RemoveItemFromCartEvent event,
    Emitter<CreateSaleState> emit,
  ) {
    final newCart = List<CartItem>.from(state.cartItems)
      ..removeWhere((item) => item.productId == event.productId);
    _emitCartUpdate(emit, newCart);
  }

  void _onClearCart(ClearCartEvent event, Emitter<CreateSaleState> emit) {
    _emitCartUpdate(emit, []);
  }

  void _onPaymentMethodChanged(
    PaymentMethodChangedEvent event,
    Emitter<CreateSaleState> emit,
  ) {
    emit(state.copyWith(paymentMethod: event.paymentMethod));
  }

  // --- Sale Submission ---

  Future<void> _onSubmitSale(
    SubmitSaleEvent event,
    Emitter<CreateSaleState> emit,
  ) async {
    if (state.cartItems.isEmpty || state.status == CreateSaleStatus.submitting)
      return;

    emit(state.copyWith(status: CreateSaleStatus.submitting));

    final saleItems =
        state.cartItems
            .map(
              (cartItem) => SaleItemParam(
                productId: cartItem.productId,
                quantity: cartItem.quantity,
                unitPrice: cartItem.unitPrice,
              ),
            )
            .toList();

    final params = CreateSaleParams(
      paymentMethod: state.paymentMethod,
      notes: event.notes,
      items: saleItems,
    );

    final result = await _createSaleUsecase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CreateSaleStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) => emit(state.copyWith(status: CreateSaleStatus.success)),
    );
  }

  // --- Helper Methods ---

  void _emitCartUpdate(
    Emitter<CreateSaleState> emit,
    List<CartItem> updatedCart,
  ) {
    final total = updatedCart.fold<double>(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );

    emit(
      state.copyWith(
        cartItems: updatedCart,
        cartTotal: total,
        status: CreateSaleStatus.productsLoaded,
        // errorMessage: '',
        errorMessage: null,
      ),
    );
  }
}

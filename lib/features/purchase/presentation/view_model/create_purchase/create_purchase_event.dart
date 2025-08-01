import 'package:equatable/equatable.dart';
import 'package:quickstock/features/purchase/domain/entity/purchase_entity.dart';

abstract class CreatePurchaseEvent extends Equatable {
  const CreatePurchaseEvent();
  @override
  List<Object?> get props => [];
}

/// Event to initialize the form. Fetches data for dropdowns.
/// It optionally takes a purchase object to pre-populate the form for editing.
class InitializeForm extends CreatePurchaseEvent {
  final PurchaseEntity? purchaseToEdit;

  const InitializeForm({this.purchaseToEdit});

  @override
  List<Object?> get props => [purchaseToEdit];
}

/// Event triggered when the user selects a supplier from the dropdown.
class SupplierChanged extends CreatePurchaseEvent {
  final String supplierId;

  const SupplierChanged(this.supplierId);

  @override
  List<Object> get props => [supplierId];
}

/// Event triggered when the user selects a payment method.
class PaymentMethodChanged extends CreatePurchaseEvent {
  final String paymentMethod;

  const PaymentMethodChanged(this.paymentMethod);

  @override
  List<Object> get props => [paymentMethod];
}

/// Event triggered when the user types in the notes field.
class NotesChanged extends CreatePurchaseEvent {
  final String notes;

  const NotesChanged(this.notes);

  @override
  List<Object> get props => [notes];
}

/// Event triggered when the 'Add Item' button is pressed.
class ItemAdded extends CreatePurchaseEvent {
  const ItemAdded();
}

/// Event triggered when an item is removed from the list.
class ItemRemoved extends CreatePurchaseEvent {
  final int index;

  const ItemRemoved(this.index);

  @override
  List<Object> get props => [index];
}

/// Event triggered when a field within an item row is changed.
class ItemUpdated extends CreatePurchaseEvent {
  final int index;
  final String? productId;
  final String? quantity;
  final String? unitCost;

  const ItemUpdated({
    required this.index,
    this.productId,
    this.quantity,
    this.unitCost,
  });

  @override
  List<Object?> get props => [index, productId, quantity, unitCost];
}

/// Event triggered when the final 'Create Purchase' or 'Save Changes' button is pressed.
class FormSubmitted extends CreatePurchaseEvent {
  const FormSubmitted();
}

import 'package:equatable/equatable.dart';
import 'package:quickstock/features/product/domain/entity/product_entity.dart';
import 'package:quickstock/features/supplier/domain/entity/supplier_entity.dart';

/// The overall status of the form's data (for dropdowns).
enum FormDataStatus { initial, loading, success, failure }

/// The mode of the form, either creating a new entry or editing an existing one.
enum FormMode { create, edit }

/// The status of the form submission process.
enum FormSubmissionStatus { idle, loading, success, failure }

// --- Helper class for managing a single item row in the form ---

/// Represents a single item line in the create/edit form.
/// It holds the raw string values from the TextFields for validation.
class FormPurchaseItem extends Equatable {
  final ProductEntity? product;
  final String quantity;
  final String unitCost;

  const FormPurchaseItem({
    this.product,
    this.quantity = '1',
    this.unitCost = '0',
  });

  FormPurchaseItem copyWith({
    ProductEntity? product,
    String? quantity,
    String? unitCost,
  }) {
    return FormPurchaseItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      unitCost: unitCost ?? this.unitCost,
    );
  }

  @override
  List<Object?> get props => [product, quantity, unitCost];
}

// --- The Main State Class ---

class CreatePurchaseState extends Equatable {
  // --- Form Status & Mode ---
  final FormMode formMode;
  final FormDataStatus formDataStatus;
  final FormSubmissionStatus submissionStatus;

  // --- Data for Dropdowns ---
  final List<SupplierEntity> availableSuppliers;
  final List<ProductEntity> availableProducts;

  // --- Form Field Values ---
  final String? editPurchaseId; // ID of the purchase being edited
  final String selectedSupplierId;
  final String selectedPaymentMethod;
  final List<FormPurchaseItem> items;
  final String notes;

  // --- Error/Success Messages ---
  final String? errorMessage;
  final String? successMessage;

  const CreatePurchaseState({
    this.formMode = FormMode.create,
    this.formDataStatus = FormDataStatus.initial,
    this.submissionStatus = FormSubmissionStatus.idle,
    this.availableSuppliers = const [],
    this.availableProducts = const [],
    this.editPurchaseId,
    this.selectedSupplierId = '',
    this.selectedPaymentMethod = 'cash', // Default value
    this.items = const [FormPurchaseItem()], // Start with one empty item
    this.notes = '',
    this.errorMessage,
    this.successMessage,
  });

  CreatePurchaseState copyWith({
    FormMode? formMode,
    FormDataStatus? formDataStatus,
    FormSubmissionStatus? submissionStatus,
    List<SupplierEntity>? availableSuppliers,
    List<ProductEntity>? availableProducts,
    String? editPurchaseId,
    String? selectedSupplierId,
    String? selectedPaymentMethod,
    List<FormPurchaseItem>? items,
    String? notes,
    String? errorMessage,
    String? successMessage,
  }) {
    return CreatePurchaseState(
      formMode: formMode ?? this.formMode,
      formDataStatus: formDataStatus ?? this.formDataStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      availableSuppliers: availableSuppliers ?? this.availableSuppliers,
      availableProducts: availableProducts ?? this.availableProducts,
      editPurchaseId: editPurchaseId ?? this.editPurchaseId,
      selectedSupplierId: selectedSupplierId ?? this.selectedSupplierId,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      items: items ?? this.items,
      notes: notes ?? this.notes,
      errorMessage: errorMessage, // Should be explicitly set or cleared
      successMessage: successMessage, // Should be explicitly set or cleared
    );
  }

  @override
  List<Object?> get props => [
    formMode,
    formDataStatus,
    submissionStatus,
    availableSuppliers,
    availableProducts,
    editPurchaseId,
    selectedSupplierId,
    selectedPaymentMethod,
    items,
    notes,
    errorMessage,
    successMessage,
  ];
}

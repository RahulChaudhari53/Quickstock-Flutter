import 'package:equatable/equatable.dart';
import 'package:quickstock/features/purchase/domain/entity/purchase_entity.dart';

/// An enum to represent the different statuses for the main page content.
enum PageStatus { initial, loading, success, failure }

/// An enum to represent the status of an action being performed (e.g., cancelling).
enum ActionStatus { idle, loading, success, failure }

class PurchaseDetailState extends Equatable {
  // --- Page Content State ---
  /// The status of the main page loading process.
  final PageStatus pageStatus;

  /// The loaded purchase order entity.
  final PurchaseEntity? purchase;

  /// An error message specifically for page loading failures.
  final String? pageErrorMessage;

  // --- Action State ---
  /// The status of the currently executing action (e.g., 'Cancel' or 'Receive').
  final ActionStatus actionStatus;

  /// An error message specifically for action failures.
  final String? actionErrorMessage;

  /// A success message for actions to be shown in a snackbar.
  final String? successMessage;

  const PurchaseDetailState({
    this.pageStatus = PageStatus.initial,
    this.purchase,
    this.pageErrorMessage,
    this.actionStatus = ActionStatus.idle,
    this.actionErrorMessage,
    this.successMessage,
  });

  PurchaseDetailState copyWith({
    PageStatus? pageStatus,
    PurchaseEntity? purchase,
    String? pageErrorMessage,
    ActionStatus? actionStatus,
    String? actionErrorMessage,
    String? successMessage,
  }) {
    return PurchaseDetailState(
      pageStatus: pageStatus ?? this.pageStatus,
      purchase: purchase ?? this.purchase,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      actionStatus: actionStatus ?? this.actionStatus,
      actionErrorMessage: actionErrorMessage ?? this.actionErrorMessage,
      // Clear specific messages when the relevant status changes to avoid showing stale info.
      successMessage:
          (actionStatus != ActionStatus.success)
              ? null
              : successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
    pageStatus,
    purchase,
    pageErrorMessage,
    actionStatus,
    actionErrorMessage,
    successMessage,
  ];
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/purchase/presentation/view_model/purchase_history/purchase_history_event.dart';
import 'package:quickstock/features/purchase/presentation/view_model/purchase_history/purchase_history_view_model.dart';

class PurchaseFilterBar extends StatefulWidget {
  const PurchaseFilterBar({super.key});

  @override
  State<PurchaseFilterBar> createState() => _PurchaseFilterBarState();
}

class _PurchaseFilterBarState extends State<PurchaseFilterBar> {
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();

  // In a real application, this data would come from a SupplierViewModel/Repository
  // For now, we are using a hardcoded map.
  final Map<String, String> _suppliers = {
    'All Suppliers': '',
    // NOTE: This ID is a placeholder and must match a real ID in your dev DB
    'Global Tech Supplies': '6876fce9fdef691acb508972',
    // Add other suppliers as needed
  };

  // The statuses for the purchase status filter dropdown
  final Map<String, String> _statuses = {
    'All Statuses': '', // An empty string value means no filter
    'Ordered': 'ordered',
    'Received': 'received',
    'Cancelled': 'cancelled',
  };

  // Local state to hold the currently selected values of the dropdowns
  String _selectedSupplierId = '';
  String _selectedStatus = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  /// Called on every keystroke in the search text field.
  void _onSearchChanged(String query) {
    // If a timer is already active, cancel it.
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    // Start a new timer. The action will only run after the user stops typing for 500ms.
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _applyFilters();
    });
  }

  /// Dispatches the FiltersApplied event to the ViewModel with the current
  /// state of all filter controls.
  void _applyFilters() {
    // We use context.read to access the ViewModel without listening for changes.
    context.read<PurchaseHistoryViewModel>().add(
      FiltersApplied(
        search: _searchController.text,
        supplierId: _selectedSupplierId.isEmpty ? null : _selectedSupplierId,
        purchaseStatus: _selectedStatus.isEmpty ? null : _selectedStatus,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search TextField
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search by PO Number...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
          ),
          onChanged: _onSearchChanged,
        ),
        const SizedBox(height: 8),
        // Dropdowns for Supplier and Status
        Row(
          children: [
            // Supplier Dropdown
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedSupplierId,
                decoration: const InputDecoration(
                  labelText: 'Supplier',
                  border: OutlineInputBorder(),
                ),
                items:
                    _suppliers.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.value,
                        child: Text(entry.key),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() => _selectedSupplierId = value ?? '');
                  // Immediately apply filters when a dropdown value changes
                  _applyFilters();
                },
              ),
            ),
            const SizedBox(width: 8),
            // Status Dropdown
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items:
                    _statuses.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.value,
                        child: Text(entry.key),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() => _selectedStatus = value ?? '');
                  // Immediately apply filters when a dropdown value changes
                  _applyFilters();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

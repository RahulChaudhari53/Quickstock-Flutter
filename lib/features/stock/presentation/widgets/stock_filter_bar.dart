import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/stock/presentation/view_model/stock_view_model/stock_event.dart';
import 'package:quickstock/features/stock/presentation/view_model/stock_view_model/stock_view_model.dart';

class StockFilterBar extends StatefulWidget {
  const StockFilterBar({super.key});

  @override
  State<StockFilterBar> createState() => _StockFilterBarState();
}

class _StockFilterBarState extends State<StockFilterBar> {
  final _searchController = TextEditingController();
  String _selectedStatus = '';

  @override
  void initState() {
    super.initState();
    final currentState = context.read<StockViewModel>().state;
    _searchController.text = currentState.searchQuery ?? '';
    _selectedStatus = currentState.stockStatus ?? '';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    context.read<StockViewModel>().add(
      ApplyFiltersEvent(query: _searchController.text, status: _selectedStatus),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search by product name or SKU...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: _applyFilters,
              child: const Text('Apply'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children: [
            ChoiceChip(
              label: const Text('All'),
              selected: _selectedStatus.isEmpty,
              onSelected: (selected) {
                if (selected) setState(() => _selectedStatus = '');
              },
            ),
            ChoiceChip(
              label: const Text('Low Stock'),
              selected: _selectedStatus == 'low_stock',
              onSelected: (selected) {
                if (selected) setState(() => _selectedStatus = 'low_stock');
              },
            ),
            ChoiceChip(
              label: const Text('Out of Stock'),
              selected: _selectedStatus == 'out_of_stock',
              onSelected: (selected) {
                if (selected) setState(() => _selectedStatus = 'out_of_stock');
              },
            ),
          ],
        ),
      ],
    );
  }
}

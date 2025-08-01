import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/app/service_locator/service_locator.dart';
import 'package:quickstock/features/supplier/domain/entity/supplier_entity.dart';
import 'package:quickstock/features/supplier/presentation/view_model/supplier_detail_view_model/supplier_detail_event.dart';
import 'package:quickstock/features/supplier/presentation/view_model/supplier_detail_view_model/supplier_detail_state.dart';
import 'package:quickstock/features/supplier/presentation/view_model/supplier_detail_view_model/supplier_detail_view_model.dart';

class SupplierDetailView extends StatelessWidget {
  final String supplierId;

  const SupplierDetailView({super.key, required this.supplierId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              serviceLocator<SupplierDetailViewModel>()
                ..add(FetchSupplierDetailsEvent(supplierId: supplierId)),
      child: const _SupplierDetailViewBody(),
    );
  }
}

class _SupplierDetailViewBody extends StatelessWidget {
  const _SupplierDetailViewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Supplier Details')),
      body: BlocBuilder<SupplierDetailViewModel, SupplierDetailState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: ${state.errorMessage}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state.supplier != null) {
            return _SupplierDetailsContent(supplier: state.supplier!);
          }

          return const Center(child: Text('Something went wrong.'));
        },
      ),
    );
  }
}

class _SupplierDetailsContent extends StatelessWidget {
  final SupplierEntity supplier;

  const _SupplierDetailsContent({required this.supplier});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Supplier Information',
                    style: theme.textTheme.titleLarge,
                  ),
                  Chip(
                    label: Text(supplier.isActive ? 'Active' : 'Inactive'),
                    backgroundColor:
                        supplier.isActive
                            ? theme.colorScheme.primary.withAlpha(
                              (0.7 * 255).round(),
                            )
                            : theme.colorScheme.onSurface.withAlpha(
                              (0.1 * 255).round(),
                            ),
                    labelStyle: TextStyle(
                      color:
                          supplier.isActive
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface.withOpacity(0.7),
                      fontWeight: FontWeight.w600,
                    ),
                    side: BorderSide.none,
                  ),
                ],
              ),
              const Divider(height: 32),
              _DetailRow(
                icon: Icons.badge_outlined,
                label: 'Supplier Name',
                value: supplier.name,
              ),
              _DetailRow(
                icon: Icons.email_outlined,
                label: 'Email Address',
                value: supplier.email,
              ),
              _DetailRow(
                icon: Icons.phone_outlined,
                label: 'Phone Number',
                value: supplier.phone,
              ),
              if (supplier.notes != null && supplier.notes!.isNotEmpty)
                _DetailRow(
                  icon: Icons.note_alt_outlined,
                  label: 'Notes',
                  value: supplier.notes!,
                  isMultiline: true,
                ),
              _DetailRow(
                icon: Icons.calendar_today_outlined,
                label: 'Supplier Since',
                value: '${supplier.createdAt.toLocal()}'.split(' ')[0],
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to Supplier List'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isMultiline;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isMultiline = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelMedium),
                const SizedBox(height: 4),
                Text(
                  value,
                  style:
                      isMultiline
                          ? theme.textTheme.bodyLarge?.copyWith(height: 1.4)
                          : theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

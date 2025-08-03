import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/supplier/presentation/view/supplier_detail_view.dart';
import 'package:quickstock/features/supplier/presentation/widgets/supplier_form_dialog.dart';
import 'package:quickstock/features/supplier/domain/entity/supplier_entity.dart';
import 'package:quickstock/features/supplier/presentation/view_model/supplier_view_model/supplier_event.dart';
import 'package:quickstock/features/supplier/presentation/view_model/supplier_view_model/supplier_view_model.dart';

class SupplierCard extends StatelessWidget {
  final SupplierEntity supplier;
  const SupplierCard({super.key, required this.supplier});

  void _showDeactivateConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Deactivate Supplier?'),
            content: Text(
              'Are you sure you want to deactivate "${supplier.name}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                onPressed: () {
                  context.read<SupplierViewModel>().add(
                    DeactivateSupplierEvent(supplierId: supplier.id),
                  );
                  Navigator.pop(dialogContext);
                },
                child: const Text('Deactivate'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isProcessing = context.select(
      (SupplierViewModel bloc) =>
          bloc.state.processingSupplierIds.contains(supplier.id),
    );
    final borderColor =
        (theme.inputDecorationTheme.enabledBorder as OutlineInputBorder)
            .borderSide
            .color;

    final statusColor =
        supplier.isActive ? Colors.green.shade600 : Colors.red.shade600;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      clipBehavior:
          Clip.antiAlias, // ensures the overlay respects the card's rounded corners
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        supplier.name,
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      avatar: Icon(
                        supplier.isActive
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        color: statusColor,
                        size: 16,
                      ),
                      label: Text(
                        supplier.isActive ? 'Active' : 'Inactive',
                        style: theme.textTheme.labelMedium,
                      ),
                      backgroundColor: statusColor.withOpacity(0.1),
                      side: BorderSide.none,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _InfoRow(icon: Icons.email_outlined, text: supplier.email),
                const SizedBox(height: 8),
                _InfoRow(icon: Icons.phone_outlined, text: supplier.phone),
                if (supplier.notes != null && supplier.notes!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.note_alt_outlined,
                    text: supplier.notes!,
                  ),
                ],
                const Divider(height: 32),
                _ActionButtons(supplier: supplier),
              ],
            ),
          ),
          if (isProcessing)
            Positioned.fill(
              child: Container(
                color: Colors.white.withAlpha((0.5 * 255).round()),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final SupplierEntity supplier;
  const _ActionButtons({required this.supplier});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SupplierDetailView(supplierId: supplier.id),
              ),
            );
          },
          child: const Text('View Details'),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder:
                  (_) => BlocProvider.value(
                    value: BlocProvider.of<SupplierViewModel>(context),
                    child: SupplierFormDialog(supplier: supplier),
                  ),
            );
          },
          icon: const Icon(Icons.edit_outlined),
          tooltip: 'Edit',
        ),
        if (supplier.isActive)
          IconButton(
            onPressed:
                () => (SupplierCard(
                  supplier: supplier,
                ))._showDeactivateConfirmDialog(context),
            icon: Icon(
              Icons.delete_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            tooltip: 'Deactivate',
          )
        else
          IconButton(
            onPressed:
                () => context.read<SupplierViewModel>().add(
                  ActivateSupplierEvent(supplierId: supplier.id),
                ),
            icon: Icon(
              Icons.restore_from_trash_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            tooltip: 'Activate',
          ),
      ],
    );
  }
}

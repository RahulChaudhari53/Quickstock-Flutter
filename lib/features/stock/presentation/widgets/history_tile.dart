import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickstock/features/stock/domain/entity/stock_history_entity.dart';

class HistoryTile extends StatelessWidget {
  final StockHistoryEntity historyItem;

  const HistoryTile({super.key, required this.historyItem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final movementInfo = _getMovementInfo(historyItem.movementType);
    final formattedDate = DateFormat(
      'MMM d, yyyy hh:mm a',
    ).format(historyItem.date);

    return IntrinsicHeight(
      child: Row(
        children: [
          _TimelineIndicator(
            icon: movementInfo.icon,
            iconColor: movementInfo.color,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      movementInfo.text,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: movementInfo.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${movementInfo.prefix}${historyItem.quantity}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: movementInfo.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (historyItem.notes != null && historyItem.notes!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      historyItem.notes!,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'By: ${historyItem.movedBy}',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(formattedDate, style: theme.textTheme.bodySmall),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ), 
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Helper to get display properties based on movement type
  _MovementInfo _getMovementInfo(String movementType) {
    switch (movementType) {
      case 'purchase':
        return _MovementInfo(
          'Purchase',
          Icons.add_shopping_cart,
          Colors.green.shade600,
          '+',
        );
      case 'sale':
        return _MovementInfo(
          'Sale',
          Icons.remove_shopping_cart_outlined,
          Colors.red.shade600,
          '-',
        );
      case 'adjustment':
        return _MovementInfo(
          'Adjustment',
          Icons.build_circle_outlined,
          Colors.orange.shade700,
          '+',
        );
      case 'return':
        return _MovementInfo(
          'Return',
          Icons.assignment_return_outlined,
          Colors.blue.shade600,
          '+',
        );
      default:
        return _MovementInfo('Unknown', Icons.help_outline, Colors.grey, '');
    }
  }
}

// Helper widget for the timeline graphic itself
class _TimelineIndicator extends StatelessWidget {
  final IconData icon;
  final Color iconColor;

  const _TimelineIndicator({required this.icon, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(width: 2, color: Theme.of(context).dividerColor),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        Expanded(
          child: Container(width: 2, color: Theme.of(context).dividerColor),
        ),
      ],
    );
  }
}

// Simple data class for movement display properties
class _MovementInfo {
  final String text;
  final IconData icon;
  final Color color;
  final String prefix;

  _MovementInfo(this.text, this.icon, this.color, this.prefix);
}

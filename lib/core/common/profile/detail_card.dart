import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onEditClick;

  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    required this.onEditClick,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 16)),
          ],
        ),
        IconButton(
          onPressed: onEditClick,
          icon: Icon(LucideIcons.edit2, color: Colors.grey.shade500, size: 20),
          splashRadius: 20,
        ),
      ],
    );
  }
}

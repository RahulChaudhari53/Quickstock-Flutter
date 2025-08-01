import 'package:flutter/material.dart';

class ProfileSectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onEdit;
  final String editText;

  const ProfileSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.onEdit,
    this.editText = 'Edit',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 1,
      shape: theme.cardTheme.shape,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: theme.textTheme.titleLarge),
                if (onEdit != null)
                  TextButton(onPressed: onEdit, child: Text(editText)),
              ],
            ),
            const Divider(height: 24),
            child,
          ],
        ),
      ),
    );
  }
}

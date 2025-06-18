import 'package:flutter/material.dart';

class SocialMediaDivider extends StatelessWidget {
  final String type;

  const SocialMediaDivider({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('Or $type With'),
        ),
        Expanded(child: Divider(thickness: 1)),
      ],
    );
  }
}

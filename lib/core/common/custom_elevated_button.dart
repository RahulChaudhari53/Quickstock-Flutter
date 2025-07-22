import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed; // Allow null to handle disabled state
  final Widget child;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final finalStyle = Theme.of(context).elevatedButtonTheme.style?.copyWith(
      backgroundColor: WidgetStateProperty.all(backgroundColor),
      foregroundColor: WidgetStateProperty.all(foregroundColor),
    );

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: finalStyle,
        child: child,
      ),
    );
  }
}

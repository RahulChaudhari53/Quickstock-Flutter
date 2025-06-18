import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final btnBgColor = backgroundColor ?? Colors.black;
    final btnFgColor = foregroundColor ?? Colors.white;
    final btnPadding = padding ?? const EdgeInsets.symmetric(vertical: 14);

    Widget button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: btnBgColor,
        foregroundColor: btnFgColor,
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.7,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        padding: btnPadding,
      ),
      child: child,
    );

    if (width != null || height != null) {
      button = SizedBox(width: width, height: height, child: button);
    }

    return button;
  }
}

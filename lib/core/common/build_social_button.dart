import 'package:flutter/material.dart';

class BuildSocialButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;

  const BuildSocialButton({
    super.key,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 110,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          elevation: 2,
        ),
        child: Image.asset(
          imagePath,
          height: 24,
          width: 24,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

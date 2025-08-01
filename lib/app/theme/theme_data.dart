// lib/app/theme
import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  const colorScheme = ColorScheme(
    primary: Color(0xFF059669), // Emerald 600
    onPrimary: Colors.white,
    secondary: Color(0xFF52525B), // Zinc 600
    onSecondary: Colors.white,
    surface: Color(0xFFFAFAFA), // Zinc 50
    onSurface: Color(0xFF18181B), // Zinc 900
    error: Color(0xFFDC2626), // Red 600
    onError: Colors.white,
    brightness: Brightness.light,
  );

  const primaryTextColor = Color(0xFF18181B); // Zinc 900
  const secondaryTextColor = Color(0xFF52525B); // Zinc 600
  const tertiaryTextColor = Color(0xFFa1a1aa); // Zinc 400
  const borderColor = Color(0xFFE4E4E7); // Zinc 200

  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',

    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    primaryColor: colorScheme.primary,

    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: primaryTextColor,
      elevation: 0,
      titleTextStyle: const TextStyle(
        fontFamily: 'Roboto',
        color: primaryTextColor,
        fontSize: 20,
        fontWeight: FontWeight.w600, // Roboto-SemiBold
      ),
      iconTheme: const IconThemeData(color: primaryTextColor),
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: primaryTextColor,
        fontWeight: FontWeight.w600,
      ),
      displayMedium: TextStyle(
        color: primaryTextColor,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        color: primaryTextColor,
        fontWeight: FontWeight.w500,
      ), // Medium weight
      titleLarge: TextStyle(
        color: primaryTextColor,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: secondaryTextColor,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ), // Regular
      bodyMedium: TextStyle(
        color: secondaryTextColor,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ), // Regular
      labelLarge: TextStyle(
        color: primaryTextColor,
        fontWeight: FontWeight.w600,
      ), // SemiBold
      labelMedium: TextStyle(
        color: secondaryTextColor,
        fontWeight: FontWeight.w500,
      ), // Medium
      bodySmall: TextStyle(
        color: tertiaryTextColor,
        fontWeight: FontWeight.w400,
      ), // Regular
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: const TextStyle(
        color: secondaryTextColor,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: const TextStyle(
        color: tertiaryTextColor,
        fontWeight: FontWeight.w400,
      ),
      prefixIconColor: secondaryTextColor,
      suffixIconColor: secondaryTextColor,
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.error, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        textStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        textStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return secondaryTextColor;
      }),
      checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
  );
}

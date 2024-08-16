import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: 'SFProText',
  primaryColor: const Color(0xFF000000),  // Noir
  disabledColor: const Color(0xFFBABFC4),
  primaryColorDark: const Color(0xFF000000),  // Noir
  brightness: Brightness.light,
  hintColor: const Color(0xFF9F9F9F),
  cardColor: Colors.white,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF000000),  // Noir
    surface: Color(0xFFF3F3F3),
    error: Color(0xFFFF6767),
    secondary: Color(0xFF000000),  // Noir
    tertiary: Color(0xFF000000),  // Noir
    tertiaryContainer: Color(0xFFF5F5F5),  // Très clair pour les cartes
    secondaryContainer: Color(0xFFF5F5F5),  // Très clair pour les cartes
    onTertiary: Color(0xFF757575),  // Gris pour les icônes
    onSecondary: Color(0xFF757575),  // Gris pour les icônes
    onSecondaryContainer: Color(0xFF888888),  // Gris moyen pour contraster
    onTertiaryContainer: Color(0xFF666666),  // Gris moyen pour contraster
    outline: Color(0xFFBDBDBD),  // Gris pour outline
    onPrimaryContainer: Color(0xFFEEEEEE),  // Très clair pour contraster
    primaryContainer: Color(0xFFFFA800),  // Couleur originale conservée
    onErrorContainer: Color(0xFFFFE6AD),
    onPrimary: Color(0xFFFFFFFF),  // Blanc pour la lisibilité
    surfaceTint: Color(0xFF000000),  // Noir
    errorContainer: Color(0xFFF6F6F6),
    shadow: Color(0xFF888888),  // Gris pour shadow
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: const Color(0xFF000000)),  // Noir
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF000000)),
    displayMedium: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF000000)),
    displaySmall: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF000000)),
    bodyLarge: TextStyle(fontWeight: FontWeight.w400, color: Color(0xFF000000)),
    bodyMedium: TextStyle(fontWeight: FontWeight.w400, color: Color(0xFF000000)),
    bodySmall: TextStyle(fontWeight: FontWeight.w400, color: Color(0xFF000000)),
  ),
);

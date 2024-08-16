import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  fontFamily: 'SFProText',
  primaryColor: const Color(0xFFFFFFFF),  // Blanc
  brightness: Brightness.dark,
  cardColor: const Color(0xFF242424),
  hintColor: const Color(0xFF9F9F9F),
  scaffoldBackgroundColor: const Color(0xFF121212),
  primaryColorDark: const Color(0xFFFFFFFF),  // Blanc
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFFFFFFF),  // Blanc
    error: Color(0xFFFF6767),
    secondary: Color(0xFFFFFFFF),  // Blanc
    tertiary: Color(0xFFFFFFFF),  // Blanc
    tertiaryContainer: Color(0xFF333333),  // Gris foncé pour contraster
    secondaryContainer: Color(0xFF444444),  // Gris foncé pour contraster
    onTertiary: Color(0xFFDDDDDD),  // Gris clair pour lisibilité
    onSecondary: Color(0xFFDDDDDD),  // Gris clair pour lisibilité
    onSecondaryContainer: Color(0xFF888888),  // Gris moyen pour contraster
    onTertiaryContainer: Color(0xFF666666),  // Gris moyen pour contraster
    outline: Color(0xFF999999),  // Gris pour outline
    onPrimaryContainer: Color(0xFFEEEEEE),  // Très clair pour contraster
    primaryContainer: Color(0xFFFFA800),  // Couleur originale conservée
    onSurface: Color(0xFFFFE6AD),
    onPrimary: Color(0xFFFFFFFF),  // Blanc pour la lisibilité
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: const Color(0xFFFFFFFF)),  // Blanc
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFFFFFFFF)),  // Blanc pour la lisibilité
    displayMedium: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFFFFFFFF)),  // Blanc pour la lisibilité
    displaySmall: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFFFFFFFF)),  // Blanc pour la lisibilité
    bodyLarge: TextStyle(fontWeight: FontWeight.w400, color: Color(0xFFFFFFFF)),  // Blanc pour la lisibilité
    bodyMedium: TextStyle(fontWeight: FontWeight.w400, color: Color(0xFFFFFFFF)),  // Blanc pour la lisibilité
    bodySmall: TextStyle(fontWeight: FontWeight.w400, color: Color(0xFFFFFFFF)),  // Blanc pour la lisibilité
  ),
);

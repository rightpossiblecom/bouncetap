import 'package:flutter/material.dart';

class AppTheme {
  static const Color navy = Color(0xFF0A192F);
  static const Color deepBlue = Color(0xFF112240);
  static const Color accent = Color(0xFF64FFDA);
  static const Color lightSlate = Color(0xFF8892B0);
  static const Color slate = Color(0xFF495670);
  static const Color white = Color(0xFFE6F1FF);
  static const Color gold = Color(0xFFFFD700);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color bronze = Color(0xFFCD7F32);
  static const Color dangerRed = Color(0xFFFF6B6B);

  static const List<Color> _comboColors = [
    accent,
    Color(0xFF64FFDA),
    Color(0xFFFFD93D),
    Color(0xFFFF8C42),
    Color(0xFFBB86FC),
  ];

  static Color comboColor(int combo) {
    return _comboColors[(combo - 1).clamp(0, _comboColors.length - 1)];
  }

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: navy,
    colorScheme: const ColorScheme.dark(
      primary: accent,
      onPrimary: navy,
      secondary: lightSlate,
      onSecondary: navy,
      surface: navy,
      onSurface: white,
      error: dangerRed,
      onError: navy,
      outline: slate,
      outlineVariant: Color(0xFF1D3461),
      primaryContainer: deepBlue,
      onPrimaryContainer: accent,
      secondaryContainer: Color(0xFF1D3461),
      onSecondaryContainer: lightSlate,
      surfaceContainerHighest: deepBlue,
    ),
    cardTheme: CardThemeData(
      color: deepBlue,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF1D3461)),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: navy,
      foregroundColor: white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        letterSpacing: 3,
        color: white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: navy,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: lightSlate),
    ),
    dividerTheme: const DividerThemeData(color: Color(0xFF1D3461)),
    listTileTheme: const ListTileThemeData(
      textColor: white,
    ),
  );

  static ThemeData lightTheme = darkTheme;
}

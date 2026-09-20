import 'package:flutter/material.dart';

/// Paleta "Light Mode" definida por el equipo de diseño.
/// Índigo como color principal, rosa/vino como acento, fondo casi blanco
/// y tinta casi negra para texto sobre fondos claros.
class AppColors {
  // Light mode
  static const Color ink = Color(0xFF090810); // texto / superficies oscuras
  static const Color background = Color(0xFFF9F9FB); // fondo general
  static const Color primary = Color(0xFF6158B3); // índigo
  static const Color accentPink = Color(0xFFD19DC4); // rosa claro (badges, highlights)
  static const Color accentRose = Color(0xFFC17B95); // rosa/vino (acento principal)

  // Dark mode
  static const Color inkDark = Color(0xFFEFEEF6); // texto sobre fondo oscuro
  static const Color backgroundDark = Color(0xFF030207); // fondo general oscuro
  static const Color surfaceDark = Color(0xFF121018); // tarjetas/inputs sobre fondo oscuro
  static const Color navBarDark = Color(0xFF0C0A12); // barra inferior
  static const Color primaryDark = Color(0xFF564DA8); // índigo (versión oscura)
  static const Color accentPlumDark = Color(0xFF612D54); // ciruela (badges, highlights)
  static const Color accentRoseDark = Color(0xFF853C57); // rosa/vino (acento principal)
}

class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.accentRose,
      onSecondary: Colors.white,
      tertiary: AppColors.accentPink,
      surface: Colors.white,
      onSurface: AppColors.ink,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.ink,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primary.withOpacity(0.16),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? AppColors.primary : Colors.grey.shade600,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? AppColors.primary : Colors.grey.shade600);
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.accentPink.withOpacity(0.25),
        selectedColor: AppColors.primary,
        labelStyle: const TextStyle(color: AppColors.ink),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      textTheme: ThemeData.light().textTheme.apply(
            bodyColor: AppColors.ink,
            displayColor: AppColors.ink,
          ),
    );
  }

  /// Paleta "Dark Mode" definida por el equipo de diseño (mismos roles que
  /// Light, ajustados para fondo oscuro).
  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryDark,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.primaryDark,
      onPrimary: Colors.white,
      secondary: AppColors.accentRoseDark,
      onSecondary: Colors.white,
      tertiary: AppColors.accentPlumDark,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.inkDark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.inkDark,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.navBarDark,
        indicatorColor: AppColors.primaryDark.withOpacity(0.32),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? AppColors.inkDark : Colors.grey.shade500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? AppColors.inkDark : Colors.grey.shade500);
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryDark, width: 1.5),
        ),
        filled: true,
        fillColor: AppColors.surfaceDark,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.inkDark,
          side: const BorderSide(color: AppColors.primaryDark),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.accentPlumDark.withOpacity(0.55),
        selectedColor: AppColors.primaryDark,
        labelStyle: const TextStyle(color: AppColors.inkDark),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      cardColor: AppColors.surfaceDark,
      textTheme: ThemeData.dark().textTheme.apply(
            bodyColor: AppColors.inkDark,
            displayColor: AppColors.inkDark,
          ),
    );
  }
}

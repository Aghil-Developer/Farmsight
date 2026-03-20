import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class FarmColors {
  static const Color primary = Color(0xFF2D5016);
  static const Color primaryLight = Color(0xFF5A8A3C);
  static const Color primarySurface = Color(0xFFE8F0E2);

  
  static const Color secondary = Color(0xFFC4784A);
  static const Color accent = Color(0xFFD4A843);

  static const Color backgroundLight = Color(0xFFFAF6F0);
  static const Color surfaceLight = Color(0xFFF5EFE6);
  static const Color cardLight = Color(0xFFFFFFFF);


  static const Color backgroundDark = Color(0xFF1A1612);
  static const Color surfaceDark = Color(0xFF2C2520);
  static const Color cardDark = Color(0xFF362F28);


  static const Color textPrimary = Color(0xFF2C2C2C);
  static const Color textSecondary = Color(0xFF6B5E50);
  static const Color textOnPrimary = Color(0xFFFAF6F0);
  static const Color textPrimaryDark = Color(0xFFF0EAE2);
  static const Color textSecondaryDark = Color(0xFFA89A8C);

 
  static const Color error = Color(0xFFB74A3A);
  static const Color success = Color(0xFF4A8C3F);

  
  static const LinearGradient appBarGradient = LinearGradient(
    colors: [Color(0xFF2D5016), Color(0xFF5A8A3C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient appBarGradientDark = LinearGradient(
    colors: [Color(0xFF1A2F0E), Color(0xFF3A5C28)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient drawerHeaderGradient = LinearGradient(
    colors: [Color(0xFF2D5016), Color(0xFF4A7A2E), Color(0xFF6B9B4A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFF2D5016), Color(0xFF5A8A3C)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFC4784A), Color(0xFFD4A843)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}


class FarmTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: FarmColors.primary,
        secondary: FarmColors.secondary,
        surface: FarmColors.surfaceLight,
        error: FarmColors.error,
        onPrimary: FarmColors.textOnPrimary,
        onSecondary: FarmColors.textOnPrimary,
        onSurface: FarmColors.textPrimary,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: FarmColors.backgroundLight,
      textTheme: _buildTextTheme(Brightness.light),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 70,
        foregroundColor: FarmColors.textOnPrimary,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: FarmColors.textOnPrimary,
          letterSpacing: 1.2,
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: FarmColors.backgroundLight,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
        ),
      ),
      cardTheme: CardThemeData(
        color: FarmColors.cardLight,
        elevation: 2,
        shadowColor: FarmColors.primary.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: FarmColors.primary,
          foregroundColor: FarmColors.textOnPrimary,
          elevation: 2,
          shadowColor: FarmColors.primary.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.nunito(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FarmColors.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: FarmColors.primaryLight.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: FarmColors.primaryLight.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: FarmColors.primary, width: 2),
        ),
        labelStyle: GoogleFonts.nunito(
          color: FarmColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
        floatingLabelStyle: GoogleFonts.nunito(
          color: FarmColors.primary,
          fontWeight: FontWeight.w700,
        ),
        prefixIconColor: FarmColors.primaryLight,
      ),
      dividerTheme: DividerThemeData(
        color: FarmColors.primary.withValues(alpha: 0.12),
        thickness: 1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return FarmColors.primary;
          return Colors.grey[400];
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return FarmColors.primarySurface;
          return Colors.grey[300];
        }),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        iconColor: FarmColors.primaryLight,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: FarmColors.textPrimary,
        ),
        subtitleTextStyle: GoogleFonts.nunito(
          fontSize: 13,
          color: FarmColors.textSecondary,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: FarmColors.primary,
        contentTextStyle: GoogleFonts.nunito(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: FarmColors.backgroundLight,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: FarmColors.textPrimary,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: FarmColors.primaryLight,
        secondary: FarmColors.secondary,
        surface: FarmColors.surfaceDark,
        error: FarmColors.error,
        onPrimary: FarmColors.textOnPrimary,
        onSecondary: FarmColors.textOnPrimary,
        onSurface: FarmColors.textPrimaryDark,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: FarmColors.backgroundDark,
      textTheme: _buildTextTheme(Brightness.dark),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 70,
        foregroundColor: FarmColors.textOnPrimary,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: FarmColors.textOnPrimary,
          letterSpacing: 1.2,
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: FarmColors.backgroundDark,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
        ),
      ),
      cardTheme: CardThemeData(
        color: FarmColors.cardDark,
        elevation: 2,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: FarmColors.primaryLight,
          foregroundColor: FarmColors.textOnPrimary,
          elevation: 2,
          shadowColor: FarmColors.primaryLight.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.nunito(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FarmColors.surfaceDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: FarmColors.primaryLight.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: FarmColors.primaryLight.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: FarmColors.primaryLight, width: 2),
        ),
        labelStyle: GoogleFonts.nunito(
          color: FarmColors.textSecondaryDark,
          fontWeight: FontWeight.w600,
        ),
        floatingLabelStyle: GoogleFonts.nunito(
          color: FarmColors.primaryLight,
          fontWeight: FontWeight.w700,
        ),
        prefixIconColor: FarmColors.primaryLight,
      ),
      dividerTheme: DividerThemeData(
        color: FarmColors.primaryLight.withValues(alpha: 0.15),
        thickness: 1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return FarmColors.primaryLight;
          return Colors.grey[600];
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return FarmColors.primaryLight.withValues(alpha: 0.3);
          }
          return Colors.grey[700];
        }),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        iconColor: FarmColors.primaryLight,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: FarmColors.textPrimaryDark,
        ),
        subtitleTextStyle: GoogleFonts.nunito(
          fontSize: 13,
          color: FarmColors.textSecondaryDark,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: FarmColors.cardDark,
        contentTextStyle: GoogleFonts.nunito(color: FarmColors.textPrimaryDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: FarmColors.surfaceDark,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: FarmColors.textPrimaryDark,
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme(Brightness brightness) {
    final Color primary =
        brightness == Brightness.light ? FarmColors.textPrimary : FarmColors.textPrimaryDark;
    final Color secondary =
        brightness == Brightness.light ? FarmColors.textSecondary : FarmColors.textSecondaryDark;

    return TextTheme(
      displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 32, fontWeight: FontWeight.w700, color: primary),
      displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 28, fontWeight: FontWeight.w700, color: primary),
      displaySmall: GoogleFonts.playfairDisplay(
          fontSize: 24, fontWeight: FontWeight.w600, color: primary),
      headlineLarge: GoogleFonts.playfairDisplay(
          fontSize: 22, fontWeight: FontWeight.w700, color: primary),
      headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 20, fontWeight: FontWeight.w600, color: primary),
      headlineSmall: GoogleFonts.playfairDisplay(
          fontSize: 18, fontWeight: FontWeight.w600, color: primary),
      titleLarge: GoogleFonts.nunito(
          fontSize: 18, fontWeight: FontWeight.w700, color: primary),
      titleMedium: GoogleFonts.nunito(
          fontSize: 16, fontWeight: FontWeight.w600, color: primary),
      titleSmall: GoogleFonts.nunito(
          fontSize: 14, fontWeight: FontWeight.w600, color: secondary),
      bodyLarge: GoogleFonts.nunito(
          fontSize: 16, fontWeight: FontWeight.w400, color: primary),
      bodyMedium: GoogleFonts.nunito(
          fontSize: 14, fontWeight: FontWeight.w400, color: primary),
      bodySmall: GoogleFonts.nunito(
          fontSize: 12, fontWeight: FontWeight.w400, color: secondary),
      labelLarge: GoogleFonts.nunito(
          fontSize: 14, fontWeight: FontWeight.w700, color: primary),
      labelMedium: GoogleFonts.nunito(
          fontSize: 12, fontWeight: FontWeight.w600, color: secondary),
      labelSmall: GoogleFonts.nunito(
          fontSize: 10, fontWeight: FontWeight.w500, color: secondary),
    );
  }
}

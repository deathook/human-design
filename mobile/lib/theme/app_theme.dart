import 'package:flutter/material.dart';

class AppTheme {
  // Bảng màu huyền bí phong cách Tử Vi - Thần Số Học Á Đông kết hợp Phương Tây
  static const Color background = Color(0xFF0C0D14);
  static const Color surface = Color(0xFF141724);
  static const Color surfaceLight = Color(0xFF1E2235);
  static const Color cardBg = Color(0xFF181B2B);

  // Vàng Hoàng Kim / Cosmic Gold
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFFFDF73);
  static const Color goldDark = Color(0xFFAA771C);

  // Điểm nhấn năng lượng
  static const Color redDesign = Color(0xFFE63946); // Vô thức (Đỏ)
  static const Color yellowPersonality = Color(0xFFFFB703); // Ý thức (Vàng)
  static const Color purpleMystic = Color(0xFF9D4EDD);
  static const Color cyanCosmic = Color(0xFF00B4D8);
  static const Color emeraldActive = Color(0xFF2EC4B6);

  // Màu chữ
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFDF73), Color(0xFFD4AF37), Color(0xFFAA771C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1A1D2E), Color(0xFF121422)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient mysticalGradient = LinearGradient(
    colors: [Color(0xFF2C1B4D), Color(0xFF121422)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: gold,
      colorScheme: const ColorScheme.dark(
        primary: gold,
        secondary: goldLight,
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: goldLight,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: goldLight),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: gold,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 12,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: TextStyle(fontSize: 10),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF2D324D), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: const Color(0xFF0C0D14),
          elevation: 6,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 24),
        titleLarge: TextStyle(color: goldLight, fontWeight: FontWeight.bold, fontSize: 18),
        titleMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w600, fontSize: 15),
        bodyMedium: TextStyle(color: textSecondary, fontSize: 13, height: 1.5),
        bodySmall: TextStyle(color: textMuted, fontSize: 12),
      ),
    );
  }
}

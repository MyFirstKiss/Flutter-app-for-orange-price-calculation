import 'package:flutter/material.dart';

class AppTheme {
  // Colors - Modern Orange Palette
  static const Color primaryColor = Color(0xFFFF6B35); // Vibrant Orange
  static const Color primaryDark = Color(0xFFE5583F);
  static const Color primaryLight = Color(0xFFFF8C5A);
  static const Color secondaryColor = Color(0xFFFFA94D);
  static const Color tertiaryColor = Color(0xFFFFD93D);
  
  static const Color accentColor = Color(0xFF4ECDC4); // Modern Teal
  static const Color accentDark = Color(0xFF3DBDB3);
  static const Color accentLight = Color(0xFF7DDFDB);
  
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color cardBackground = Colors.white;
  static const Color surfaceColor = Color(0xFFFFFAF5);
  static const Color dividerColor = Color(0xFFE8EDF2);
  
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF64748B);
  static const Color textDisabled = Color(0xFF94A3B8);
  
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color infoColor = Color(0xFF3B82F6);
  
  // Gradients - Modern & Vibrant
  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFFF6B35), Color(0xFFFFD93D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFFF6B35), Color(0xFFFFA94D), Color(0xFFFFD93D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient tealGradient = LinearGradient(
    colors: [Color(0xFF4ECDC4), Color(0xFF44A8A0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFFB06AB3), Color(0xFF4568DC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFAF5), Colors.white],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Color(0x40FFFFFF),
      Color(0x20FFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0;
  static const double spacingL = 16.0;
  static const double spacingXL = 24.0;
  static const double spacingXXL = 32.0;
  
  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusFull = 999.0;
  
  // Font Sizes
  static const double fontSizeXS = 11.0;
  static const double fontSizeS = 12.0;
  static const double fontSizeM = 14.0;
  static const double fontSizeL = 16.0;
  static const double fontSizeXL = 18.0;
  static const double fontSize2XL = 20.0;
  static const double fontSize3XL = 24.0;
  static const double fontSize4XL = 30.0;
  static const double fontSize5XL = 36.0;
  static const double fontSize6XL = 48.0;
  
  // Shadows - Modern & Soft
  static List<BoxShadow> get shadowSM => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];
  
  static List<BoxShadow> get shadowMD => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
      spreadRadius: -2,
    ),
  ];
  
  static List<BoxShadow> get shadowLG => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 24,
      offset: const Offset(0, 8),
      spreadRadius: -4,
    ),
  ];
  
  static List<BoxShadow> get shadowXL => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      blurRadius: 40,
      offset: const Offset(0, 12),
      spreadRadius: -6,
    ),
  ];
  
  static List<BoxShadow> shadowColored(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.25),
      blurRadius: 20,
      offset: const Offset(0, 8),
      spreadRadius: -2,
    ),
  ];
  
  static List<BoxShadow> get glowOrange => [
    BoxShadow(
      color: primaryColor.withValues(alpha: 0.3),
      blurRadius: 24,
      offset: const Offset(0, 0),
      spreadRadius: 0,
    ),
  ];
  
  static List<BoxShadow> get glowTeal => [
    BoxShadow(
      color: accentColor.withValues(alpha: 0.3),
      blurRadius: 24,
      offset: const Offset(0, 0),
      spreadRadius: 0,
    ),
  ];
  
  // Text Styles
  static const TextStyle heading1 = TextStyle(
    fontSize: fontSize4XL,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: fontSize3XL,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: fontSize2XL,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: fontSizeL,
    color: textPrimary,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: fontSizeM,
    color: textSecondary,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: fontSizeS,
    color: textTertiary,
  );
  
  static const TextStyle label = TextStyle(
    fontSize: fontSizeM,
    fontWeight: FontWeight.w600,
    color: textSecondary,
  );
  
  // Button Styles
  static ButtonStyle get primaryButton => ElevatedButton.styleFrom(
    backgroundColor: accentColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: spacingL, horizontal: spacingXL),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusM),
    ),
    elevation: 5,
    shadowColor: accentColor.withValues(alpha: 0.3),
  );
  
  static ButtonStyle get secondaryButton => OutlinedButton.styleFrom(
    foregroundColor: textSecondary,
    padding: const EdgeInsets.symmetric(vertical: spacingL, horizontal: spacingXL),
    side: const BorderSide(color: dividerColor, width: 2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusM),
    ),
  );
  
  // Card Decoration
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: cardBackground,
    borderRadius: BorderRadius.circular(radiusM),
    border: Border.all(color: dividerColor),
    boxShadow: shadowMD,
  );
  
  static BoxDecoration cardDecorationWithGradient(LinearGradient gradient) => BoxDecoration(
    gradient: gradient,
    borderRadius: BorderRadius.circular(radiusM),
    border: Border.all(color: dividerColor),
    boxShadow: shadowMD,
  );
  
  // Input Decoration
  static InputDecoration inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusM),
      borderSide: const BorderSide(color: dividerColor, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusM),
      borderSide: const BorderSide(color: dividerColor, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusM),
      borderSide: const BorderSide(color: accentColor, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: spacingL,
      vertical: spacingL,
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Color constants used in the app.
class AppColors {
  // Primary ARMM colors
  static const primary = Color(0xFF1C32A4); // Primary ARMM Blue
  static const primaryDark = Color(0xFF1E4B89); // Darker blue variant
  static const primaryLight = Color(0xFF3199DD); // Lighter blue variant
  
  // White and Gray scale
  static const defaultWhite = Color(0xFFFFFFFF);
  static const defaultGray50 = Color(0xFFF9FAFB);
  static const defaultGray100 = Color(0xFFF3F4F6);
  static const defaultGray200 = Color(0xFFE5E7EB);
  static const defaultGray500 = Color(0xFF6B7280);
  static const defaultGray700 = Color(0xFF373F51);
  static const defaultGray800 = Color(0xFF1F2937);

  // Green shades
  static const defaultGreen100 = Color(0xFFD1FAE5);
  static const defaultGreen200 = Color(0xFFA7F3D0);
  static const defaultGreen400 = Color(0xFF34D399);
  static const green = Color(0xFF2F862F);

  // Red shades
  static const defaultRed100 = Color(0xFFFEF2F2);
  static const defaultRed200 = Color(0xFFFECACA);
  static const defaultRed400 = Color(0xFFF87171);
  static const red = Color(0xFF951C1C);

  // Yellow shades
  static const defaultYellow400 = Color(0xFFFBBD24);
  static const yellow = Color(0xFFDBC33C);

  // Blue shades
  static const defaultBlue500 = Color(0xFF0D5EAF);
  static const defaultBlue300 = Color(0xFF3199DD);
  static const defaultBlue100 = Color(0xFFD3EEFF);

  // Blue Gray shades
  static const defaultBlueGray900 = Color(0xFF111827);
  static const defaultBlueGray800 = Color(0xFF1E293B);
  static const defaultBlueGray700 = Color(0xFF334155);
  static const defaultBlueGray600 = Color(0xFF475569);
  static const defaultBlueGray500 = Color(0xFF64748B);
  static const defaultBlueGray400 = Color(0xFF94A3B8);
  static const defaultBlueGray300 = Color(0xFFCBD5E1);
  static const defaultBlueGray200 = Color(0xFFE2E8F0);
  static const defaultBlueGray100 = Color(0xFFF1F5F9);

  // Emerald shades
  static const extendedEmerald200 = Color(0xFFA7F3D0);
  static const extendedEmerald400 = Color(0xFF34D399);
  static const extendedEmerald600 = Color(0xFF059669);
  static const extendedEmerald800 = Color(0xFF065F46);

  // Indigo shades
  static const extendedIndigo50 = Color(0xFFEEF2FF);
  static const extendedIndigo200 = Color(0xFFC7D2FE);
  static const extendedIndigo400 = Color(0xFF818CF8);
  static const extendedIndigo800 = Color(0xFF3730A3);

  // Additional colors from constants.dart (adjusted names to avoid conflicts)
  static const altBlue500 = Color(0xFF1E4B89);
  static const altBlue300 = Color(0xFF9DBBE6);
  static const altBlueGray800 = Color(0xFF374151);
  static const altBlueGray900 = Color(0xFF1F2937);
  static const gray = Color(0xFF7A7A7A);
  static const grayDark = Color(0xFF555657);
}

/// Text style constants used in the app.
class AppTextStyles {
  // Display text styles
  static TextStyle display({Color? color}) => GoogleFonts.inter(
        fontWeight: FontWeight.bold,
        fontSize: 32.0,
        color: color,
      );
  
  // Original text styles
  static TextStyle xl3({Color? color}) => GoogleFonts.inter(
        fontWeight: FontWeight.bold,
        fontSize: 28.0,
        color: color,
      );

  static TextStyle xl2({Color? color}) => GoogleFonts.inter(
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
        color: color,
      );

  static TextStyle xl({Color? color}) => GoogleFonts.inter(
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
        color: color,
      );

  static TextStyle lBold({Color? color}) => GoogleFonts.inter(
        fontWeight: FontWeight.bold,
        fontSize: 18.0,
        color: color,
      );

  static TextStyle lRegular({Color? color}) => GoogleFonts.inter(
        fontWeight: FontWeight.normal,
        fontSize: 18.0,
        color: color,
      );

  static TextStyle mBold({Color? color}) => GoogleFonts.inter(
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
        color: color,
      );

  static TextStyle mSemiBold({Color? color}) => GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 16.0,
        color: color,
      );

  static TextStyle mRegular({Color? color}) => GoogleFonts.inter(
        fontWeight: FontWeight.normal,
        fontSize: 16.0,
        color: color,
      );

  static TextStyle sBold({Color? color}) => GoogleFonts.inter(
        fontWeight: FontWeight.bold,
        fontSize: 15.0,
        color: color,
      );

  static TextStyle sRegular({Color? color}) => GoogleFonts.inter(
        fontWeight: FontWeight.normal,
        fontSize: 15.0,
        color: color,
      );

  static TextStyle xsBold({Color? color}) => GoogleFonts.inter(
        fontWeight: FontWeight.bold,
        fontSize: 14.0,
        color: color,
      );

  static TextStyle sSemiBold({Color? color}) => GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 14.0,
        color: color,
      );

  static TextStyle xsRegular({Color? color}) => GoogleFonts.inter(
        fontWeight: FontWeight.normal,
        fontSize: 14.0,
        color: color,
      );

  static TextStyle xs2Bold({Color? color}) => GoogleFonts.inter(
        fontWeight: FontWeight.bold,
        fontSize: 12.0,
        color: color,
      );

  static TextStyle xs2Regular({Color? color}) => GoogleFonts.inter(
        fontWeight: FontWeight.normal,
        fontSize: 12.0,
        color: color,
      );

  // Additional styles from styles.dart
  static TextStyle headerText({Color? color}) => GoogleFonts.inter(
        fontSize: 26,
        color: color ?? Colors.white,
        fontWeight: FontWeight.bold,
      );

  static TextStyle inputText({Color? color}) => GoogleFonts.inter(
        fontSize: 16,
        color: color ?? Colors.white,
      );

  static TextStyle orText({Color? color}) => GoogleFonts.inter(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: color ?? Colors.white,
      );

  static TextStyle validationText({Color? color}) => GoogleFonts.inter(
        fontSize: 16,
        color: color ?? Colors.white,
      );

  static TextStyle nextButtonText({Color? color}) => GoogleFonts.inter(
        fontSize: 18,
        color: color ?? Colors.white,
        fontWeight: FontWeight.bold,
      );

  static TextStyle bodyText({Color? color}) => GoogleFonts.inter(
        fontSize: 18,
        color: color ?? Colors.white,
      );

  static TextStyle loginText({Color? color}) => GoogleFonts.inter(
        fontSize: 18,
        color: color ?? AppColors.primary,
        fontWeight: FontWeight.bold,
      );

  static TextStyle dialogTitleText({Color? color}) => GoogleFonts.inter(
        fontSize: 20,
        color: color ?? Colors.white,
        fontWeight: FontWeight.bold,
      );

  static TextStyle dialogBodyText({Color? color}) => GoogleFonts.inter(
        fontSize: 16,
        color: color ?? Colors.white,
      );

  static TextStyle buttonText({Color? color}) => GoogleFonts.inter(
        fontSize: 18,
        color: color ?? AppColors.primary,
        fontWeight: FontWeight.bold,
      );
}

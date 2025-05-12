import 'package:flutter/material.dart';
import 'color_palette.dart';

class AppFonts {
  static const String primaryFont = 'Poppins';

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const TextStyle bodyText = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textDarker,
  );

  static const TextStyle smallLabel = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    color: AppColors.textGrey,
  );
}

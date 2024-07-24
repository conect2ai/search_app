import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  static final mainTextStyle = GoogleFonts.roboto(
      textStyle: const TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400));
  static final authScreenButtonsTextStyle = GoogleFonts.roboto(
      textStyle: const TextStyle(
          color: Colors.white, fontSize: 17, fontWeight: FontWeight.w400));
  static final authScreenTitleTextStyle = GoogleFonts.roboto(
      textStyle: const TextStyle(
          color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600));
  static final authScreenSubtitleTextStyle = GoogleFonts.roboto(
      textStyle: const TextStyle(
          color: Colors.white, fontSize: 17, fontWeight: FontWeight.w400));
  static final errorTravelHistoryScreenTextStyle = GoogleFonts.roboto(
      textStyle: const TextStyle(color: Colors.white, fontSize: 18));
  static final appBarTitleTextStyle = GoogleFonts.roboto(
      textStyle: const TextStyle(color: Colors.white, fontSize: 21));
  static final dialogtextStyle = GoogleFonts.roboto(
      textStyle: const TextStyle(color: Colors.white, fontSize: 18));
  static final dialogSecondaryTextStyle = GoogleFonts.roboto(
      textStyle: const TextStyle(color: Colors.white, fontSize: 12));
  static final dialogOptionsextStyle = GoogleFonts.roboto(
      textStyle: const TextStyle(color: AppColors.mainColor, fontSize: 16));
  static final buttonsTextStyle = GoogleFonts.roboto(
      textStyle: const TextStyle(color: Colors.white, fontSize: 18));
  static final buttonsLabelTextStyle = GoogleFonts.roboto(
      textStyle: const TextStyle(color: Colors.white, fontSize: 22));
  static final textFieldTextStyle = GoogleFonts.roboto(
      textStyle: const TextStyle(color: Colors.white, fontSize: 14));
  static final deviceConnectedTextStyle = GoogleFonts.roboto(
      textStyle: const TextStyle(
    color: Colors.green,
    fontSize: 20,
  ));
}

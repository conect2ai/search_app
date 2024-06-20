import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  static const mainTextStyle = TextStyle(fontSize: 24);
  static const dialogTextStyle = TextStyle(fontSize: 22);
  static const authScreenButtonsTextStyle =
      TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w400);
  static const authScreenTitleTextStyle = TextStyle(
      color: AppColors.mainColor, fontSize: 25, fontWeight: FontWeight.w600);
  static const authScreenSubtitleTextStyle = TextStyle(
      color: Colors.black87, fontSize: 17, fontWeight: FontWeight.w400);
  static const chatMessageTextStyle = TextStyle(
    fontSize: 16,
  );
  static const dialogTextButtonStyle = TextStyle(fontSize: 18);
  static const buttonsTextStyle = TextStyle(color: Colors.white, fontSize: 18);
  static const buttonsLabelTextStyle =
      TextStyle(color: Colors.white, fontSize: 22);
  static const textFieldTextStyle =
      TextStyle(color: AppColors.mainColor, fontSize: 14);
  static const deactivatedDialogTextButtonStyle =
      TextStyle(fontSize: 18, color: Colors.grey);
}

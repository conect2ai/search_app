import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../themes/app_text_styles.dart';

mixin CustomAppbar {
  AppBar generateCustomAppBar([String? title]) {
    final appBar = AppBar(
      leading: title != null
          ? Container(
              margin: const EdgeInsets.only(left: 20, right: 10),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              child: IconButton(
                  color: Colors.black,
                  iconSize: 14,
                  onPressed: () => Modular.to.pop(),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                  )),
            )
          : null,
      title: title != null
          ? Text(
              title,
              style: AppTextStyles.appBarTitleTextStyle,
            )
          : Image.asset(
              'assets/images/main_logo_white.png',
              width: 200,
            ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );

    return appBar;
  }
}

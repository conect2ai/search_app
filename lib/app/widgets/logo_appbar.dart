import 'package:flutter/material.dart';

mixin LogoAppBar {
  AppBar generateLogoAppBar(BuildContext context, [List<Widget>? actions]) {
    return AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey,
        shadowColor: const Color(0xFF00AAD0),
        toolbarHeight: 75,
        title: Image.asset(
          'assets/images/main_logo.png',
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width * 0.8,
        ),
        actions: actions);
  }
}

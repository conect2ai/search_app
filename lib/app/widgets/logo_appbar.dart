import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LogoAppBar {
  static generateLogoAppBar(BuildContext context, [Function? onLogoutPress]) {
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
        actions: _generateLogoutButton(onLogoutPress));
  }

  static List<Widget>? _generateLogoutButton(Function? onLogoutPress) {
    if (onLogoutPress != null) {
      return [
        IconButton(
            onPressed: () {
              onLogoutPress();

              Modular.to.navigate(
                '/',
              );
            },
            icon: const Icon(
              Icons.logout_rounded,
            )),
      ];
    } else {
      return null;
    }
  }
}

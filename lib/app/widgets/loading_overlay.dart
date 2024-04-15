import 'package:flutter/material.dart';

import '../core/themes/app_colors.dart';

class LoadingOverlay {
  OverlayEntry? _overlay;

  LoadingOverlay();

  void showOverlay(BuildContext context) {
    if (_overlay == null) {
      _overlay = OverlayEntry(
        builder: (context) => const ColoredBox(
          color: Color(0x80000000),
          child: Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(
                  AppColors.mainColor,
                ),
              ),
            ),
          ),
        ),
      );
      Overlay.of(context).insert(_overlay!);
    }
  }

  void hideOverlay() {
    if (_overlay != null) {
      _overlay?.remove();
      _overlay = null;
    }
  }
}

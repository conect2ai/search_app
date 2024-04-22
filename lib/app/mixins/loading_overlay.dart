import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../core/themes/app_colors.dart';

mixin LoadingOverlay {
  OverlayEntry? _overlay;

  // LoadingOverlay();

  void showOverlay(BuildContext context) {
    if (_overlay == null) {
      _overlay = OverlayEntry(
        builder: (context) => const ColoredBox(
          color: Color(0x80000000),
          child: Center(
            child: SpinKitSpinningLines(
              size: 100,
              color: AppColors.mainColor,
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

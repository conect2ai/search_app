import 'package:app_search/extensions/context_extansion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../core/themes/app_text_styles.dart';
import '../../view_models/logout_button_viewmodel.dart';

class LogoutButton extends StatelessWidget {
  final _viewModel = Modular.get<LogoutButtonViewModel>();
  LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: () => _viewModel.logout(),
        icon: const Icon(
          Icons.logout,
          color: Colors.white,
        ),
        label: Text(
          context.localizations.logout,
          style: AppTextStyles.logoutButtonTextStyle,
        ));
  }
}

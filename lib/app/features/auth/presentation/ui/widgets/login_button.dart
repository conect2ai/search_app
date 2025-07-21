import 'package:app_search/extensions/context_extansion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/themes/app_text_styles.dart';
import '../../view_models/login_viewmodel.dart';

class LoginButton extends StatelessWidget {
  final Function _submit;
  final _viewModel = Modular.get<LoginViewModel>();
  LoginButton({required Function submit, super.key}) : _submit = submit;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return Container(
      width: screenWidth * 0.9,
      height: 65,
      decoration: BoxDecoration(
          color: AppColors.mainColor, borderRadius: BorderRadius.circular(10)),
      child: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          return ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.mainColor),
            onPressed: () {
              if (_viewModel.isLoginButtonEnabled) {
                _submit();
              }
            },
            child: ListenableBuilder(
              listenable: _viewModel,
              builder: (context, child) {
                return _viewModel.isButtonLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        context.localizations.login,
                        style: AppTextStyles.authScreenButtonsTextStyle,
                      );
              },
            ),
          );
        },
      ),
    );
  }
}

import 'dart:ui';

import 'package:app_search/extensions/context_extansion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/themes/app_text_styles.dart';
import '../../../../../mixins/snackbar_mixin.dart';
import '../../../domain/exceptions/invalid_credentials_exceptiion.dart';
import '../../view_models/login_viewmodel.dart';
import 'login_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with SnackBarMixin {
  final _usernameTextController = TextEditingController();

  final _passwordTextController = TextEditingController();

  bool _isPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();

  final _viewModel = Modular.get<LoginViewModel>();

  void _sendLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final credentials = {
      'username': _usernameTextController.text.trim(),
      'password': _passwordTextController.text.trim(),
    };
    try {
      await _viewModel.login(credentials).then((_) {
        Modular.to.navigate("/api-key/?provider=openai");
      });
    } on InvalidCredentialsException catch (_) {
      if (!mounted) return;
      generateSnackBar(context.localizations.failedCredentials, context);
    } catch (e) {
      if (!mounted) return;
      generateSnackBar(context.localizations.serverException, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Login',
            style: AppTextStyles.authScreenTitleTextStyle,
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 80,
            child: TextFormField(
              selectionHeightStyle: BoxHeightStyle.strut,
              controller: _usernameTextController,
              keyboardType: TextInputType.text,
              style: AppTextStyles.textFieldTextStyle,
              textAlignVertical: TextAlignVertical.center,
              cursorColor: AppColors.mainColor,
              decoration: InputDecoration(
                hintText: context.localizations.username,
                hintStyle: const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: AppColors.mainColor,
                ),
                constraints: BoxConstraints.tight(
                    Size(MediaQuery.of(context).size.width * 0.9, 120)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.mainColor)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.mainColor)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.mainColor),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.localizations.usernameRequired;
                }
                return null;
              },
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 80,
            child: TextFormField(
              obscureText: !_isPasswordVisible,
              selectionHeightStyle: BoxHeightStyle.strut,
              controller: _passwordTextController,
              keyboardType: TextInputType.emailAddress,
              style: AppTextStyles.textFieldTextStyle,
              textAlignVertical: TextAlignVertical.center,
              cursorColor: AppColors.mainColor,
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    child: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.white,
                    )),
                hintText: context.localizations.password,
                hintStyle: const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.mainColor,
                ),
                constraints: BoxConstraints.tight(
                    Size(MediaQuery.of(context).size.width * 0.9, 120)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.mainColor)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.mainColor)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.mainColor),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.localizations.passwordRequired;
                }
                return null;
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: TextButton(
                onPressed: () =>
                    Modular.to.pushReplacementNamed('/auth/recover-password'),
                child: Text(
                  context.localizations.forgotPassword,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          LoginButton(
            submit: _sendLogin,
          ),
        ],
      ),
    );
  }
}

import 'dart:io';
import 'dart:ui';

import 'package:app_search/extensions/context_extansion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../mixins/snackbar_mixin.dart';
import '../../interactor/bloc/auth_bloc.dart';
import '../../interactor/events/auth_event.dart';

class LoginForm extends StatefulWidget {
  final String? username;
  final String? password;
  LoginForm({this.username, this.password, super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with SnackBarMixin {
  final _authBloc = Modular.get<AuthBloc>();
  final Map<String, String> _formData = {};
  bool _isPasswordVisible = false;
  final _passwordFocusNode = FocusNode();
  final _usernameFocusNode = FocusNode();

  final _passwordTextController = TextEditingController();
  final _usernameTextController = TextEditingController();

  @override
  void initState() {
    _passwordTextController.text = widget.password ?? '';
    _usernameTextController.text = widget.username ?? '';
    _formData['username'] = _usernameTextController.text;
    _formData['password'] = _passwordTextController.text;
    super.initState();
  }

  void _saveFormData() async {
    _formData['username'] = _usernameTextController.text;
    _formData['password'] = _passwordTextController.text;

    try {
      await _authBloc
          .login(_formData)
          .then((_) => Modular.to.pushReplacementNamed('/home/'));
    } on HttpException catch (_) {
      if (!mounted) {
        return;
      }
      generateSnackBar(context.localizations.failedCredentials, context);
    } catch (_) {
      if (!mounted) {
        return;
      }
      generateSnackBar(context.localizations.erroLogin, context);
    }
  }

  void _unfocusAllTextFields() {
    if (_passwordFocusNode.hasFocus) {
      _passwordFocusNode.unfocus();
    }
    if (_usernameFocusNode.hasFocus) {
      _usernameFocusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: SingleChildScrollView(
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
              child: TextField(
                selectionHeightStyle: BoxHeightStyle.strut,
                controller: _usernameTextController,
                keyboardType: TextInputType.emailAddress,
                textAlignVertical: TextAlignVertical.center,
                cursorColor: AppColors.mainColor,
                decoration: InputDecoration(
                  hintText: context.localizations.username,
                  hintStyle: const TextStyle(
                      fontSize: 17,
                      color: AppColors.mainColor,
                      fontWeight: FontWeight.w400),
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: AppColors.mainColor,
                  ),
                  constraints: BoxConstraints.tight(
                      Size(MediaQuery.of(context).size.width * 0.8, 120)),
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
              ),
            ),
            SizedBox(
              height: 60,
              child: TextField(
                obscureText: !_isPasswordVisible,
                selectionHeightStyle: BoxHeightStyle.strut,
                controller: _passwordTextController,
                keyboardType: TextInputType.emailAddress,
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
                        color: AppColors.mainColor,
                      )),
                  hintText: context.localizations.password,
                  hintStyle: const TextStyle(
                      fontSize: 17,
                      color: AppColors.mainColor,
                      fontWeight: FontWeight.w400),
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColors.mainColor,
                  ),
                  constraints: BoxConstraints.tight(
                      Size(MediaQuery.of(context).size.width * 0.8, 120)),
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
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: screenWidth * 0.8,
              height: 65,
              decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(10)),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor),
                onPressed: _saveFormData,
                child: const Text(
                  'Login',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                _unfocusAllTextFields();
                _authBloc.add(SwitchToSignUpEvent());
              },
              child: RichText(
                text: TextSpan(
                    text: context.localizations.dontHaveAccountYet,
                    style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                        color: AppColors.mainColor),
                    children: [
                      TextSpan(
                          text: context.localizations.registerYourself,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: AppColors.mainColor))
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

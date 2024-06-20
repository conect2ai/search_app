import 'dart:io';
import 'dart:ui';

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
  const LoginForm({this.username, this.password, super.key});

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
      generateSnackBar('Login failed. Try again.', context);
    } catch (_) {
      if (!mounted) {
        return;
      }
      generateSnackBar('Login failed. Try again.', context);
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
            const Text(
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
                  hintText: 'Usuário',
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
                  hintText: 'Senha',
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
            // Align(
            //   alignment: Alignment.topRight,
            //   child: Padding(
            //     padding: const EdgeInsets.only(right: 15),
            //     child: TextButton(
            //       onPressed: () =>
            //           Modular.to.pushReplacementNamed('/recover-password/'),
            //       child: const Text(
            //         'Esqueceu a senha?',
            //         style: TextStyle(
            //             fontWeight: FontWeight.w500,
            //             fontSize: 15,
            //             color: Colors.white),
            //       ),
            //     ),
            //   ),
            // ),
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
                  'Entrar',
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
                text: const TextSpan(
                    text: 'Não tem uma conta? ',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                        color: AppColors.mainColor),
                    children: [
                      TextSpan(
                          text: 'Cadastre-se',
                          style: TextStyle(
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

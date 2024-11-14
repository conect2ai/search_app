import 'dart:io';
import 'dart:ui';

import 'package:app_search/extensions/context_extansion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
// import 'package:loader_overlay/loader_overlay.dart';

import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../mixins/snackbar_mixin.dart';
import '../../home/interactor/bloc/homepage_bloc.dart';
import '../interactor/bloc/auth_bloc.dart';
import '../interactor/bloc/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with CustomAppbar, SnackBarMixin {
  final _authBloc = Modular.get<AuthBloc>();
  final _loginBloc = Modular.get<LoginBloc>();
  final _homeBloc = Modular.get<HomePageBloc>();

  String? _apiKey;

  final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    _loginBloc.initSubjects();
    super.initState();
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  void _sendLogin() async {
    FocusScope.of(context).unfocus();
    final userData = {
      'username': _usernameTextController.text,
      'password': _passwordTextController.text,
    };

    try {
      _loginBloc.updateLoginButton(true);
      await _authBloc.login(userData).then((_) async {
        _apiKey = await _homeBloc.checkIfUserHasKey();
        _loginBloc.updateLoginButton(false);
        _apiKey == null
            ? Modular.to.pushReplacementNamed('/home/')
            : Modular.to.pushReplacementNamed('/check-api-key/');
      });
    } on HttpException catch (e) {
      if (!mounted) {
        return;
      }
      _loginBloc.updateLoginButton(false);
      generateSnackBar(e.message, context);
    } catch (e) {
      if (!mounted) {
        return;
      }
      _loginBloc.updateLoginButton(false);
      generateSnackBar(context.localizations.erroLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: generateCustomAppBar(),
      body: Center(
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
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.mainColor)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.mainColor)),
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
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.mainColor)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.mainColor)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.mainColor),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: TextButton(
                    onPressed: () => Modular.to
                        .pushReplacementNamed('/auth/recover-password'),
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
              Container(
                width: screenWidth * 0.9,
                height: 65,
                decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(10)),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor),
                  onPressed: _sendLogin,
                  child: StreamBuilder<bool>(
                    stream: _loginBloc.isTryingLogin,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final isTryingLogin = snapshot.data!;
                        if (isTryingLogin) {
                          return const CircularProgressIndicator(
                              color: Colors.white);
                        } else {
                          return Text(
                            'Login',
                            style: AppTextStyles.authScreenButtonsTextStyle,
                          );
                        }
                      } else {
                        return Text(
                          'Login',
                          style: AppTextStyles.authScreenButtonsTextStyle,
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () =>
                    Modular.to.pushReplacementNamed('/auth/sign-up'),
                child: RichText(
                  text: TextSpan(
                      text: context.localizations.dontHaveAccountYet,
                      style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                          color: Colors.white),
                      children: [
                        TextSpan(
                            text: context.localizations.registerYourself,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.white))
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

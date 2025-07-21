import 'package:app_search/extensions/context_extansion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/widgets/custom_appbar.dart';
import '../../../../mixins/snackbar_mixin.dart';
import 'widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with CustomAppbar, SnackBarMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generateCustomAppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const LoginForm(),
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

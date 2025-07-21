import 'dart:io';
import 'dart:ui';

import 'package:app_search/extensions/context_extansion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../mixins/snackbar_mixin.dart';
import '../../domain/exceptions/signup_failure_exception.dart';
import '../view_models/signup_viewmodel.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with CustomAppbar, SnackBarMixin {
  final _viewModel = Modular.get<SignUpViewModel>();
  final _emailTextController = TextEditingController();

  void _sendSignUp() async {
    FocusScope.of(context).unfocus();
    try {
      await _viewModel.signUp(_emailTextController.text.trim()).then((_) {
        generateSnackBar(context.localizations.emailSentSuccess, context);
      });
    } on SignUpFailureException catch (_) {
      if (!mounted) {
        return;
      }
      generateSnackBar(context.localizations.emailSentFailed, context);
    } catch (e) {
      if (!mounted) {
        return;
      }
      generateSnackBar(context.localizations.serverException, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: generateCustomAppBar(),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 160,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 103,
                      height: 103,
                      child: CircleAvatar(
                        backgroundColor: AppColors.mainColor,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      context.localizations.createAccount,
                      style: AppTextStyles.authScreenTitleTextStyle,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 300,
                      child: Text(
                        context.localizations.signUpMainText,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.authScreenSubtitleTextStyle,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 80,
                            child: TextField(
                              selectionHeightStyle: BoxHeightStyle.strut,
                              controller: _emailTextController,
                              keyboardType: TextInputType.emailAddress,
                              style: AppTextStyles.textFieldTextStyle,
                              textAlignVertical: TextAlignVertical.center,
                              cursorColor: AppColors.mainColor,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  color: AppColors.mainColor,
                                ),
                                constraints: BoxConstraints.tight(Size(
                                    MediaQuery.of(context).size.width * 0.9,
                                    120)),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 15),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: AppColors.mainColor)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: AppColors.mainColor)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: AppColors.mainColor),
                                ),
                              ),
                            ),
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
                                onPressed: _sendSignUp,
                                child: Text(
                                  context.localizations.signUp,
                                  style:
                                      AppTextStyles.authScreenButtonsTextStyle,
                                )),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 10,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TextButton(
                          onPressed: () =>
                              Modular.to.pushReplacementNamed('/auth/login'),
                          child: RichText(
                            text: TextSpan(
                                text: context.localizations.returnTo,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15,
                                    color: Colors.white),
                                children: const [
                                  TextSpan(
                                      text: 'Login',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color: Colors.white))
                                ]),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

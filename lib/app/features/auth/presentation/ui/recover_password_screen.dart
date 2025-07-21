import 'dart:io';
import 'dart:ui';

import 'package:app_search/extensions/context_extansion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../mixins/snackbar_mixin.dart';
import '../view_models/recover_password_viewmodel.dart';

class RecoverPasswordScreen extends StatefulWidget {
  const RecoverPasswordScreen({super.key});

  @override
  State<RecoverPasswordScreen> createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen>
    with CustomAppbar, SnackBarMixin {
  final _viewModel = Modular.get<RecoverPasswordViewModel>();
  final _emailTextController = TextEditingController();

  void _sendRecoverPassword() async {
    try {
      await _viewModel
          .recoverPassword(_emailTextController.text.trim())
          .then((_) {
        generateSnackBar(context.localizations.emailSentSuccess, context);
      });
    } on HttpException catch (e) {
      if (!mounted) {
        return;
      }
      generateSnackBar(e.message, context);
    } catch (e) {
      if (!mounted) {
        return;
      }
      generateSnackBar(context.localizations.emailSentFailed, context);
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
                    SizedBox(
                      height: 120,
                      width: 160,
                      child: Image.asset(
                        'assets/images/recover_password_screen_logo.png',
                        alignment: Alignment.center,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      context.localizations.recoverPasswordTitle,
                      style: AppTextStyles.authScreenTitleTextStyle,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 300,
                      child: Text(
                        context.localizations.recoverPasswordInfo,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.authScreenSubtitleTextStyle,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                              MediaQuery.of(context).size.width * 0.9, 120)),
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
                            borderSide:
                                const BorderSide(color: AppColors.mainColor),
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
                          onPressed: _sendRecoverPassword,
                          child: Text(
                            context.localizations.send,
                            style: AppTextStyles.authScreenButtonsTextStyle,
                          )),
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

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../mixins/snackbar_mixin.dart';
import '../interactor/bloc/auth_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with CustomAppbar, SnackBarMixin {
  final _authBloc = Modular.get<AuthBloc>();
  final _emailTextController = TextEditingController();

  void _sendSignUp() async {
    FocusScope.of(context).unfocus();
    try {
      await _authBloc.signUp(_emailTextController.text).then((_) {
        generateSnackBar('E-mail enviado com sucesso!', context);
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
      generateSnackBar(
          'Erro ao tentar enviar e-mail. Tente novamente.', context);
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
                      'Criar Conta',
                      style: AppTextStyles.authScreenTitleTextStyle,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 300,
                      child: Text(
                        'Digite seu email e você será redirecionado para completar o cadastro.',
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
                          onPressed: _sendSignUp,
                          child: Text(
                            'Cadastro',
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
                            text: const TextSpan(
                                text: 'Retornar para o ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15,
                                    color: Colors.white),
                                children: [
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

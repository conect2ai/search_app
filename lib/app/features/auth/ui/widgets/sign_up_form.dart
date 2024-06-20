import 'dart:io';
import 'dart:ui';

import 'package:app_search/app/features/auth/interactor/events/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../mixins/logo_appbar.dart';
import '../../../../mixins/snackbar_mixin.dart';
import '../../interactor/bloc/auth_bloc.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SingUpFormState();
}

class _SingUpFormState extends State<SignUpForm>
    with SnackBarMixin, LogoAppBar {
  final _authBloc = Modular.get<AuthBloc>();
  final _emailTextController = TextEditingController();
  final _emailFocusNode = FocusNode();

  void _sendSignUp() async {
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

  void _unfocusAllTextFields() {
    if (_emailFocusNode.hasFocus) {
      _emailFocusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
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
                  const Text(
                    'Criar Conta',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    width: 300,
                    child: Text(
                      'Digite seu email e você será redirecionado para completar o cadastro.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 80,
                    child: TextField(
                      focusNode: _emailFocusNode,
                      selectionHeightStyle: BoxHeightStyle.strut,
                      controller: _emailTextController,
                      keyboardType: TextInputType.emailAddress,
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
                        constraints: BoxConstraints.tight(
                            Size(MediaQuery.of(context).size.width * 0.8, 120)),
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
                    width: screenWidth * 0.8,
                    height: 65,
                    decoration: BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainColor),
                        onPressed: _sendSignUp,
                        child: const Text(
                          'Cadastro',
                        )),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.mainColor,
                        size: 10,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      TextButton(
                        onPressed: () {
                          _unfocusAllTextFields();
                          _authBloc.add(SwitchToLoginEvent());
                        },
                        child: RichText(
                          text: const TextSpan(
                              text: 'Retornar para o ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15,
                                  color: AppColors.mainColor),
                              children: [
                                TextSpan(
                                    text: 'Login',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: AppColors.mainColor))
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
    );
  }
}

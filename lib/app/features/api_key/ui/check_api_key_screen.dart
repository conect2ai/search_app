import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../mixins/logo_appbar.dart';
import '../../../mixins/snackbar_mixin.dart';
import '../../home/interactor/bloc/homepage_bloc.dart';

class CheckApiKeyScreen extends StatefulWidget {
  const CheckApiKeyScreen({super.key});

  @override
  State<CheckApiKeyScreen> createState() => _CheckApiKeyScreenState();
}

class _CheckApiKeyScreenState extends State<CheckApiKeyScreen>
    with LogoAppBar, SnackBarMixin {
  String? _apiKey;
  final _homeBloc = Modular.get<HomePageBloc>();

  @override
  void initState() {
    _apiKey = _homeBloc.getApiKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generateLogoAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: Text(
                  'Encontramos a chave $_apiKey. Deseja continuar com a chave atual?',
                  style: AppTextStyles.authScreenSubtitleTextStyle,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              const SizedBox(
                height: 17,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(72, 30),
                          backgroundColor: AppColors.mainColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () =>
                          Modular.to.pushReplacementNamed('/chat/'),
                      child: const Text('SIM')),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(72, 30),
                          backgroundColor: AppColors.mainColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () =>
                          Modular.to.pushReplacementNamed('/home/'),
                      child: const Text('NÃO')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

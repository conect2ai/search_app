import 'dart:io';

import 'package:app_search/extensions/context_extansion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../streams/general_stream.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../interactor/bloc/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with CustomAppbar {
  final _authBloc = Modular.get<AuthBloc>();
  bool _locale = false;
  @override
  void initState() {
    _getLanguage();
    super.initState();
  }

  Future<void> _getLanguage() async {
    final language = await _authBloc.getLanguage();
    if (language != null) {
      _locale = language == 'pt';
    } else {
      _locale = Platform.localeName == 'pt_BR';
    }
    setState(() {
      GeneralStream.languageStream.add(Locale(_locale == false ? 'en' : 'pt'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generateCustomAppBar(),
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 100,
            child: SizedBox(
                height: 283,
                width: 304,
                child: Image.asset(
                  'assets/images/auth_screen_image.png',
                  alignment: Alignment.center,
                )),
          ),
          const SizedBox(
            height: 60,
          ),
          Positioned(
            bottom: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'ManualGuru',
                  style: AppTextStyles.authScreenTitleTextStyle,
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  width: 270,
                  child: Text(
                    context.localizations.appIntroText,
                    style: AppTextStyles.authScreenSubtitleTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 140,
                  height: 49,
                  decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.mainColor)),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent),
                    onPressed: () =>
                        Modular.to.pushReplacementNamed('/auth/sign-up'),
                    child: Text(
                      context.localizations.signUp,
                      style: AppTextStyles.authScreenButtonsTextStyle,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: 140,
                  height: 49,
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.mainColor),
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor,
                    ),
                    onPressed: () =>
                        Modular.to.pushReplacementNamed('/auth/login'),
                    child: Text(
                      'Login',
                      style: AppTextStyles.authScreenButtonsTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              top: 0,
              right: 10,
              child: Row(
                children: [
                  const Text(
                    'EN',
                    style: TextStyle(color: Colors.white),
                  ),
                  Switch(
                      value: _locale,
                      activeColor: AppColors.mainColor,
                      inactiveTrackColor: Colors.grey,
                      onChanged: (value) async {
                        setState(() {
                          _locale = value;
                        });
                        final locale = Locale(_locale == false ? 'en' : 'pt');
                        await _authBloc.setLanguage(locale);
                        GeneralStream.languageStream.add(locale);
                      }),
                  const Text(
                    'PT-BR',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

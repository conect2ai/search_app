import 'package:app_search/extensions/context_extansion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../mixins/logo_appbar.dart';
import '../../../../mixins/snackbar_mixin.dart';
import '../view_models/api_key_viewmodel.dart';

class ConfirmApiKeyScreen extends StatefulWidget {
  final String? _provider;
  const ConfirmApiKeyScreen({required String provider, super.key})
      : _provider = provider;

  @override
  State<ConfirmApiKeyScreen> createState() => _ConfirmApiKeyScreenState();
}

class _ConfirmApiKeyScreenState extends State<ConfirmApiKeyScreen>
    with LogoAppBar, SnackBarMixin {
  String? _key;
  final _viewModel = Modular.get<ApiKeyViewModel>();

  @override
  void initState() {
    widget._provider == 'openai'
        ? _key = _viewModel.getOpenaiApiKey()
        : _key = _viewModel.getGoogleApiKey();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _key ??= _viewModel.getOpenaiApiKey();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _key = null;
    super.dispose();
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
              Text(
                widget._provider == 'openai'
                    ? context.localizations.openAIKey
                    : context.localizations.googleAPIKey,
                style: AppTextStyles.authScreenTitleTextStyle,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                child: Text(
                  context.localizations.foundKey(_key ?? ''),
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
                      onPressed: () async {
                        widget._provider == 'openai'
                            ? Modular.to.navigate('/menu-page/')
                            : Modular.to.pushNamed('/report-problem/');
                      },
                      child: Text(context.localizations.yes.toUpperCase())),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(72, 30),
                          backgroundColor: AppColors.mainColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () => Modular.to.pushReplacementNamed(
                          '/api-key/input_api_key?provider=${widget._provider}'),
                      child: Text(context.localizations.no.toUpperCase())),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

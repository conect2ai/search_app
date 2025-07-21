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
  String? _apiKey;
  final _viewModel = Modular.get<ApiKeyViewModel>();

  @override
  void initState() {
    _apiKey = _viewModel.getApiKey();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _apiKey ??= _viewModel.getApiKey();
    super.didChangeDependencies();
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
                context.localizations.openAIKey,
                style: AppTextStyles.authScreenTitleTextStyle,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                child: Text(
                  context.localizations.foundKey(_apiKey ?? ''),
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
                        Modular.to.pushReplacementNamed('/menu-page/');
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

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../exceptions/api_key_not_found_exception.dart';
import '../view_models/api_key_viewmodel.dart';

class LoadApiKeyScreen extends StatefulWidget {
  final String _provider;
  const LoadApiKeyScreen({required String provider, super.key})
      : _provider = provider;

  @override
  State<LoadApiKeyScreen> createState() => _LoadApiKeyScreenState();
}

class _LoadApiKeyScreenState extends State<LoadApiKeyScreen> {
  final ApiKeyViewModel _apiKeyViewModel = Modular.get<ApiKeyViewModel>();

  @override
  void initState() {
    _checkApiKey();
    super.initState();
  }

  void _checkApiKey() async {
    try {
      await _apiKeyViewModel.checkApiKey(widget._provider).then((_) {
        widget._provider == 'openai'
            ? Modular.to.navigate(
                '/api-key/confirm_api_key?provider=${widget._provider}')
            : Modular.to
                .pushNamed(
                    '/api-key/confirm_api_key?provider=${widget._provider}')
                .then((_) => Modular.to.navigate('/menu-page/'));
      });
    } on ApiKeyNotFoundException catch (_) {
      widget._provider == 'openai'
          ? Modular.to
              .navigate('/api-key/input_api_key?provider=${widget._provider}')
          : Modular.to
              .pushNamed('/api-key/input_api_key?provider=${widget._provider}')
              .then((_) => Modular.to.navigate('/menu-page/'));
    } catch (e) {
      widget._provider == 'openai'
          ? Modular.to
              .navigate('/api-key/input_api_key?provider=${widget._provider}')
          : Modular.to
              .pushNamed('/api-key/input_api_key?provider=${widget._provider}')
              .then((_) => Modular.to.navigate('/menu-page/'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: SpinKitSpinningLines(
        size: 100,
        color: AppColors.mainColor,
      )),
    );
  }
}

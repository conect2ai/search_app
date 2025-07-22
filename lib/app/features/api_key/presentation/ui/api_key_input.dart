import 'dart:io';
import 'dart:ui';

import 'package:app_search/extensions/context_extansion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../exceptions/api_key_not_found_exception.dart';
import '../../../../exceptions/invalid_api_key_exception.dart';
import '../../../../exceptions/server_communication_exception.dart';
import '../../../../mixins/snackbar_mixin.dart';
import '../view_models/api_key_viewmodel.dart';

class ApiKeyInput extends StatefulWidget {
  final String? _provider;

  const ApiKeyInput({super.key, required String provider})
      : _provider = provider;

  @override
  State<ApiKeyInput> createState() => _ApiKeyInputState();
}

class _ApiKeyInputState extends State<ApiKeyInput>
    with SnackBarMixin, CustomAppbar {
  final _apiKeyInputController = TextEditingController();
  var _isValidApiKey = false;
  var _isLoadingChatPage = false;

  final _viewModel = Modular.get<ApiKeyViewModel>();

  @override
  void initState() {
    _apiKeyInputController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: generateCustomAppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  height: 80,
                  child: TextField(
                    selectionHeightStyle: BoxHeightStyle.strut,
                    controller: _apiKeyInputController,
                    keyboardType: TextInputType.emailAddress,
                    style: AppTextStyles.textFieldTextStyle,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: AppColors.mainColor,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: widget._provider == 'openai'
                          ? context.localizations.inputOpenAIKey
                          : context.localizations.inputGoogleAPIKey,
                      hintStyle: const TextStyle(
                          fontSize: 17,
                          color: Colors.white60,
                          fontWeight: FontWeight.w400),
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.mainColor,
                      ),
                      constraints: BoxConstraints.tight(
                          Size(MediaQuery.of(context).size.width * 0.9, 120)),
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
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          _isLoadingChatPage = true;
                        });
                        _isValidApiKey = _apiKeyInputController.text.isNotEmpty;

                        if (!_isValidApiKey) {
                          generateSnackBar(
                              context.localizations.pleaseInsertApiKey,
                              context);
                          setState(() {
                            _isLoadingChatPage = false;
                          });
                        } else {
                          try {
                            await _viewModel
                                .validateApiKey(_apiKeyInputController.text,
                                    widget._provider ?? 'openai')
                                .then((_) {
                              widget._provider == 'openai'
                                  ? Modular.to
                                      .pushReplacementNamed('/menu-page/')
                                  : Modular.to
                                      .pushReplacementNamed('/report-problem/');
                            });
                          } on InvalidApiKeyException catch (_) {
                            if (!mounted) {
                              return;
                            }
                            setState(() {
                              _isLoadingChatPage = false;
                            });
                            generateSnackBar(
                                context.localizations.invalidApiKey, context);
                          } on ServerCommunicationException catch (_) {
                            if (!mounted) {
                              return;
                            }
                            generateSnackBar(
                                context.localizations.failedToInsertKey,
                                context);
                          } catch (e) {
                            if (!mounted) {
                              return;
                            }
                            generateSnackBar(
                                context.localizations.failedToInsertKey,
                                context);
                          }
                        }
                      },
                      child: _isLoadingChatPage
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              context.localizations.confirm,
                              style: AppTextStyles.authScreenButtonsTextStyle,
                            )),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButton(
                  onPressed: () async {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    try {
                      if (widget._provider == 'openai') {
                        final openaiKey = _viewModel.getOpenaiApiKey();
                        if (openaiKey == null) {
                          _viewModel.logout();
                          Modular.to.pushReplacementNamed('/auth/login');
                        } else {
                          Modular.to.pushReplacementNamed(
                              '/api-key/confirm_api_key?provider=${widget._provider}');
                        }
                      } else {
                        final googleApiKey = _viewModel.getGoogleApiKey();
                        if (googleApiKey == null) {
                          Modular.to.navigate('/menu-page/');
                        } else {
                          Modular.to.pushReplacementNamed(
                              '/api-key/confirm_api_key?provider=${widget._provider}');
                        }
                      }
                    } on ApiKeyNotFoundException catch (_) {
                      if (!mounted) {
                        return;
                      }
                      generateSnackBar(
                          context.localizations.failedToLoadKey, context);
                    } catch (e) {
                      if (!mounted) {
                        return;
                      }
                      generateSnackBar(
                          context.localizations.failedToLoadKey, context);
                    }
                  },
                  child: RichText(
                    text: TextSpan(
                        text: context.localizations.changedYourMind,
                        style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                            color: Colors.white),
                        children: [
                          TextSpan(
                              text: context.localizations.goBack,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.white))
                        ]),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'dart:ui';

import 'package:app_search/extensions/context_extansion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../mixins/snackbar_mixin.dart';
import '../../../manual/interactor/blocs/manual_bloc.dart';
import '../../interactor/bloc/homepage_bloc.dart';

class ApiKeyInput extends StatefulWidget {
  final HomePageBloc _homebloc;
  const ApiKeyInput({required homebloc, super.key}) : _homebloc = homebloc;

  @override
  State<ApiKeyInput> createState() => _ApiKeyInputState();
}

class _ApiKeyInputState extends State<ApiKeyInput> with SnackBarMixin {
  final _apiKeyInputController = TextEditingController();
  var _isValidApiKey = false;
  var _isLoadingChatPage = false;
  final _homeBloc = Modular.get<HomePageBloc>();
  final _manualBloc = Modular.get<ManualBloc>();

  @override
  void initState() {
    _apiKeyInputController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                context.localizations.openAIKey,
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
                    hintText: context.localizations.inputOpenAIKey,
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
                      borderSide: const BorderSide(color: AppColors.mainColor),
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
                      _isValidApiKey = widget._homebloc
                          .checkIfApiKeyIsNotEmpty(_apiKeyInputController.text);
                      if (!_isValidApiKey) {
                        generateSnackBar(
                            context.localizations.pleaseInsertApiKey, context);
                        setState(() {
                          _isLoadingChatPage = false;
                        });
                      } else {
                        try {
                          final bool isKeySaved = await widget._homebloc
                              .saveApiKey(_apiKeyInputController.text);
                          if (isKeySaved) {
                            _manualBloc
                                .checkIfThereIsManuals()
                                .then((hasManuals) {
                              hasManuals
                                  ? Modular.to
                                      .pushReplacementNamed('/menu-page/')
                                  : Modular.to
                                      .pushReplacementNamed('/manual-check/');
                            });
                          } else {
                            if (!mounted) {
                              return;
                            }
                            setState(() {
                              _isLoadingChatPage = false;
                            });
                            generateSnackBar(
                                context.localizations.invalidApiKey, context);
                          }
                        } on HttpException catch (_) {
                          if (!mounted) {
                            return;
                          }
                          setState(() {
                            _isLoadingChatPage = false;
                          });
                          generateSnackBar(
                              context.localizations.failedToInsertKey, context);
                        } catch (e) {
                          if (!mounted) {
                            return;
                          }
                          generateSnackBar(
                              context.localizations.failedToInsertKey, context);
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
                    await _homeBloc.checkIfUserHasKey().then((key) {
                      if (key == null) {
                        _homeBloc.logout();
                        Modular.to.pushReplacementNamed('/auth/login');
                      } else {
                        Modular.to.pushReplacementNamed('/check-api-key/');
                      }
                    });
                  } on HttpException catch (_) {
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
    );
  }
}

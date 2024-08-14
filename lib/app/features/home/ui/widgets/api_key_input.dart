import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../mixins/snackbar_mixin.dart';
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

  @override
  void initState() {
    _checkIfUserHasKey();
    _checkApiKeySavedData();
    super.initState();
  }

  void _checkIfUserHasKey() async {
    try {
      await widget._homebloc.checkIfUserHasKey().then((value) {
        _apiKeyInputController.text = value;
      });
    } on HttpException catch (_) {
      if (!mounted) {
        return;
      }
      generateSnackBar(
          'Could not retrieve api key information from user', context);
    } catch (_) {
      if (!mounted) {
        return;
      }
      generateSnackBar(
          'Could not retrieve api key information from user', context);
    }
  }

  void _checkApiKeySavedData() async {
    _apiKeyInputController.text =
        await widget._homebloc.readSavedApiKey() ?? '';
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
                'OpenAI Key',
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
                    hintText: 'Key',
                    hintStyle: const TextStyle(
                        fontSize: 17,
                        color: Colors.white,
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
                      Modular.to.navigate('/chat/');
                      // _isValidApiKey = widget._homebloc
                      //     .checkIfApiKeyIsNotEmpty(_apiKeyInputController.text);
                      // if (!_isValidApiKey) {
                      //   generateSnackBar('Please insert a key', context);
                      // } else {
                      //   try {
                      //     await widget._homebloc
                      //         .saveApiKey(_apiKeyInputController.text)
                      //         .then((_) {
                      //       //  widget._homebloc.checkApiKeyIsValid();
                      //       Modular.to.navigate('/chat/');
                      //     });
                      //   } on HttpException catch (_) {
                      //     if (!mounted) {
                      //       return;
                      //     }
                      //     setState(() {
                      //       _isLoadingChatPage = false;
                      //     });
                      //     generateSnackBar(
                      //         'Failed to save your api key information',
                      //         context);
                      //   } catch (e) {
                      //     if (!mounted) {
                      //       return;
                      //     }
                      //     generateSnackBar(
                      //         'Failed to save your api key information',
                      //         context);
                      //   }
                      // }
                    },
                    child: _isLoadingChatPage
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            'Confirmar',
                            style: AppTextStyles.authScreenButtonsTextStyle,
                          )),
              ),
            ]),
      ),
    );
  }
}

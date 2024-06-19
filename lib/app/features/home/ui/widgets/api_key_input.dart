import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../interactor/bloc/homepage_bloc.dart';

class ApiKeyInput extends StatefulWidget {
  final HomePageBloc _homebloc;
  const ApiKeyInput({required homebloc, super.key}) : _homebloc = homebloc;

  @override
  State<ApiKeyInput> createState() => _ApiKeyInputState();
}

class _ApiKeyInputState extends State<ApiKeyInput> {
  final _apiKeyInputController = TextEditingController();
  var _isValidApiKey = false;
  var _errorText = '';
  @override
  void initState() {
    _checkApiKeySavedData();
    super.initState();
  }

  void _checkApiKeySavedData() async {
    _apiKeyInputController.text =
        await widget._homebloc.readSavedApiKey() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.blueGrey.shade100,
          borderRadius: BorderRadius.circular(15)),
      child: Stack(children: [
        Positioned(
          top: 0,
          child: SizedBox(
            width: 200,
            child: TextField(
              controller: _apiKeyInputController,
              onChanged: (value) {
                _errorText = '';
              },
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                fillColor: Colors.blueGrey.shade100,
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                hintText: 'Insert Your Api Key',
                errorText: _errorText,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: IconButton(
              iconSize: 20,
              onPressed: () {
                _isValidApiKey = widget._homebloc
                    .validateApiKey(_apiKeyInputController.text);
                if (!_isValidApiKey) {
                  setState(() {
                    _errorText = 'Please insert a valid api key';
                  });
                } else {
                  try {
                    widget._homebloc
                        .saveApiKey(_apiKeyInputController.text)
                        .then((_) {
                      widget._homebloc.checkApiKeyIsValid();
                      Modular.to.navigate('/chat/');
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Não foi possível validar a chave da api.')),
                    );
                  }
                }
              },
              icon: const Icon(
                Icons.login,
                color: Colors.grey,
              )),
        ),
      ]),
    );
  }
}

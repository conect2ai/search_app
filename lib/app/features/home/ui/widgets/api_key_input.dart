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
    return Stack(
      children: [
        TextField(
          controller: _apiKeyInputController,
          onChanged: (value) {
            _errorText = '';
          },
          decoration: InputDecoration(
            isDense: true,
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
        Positioned(
          right: 5,
          child: IconButton(
              onPressed: () {
                _isValidApiKey = widget._homebloc
                    .validateApiKey(_apiKeyInputController.text);
                if (!_isValidApiKey) {
                  setState(() {
                    _errorText = 'Please insert a valid api key';
                  });
                } else {
                  widget._homebloc.saveApiKey(_apiKeyInputController.text);
                  Modular.to.navigate('/chat/');
                }
              },
              icon: const Icon(
                Icons.login,
                color: Colors.grey,
              )),
        )
      ],
    );
  }
}

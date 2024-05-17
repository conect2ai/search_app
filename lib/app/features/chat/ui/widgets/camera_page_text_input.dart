import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../interactor/blocs/chatpage/chat_page_bloc.dart';
import '../../interactor/blocs/chatpage/chat_page_event.dart';

class CameraPageTextInput extends StatefulWidget {
  final File? _picture;
  const CameraPageTextInput(this._picture, {super.key});

  @override
  State<CameraPageTextInput> createState() => _CameraPageTextInputState();
}

class _CameraPageTextInputState extends State<CameraPageTextInput> {
  final _textInputController = TextEditingController();
  final ChatPageBloc _chatPageBloc = Modular.get<ChatPageBloc>();

  final FocusNode _textFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Stack(children: [
            TextField(
              controller: _textInputController,
              focusNode: _textFocusNode,
              inputFormatters: [
                TextInputFormatter.withFunction((oldValue, newValue) {
                  int newLines = newValue.text.split('\n').length;
                  if (newLines > 4) {
                    return oldValue;
                  } else {
                    return newValue;
                  }
                }),
              ],
              onEditingComplete: () {
                if (_textInputController.text.isNotEmpty) {
                  _chatPageBloc
                      .add(SendTextEvent(question: _textInputController.text));
                  _textInputController.text = '';
                  FocusManager.instance.primaryFocus?.unfocus();
                  Modular.to.pop();
                }
              },
              decoration: InputDecoration(
                isDense: true,
                fillColor: Colors.blueGrey.shade100,
                filled: true,
                hintText: 'Text here...',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
              ),
            ),
          ]),
        ),
        Container(
            margin: const EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueGrey.shade200),
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: IconButton(
                onPressed: () {
                  _chatPageBloc.add(SendTextEvent(
                      question: _textInputController.text,
                      picture: widget._picture));
                  Modular.to.pop();
                },
                icon: const Icon(
                  Icons.send_outlined,
                  color: Colors.grey,
                ))),
      ],
    );
  }
}

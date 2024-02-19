import 'package:app_search/app/features/chat/interactor/chat_page_events.dart';
import 'package:flutter/material.dart';

import '../../interactor/chat_page_bloc.dart';

class ChatPageInput extends StatefulWidget {
  final ChatPageBloc _bloc;
  const ChatPageInput({required bloc, super.key}) : _bloc = bloc;

  @override
  State<ChatPageInput> createState() => _ChatPageInputState();
}

class _ChatPageInputState extends State<ChatPageInput> {
  final _textInputController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();

  @override
  void initState() {
    _textInputController.text = '';
    super.initState();
  }

  @override
  void dispose() {
    _textFocusNode.dispose();
    _textInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Stack(children: [
            TextField(
              maxLines: null,
              controller: _textInputController,
              focusNode: _textFocusNode,
              decoration: InputDecoration(
                  isDense: true,
                  fillColor: Colors.blueGrey.shade100,
                  filled: true,
                  hintText: 'Text here...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none)),
            ),
            Positioned(
                right: 0,
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.image_outlined,
                      color: Colors.grey,
                    ))),
          ]),
        ),
        Container(
            margin: const EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueGrey.shade200),
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: _textFocusNode.hasFocus
                ? IconButton(
                    onPressed: () {
                      if (_textInputController.text.isNotEmpty) {
                        widget._bloc.add(
                            SendTextEvent(question: _textInputController.text));
                      }
                    },
                    icon: const Icon(
                      Icons.send_outlined,
                      color: Colors.grey,
                    ))
                : IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.mic_none,
                      color: Colors.grey,
                    )))
      ],
    );
  }
}

import 'package:app_search/app/core/themes/app_text_styles.dart';
import 'package:app_search/app/features/chat/interactor/blocs/chat_page_input_state.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../interactor/blocs/chat_page_bloc.dart';
import '../../interactor/blocs/chat_page_event.dart';
import '../../interactor/blocs/chat_page_input_bloc.dart';
import '../../interactor/blocs/chat_page_input_events.dart';

class ChatPageInput extends StatefulWidget {
  final ChatPageBloc _chatPageBloc;

  const ChatPageInput({required bloc, super.key}) : _chatPageBloc = bloc;

  @override
  State<ChatPageInput> createState() => _ChatPageInputState();
}

class _ChatPageInputState extends State<ChatPageInput> {
  final ChatPageInputBloc _chatPageInputBloc = Modular.get<ChatPageInputBloc>();

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
          child: BlocBuilder(
            bloc: _chatPageInputBloc,
            builder: (context, state) {
              if (state is TextModeState) {
                return Stack(children: [
                  TextField(
                    maxLines: null,
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
                  Positioned(
                      right: 0,
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.image_outlined,
                            color: Colors.grey,
                          ))),
                ]);
              } else {
                return Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 49,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueGrey.shade100,
                    ),
                    child: AudioWaveforms(
                        size: Size(MediaQuery.of(context).size.width * 0.6, 47),
                        recorderController:
                            _chatPageInputBloc.recorderController)
                    // const Text('
                    //   "Gravando...",
                    //   textAlign: TextAlign.start,
                    //   style: TextStyle(
                    //     color: Colors.grey,
                    //   ),
                    // ),
                    );
              }
            },
          ),
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
                        widget._chatPageBloc.add(
                            SendTextEvent(question: _textInputController.text));
                        _textInputController.text = '';
                      }
                    },
                    icon: const Icon(
                      Icons.send_outlined,
                      color: Colors.grey,
                    ))
                : GestureDetector(
                    onLongPress: () =>
                        _chatPageInputBloc.add(FocusAudioEvent()),
                    onLongPressUp: () =>
                        _chatPageInputBloc.add(FocusTextEvent()),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 11, vertical: 12),
                      child: Icon(
                        Icons.mic_none,
                        color: Colors.grey,
                      ),
                    )))
      ],
    );
  }
}

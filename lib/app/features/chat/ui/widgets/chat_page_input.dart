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
  const ChatPageInput({super.key});

  @override
  State<ChatPageInput> createState() => _ChatPageInputState();
}

class _ChatPageInputState extends State<ChatPageInput> {
  final ChatPageInputBloc _chatPageInputBloc = Modular.get<ChatPageInputBloc>();
  final ChatPageBloc _chatPageBloc = Modular.get<ChatPageBloc>();

  final _textInputController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();

  Widget? _chatInputBtn;

  @override
  void initState() {
    _textInputController.text = '';
    _chatPageInputBloc.getDir();
    _chatPageInputBloc.checkPermission();
    _textFocusNode.addListener(_onFocusChanged);
    _buildChatInputBtn(_textFocusNode.hasFocus);

    super.initState();
  }

  void _onFocusChanged() {
    _buildChatInputBtn(_textFocusNode.hasFocus);
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
                      size: Size(MediaQuery.of(context).size.width * 0.6, 30),
                      recorderController: _chatPageInputBloc.recorderController,
                      waveStyle: const WaveStyle(
                        backgroundColor: Colors.white,
                        showBottom: false,
                        extendWaveform: true,
                        showMiddleLine: false,
                      ),
                    ));
                // const Text('
                //   "Gravando...",
                //   textAlign: TextAlign.start,
                //   style: TextStyle(
                //     color: Colors.grey,
                //   ),
                // ),
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
            child: _chatInputBtn),
      ],
    );
  }

  void _buildChatInputBtn(bool isTextMode) {
    if (isTextMode) {
      setState(() {
        _chatInputBtn = IconButton(
            onPressed: () {
              if (_textInputController.text.isNotEmpty) {
                _chatPageBloc
                    .add(SendTextEvent(question: _textInputController.text));
                _textInputController.text = '';
              }
            },
            icon: const Icon(
              Icons.send_outlined,
              color: Colors.grey,
            ));
      });
    } else {
      setState(() {
        _chatInputBtn = GestureDetector(
            onLongPress: () {
              _chatPageInputBloc.startRecording();
              _chatPageInputBloc.add(FocusAudioEvent());
            },
            onLongPressUp: () {
              _chatPageInputBloc.stopRecording();
              _chatPageBloc.add(SendAudioEvent(path: _chatPageInputBloc.path));
              _chatPageInputBloc.add(FocusTextEvent());
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 11, vertical: 12),
              child: Icon(
                Icons.mic_none,
                color: Colors.grey,
              ),
            ));
      });
    }
  }
}

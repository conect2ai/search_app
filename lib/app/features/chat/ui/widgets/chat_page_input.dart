import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/themes/app_text_styles.dart';
import '../../interactor/blocs/chatpage/chat_page_bloc.dart';
import '../../interactor/blocs/chatpage/chat_page_event.dart';
import '../../interactor/blocs/chatpage_inputs/chat_page_input_bloc.dart';
import '../../interactor/blocs/chatpage_inputs/chat_page_input_events.dart';
import '../../interactor/blocs/chatpage_inputs/chat_page_input_state.dart';
import '../pages/camera_page.dart';

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
  late List<CameraDescription> _cameras;

  @override
  void initState() {
    _textInputController.text = '';
    _chatPageInputBloc.getDir();
    _chatPageInputBloc.checkPermission();
    _textFocusNode.addListener(_onFocusChanged);
    _getAvailableCameras();
    _buildChatInputBtn(_textFocusNode.hasFocus);

    super.initState();
  }

  void _onFocusChanged() {
    _buildChatInputBtn(_textFocusNode.hasFocus);
  }

  void _getAvailableCameras() async {
    _cameras = await availableCameras();
  }

  @override
  void dispose() {
    _textFocusNode.dispose();
    _textInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            constraints: const BoxConstraints(maxWidth: 25),
            onPressed: () {
              _chatPageBloc.pickImage(ImageSource.gallery);
            },
            splashRadius: 20,
            iconSize: 20,
            padding: const EdgeInsets.symmetric(horizontal: 0),
            icon: const Icon(
              Icons.image_outlined,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            constraints: const BoxConstraints(maxWidth: 20),
            onPressed: () {
              // _chatPageBloc.pickImage(ImageSource.camera);
              Modular.to.push(MaterialPageRoute(
                builder: (context) => CameraPage(_cameras),
              ));
            },
            iconSize: 20,
            splashRadius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 0),
            icon: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: BlocBuilder<ChatPageInputBloc, ChatPageInputState>(
              bloc: _chatPageInputBloc,
              builder: (context, state) {
                if (state is TextModeState) {
                  return Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextField(
                      controller: _textInputController,
                      focusNode: _textFocusNode,
                      style: AppTextStyles.chatInputTextStyle,
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
                          _chatPageBloc.add(SendTextEvent(
                              question: _textInputController.text));
                          _textInputController.text = '';
                          FocusManager.instance.primaryFocus?.unfocus();
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        fillColor: Colors.grey.shade600,
                        filled: true,
                        hintText: 'Message',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.71)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                      ),
                    ),
                  );
                } else {
                  return AudioWaveforms(
                    size: Size(MediaQuery.of(context).size.width * 0.6, 30),
                    recorderController: _chatPageInputBloc.recorderController,
                    waveStyle: const WaveStyle(
                      backgroundColor: Colors.white,
                      showBottom: false,
                      extendWaveform: true,
                      showMiddleLine: false,
                    ),
                  );
                }
              },
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          _chatInputBtn!,
        ],
      ),
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
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            icon: const Icon(
              Icons.send_outlined,
              color: Colors.white,
            ));
      });
    } else {
      setState(() {
        _chatInputBtn = GestureDetector(
            onLongPress: () {
              _chatPageInputBloc.startRecording();
              _chatPageInputBloc.add(FocusAudioEvent());
            },
            onLongPressUp: () async {
              final audioFilePath = await _chatPageInputBloc.stopRecording();
              _chatPageBloc.add(SendAudioEvent(path: audioFilePath ?? ''));
              _chatPageInputBloc.add(FocusTextEvent());
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Icon(
                Icons.mic_none,
                color: Colors.white,
              ),
            ));
      });
    }
  }
}

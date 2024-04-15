import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'chat_page_input_events.dart';
import 'chat_page_input_state.dart';

class ChatPageInputBloc extends Bloc<ChatPageInputEvent, ChatPageInputState> {
  final RecorderController _recorderController = RecorderController();
  String? _path;
  late Directory _appDirectory;

  ChatPageInputBloc() : super(TextModeState()) {
    on<FocusTextEvent>((event, emit) {
      emit(TextModeState());
    });
    on<FocusAudioEvent>((event, emit) {
      emit(AudioModeState());
    });
    on<StartLoadingEvent>((event, emit) {
      emit(AwatingForResponstState());
    });
    on<FinishLoadingEvent>((event, emit) {
      emit(ResponseReceveidSuccessState());
    });
  }

  void checkPermission() async {
    await _recorderController.checkPermission();
  }

  void getDir() async {
    _appDirectory = await getTemporaryDirectory();
  }

  String get path => _path!;

  void startRecording() async {
    final hasPermission = await _recorderController.checkPermission();
    if (hasPermission) {
      _path =
          '${_appDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';
      await _recorderController.record(path: _path);
    }
  }

  Future<String?> stopRecording() async {
    if (_recorderController.isRecording) {
      return await _recorderController.stop();
    }
    return null;
  }

  RecorderController get recorderController => _recorderController;
}

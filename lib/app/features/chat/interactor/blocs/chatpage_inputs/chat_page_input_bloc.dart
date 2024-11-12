import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

import 'chat_page_input_events.dart';
import 'chat_page_input_state.dart';

class ChatPageInputBloc extends Bloc<ChatPageInputEvent, ChatPageInputState> {
  RecorderController _recorderController = RecorderController();
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

  final _recordDurationSubject =
      BehaviorSubject.seeded(const Duration(seconds: 0));

  Stream<Duration> get duration => _recordDurationSubject.stream;

  StreamSubscription<Duration>? _recordinSubscription;

  RecorderController get recorderController => _recorderController;

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
      _recorderController = RecorderController();
      _path = '${_appDirectory.path}/${DateTime.now().millisecondsSinceEpoch}';
      _recordinSubscription =
          _recorderController.onCurrentDuration.listen((duration) {
        _recordDurationSubject.sink.add(duration);
      });
      await _recorderController.record(
          path: _path,
          androidOutputFormat: AndroidOutputFormat.ogg,
          androidEncoder: AndroidEncoder.amr_wb,
          iosEncoder: IosEncoder.kAudioFormatAMR_WB);
    }
  }

  Future<String?> stopRecording() async {
    if (_recorderController.isRecording) {
      _recorderController.reset();
      return await _recorderController.stop();
    }
    return null;
  }

  void cancelRecording() {
    _recorderController.dispose();
    _recordinSubscription?.cancel();
    _path = null;
    _recordDurationSubject.sink.add(Duration.zero);
    add(FocusTextEvent());
  }

  void dispose() {
    _recordDurationSubject.close();
    _recordinSubscription?.cancel();
    _path = null;
  }
}

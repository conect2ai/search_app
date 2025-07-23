import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:bloc/bloc.dart';
import 'package:cr_file_saver/file_saver.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../blocs/loading_overlay_bloc.dart';
import '../../../../blocs/loading_overlay_event.dart';
import '../../../../core/entities/chat_message.dart';
import '../../../../core/entities/transcription_response.dart';
import '../../data/report_problem_repository.dart';
import 'events/report_problem_page_events.dart';
import 'states/report_problem_page_states.dart';

class ReportProblemBloc
    extends Bloc<ReportProblemPageEvent, ReportProblemPageState> {
  final List<ChatMessage> _results = [];
  final LoadingOverlayBloc _loadingOverlayBloc;
  final ReportProblemRepository _reportProblemRepository;
  final _transcriptionResponse = TranscriptionResponse();
  RecorderController _recorderController = RecorderController();
  String? _path;
  late Directory _appDirectory;

  final _hasResultsSubject = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get hasResults => _hasResultsSubject.stream;

  ReportProblemBloc(this._loadingOverlayBloc, this._reportProblemRepository)
      : super(InitialReportProblemPageState()) {
    on<LoadReportProblemPageEvent>((event, emit) {
      _results.clear();
      _hasResultsSubject.sink.add(false);
      emit(InitialReportProblemPageState());
    });
    on<RecordingAudioEvent>((event, emit) => emit(RecordingAudioState()));
    on<SendAudioEvent>(
      (event, emit) async {
        String messageId = DateTime.timestamp().toIso8601String();
        if (event.path.isNotEmpty) {
          _results.add(ChatMessage(
            id: messageId,
            audioPath: event.path,
            isQuestion: true,
            isAudio: true,
          ));
          emit(ReceiveReportResponseState(results: _results));
          _loadingOverlayBloc.add(ShowLoadingOverlayEvent());
          try {
            final message =
                await _reportProblemRepository.sendAudioReportForTranscription(
              event.path,
            );
            messageId = DateTime.timestamp().toIso8601String();
            _transcriptionResponse.updateTranscriptionResponse(
                messageId, message);

            _results.add(
              ChatMessage(
                  id: messageId,
                  isQuestion: false,
                  isAudio: false,
                  message: message['transcribed_text']),
            );

            _hasResultsSubject.sink.add(true);
          } catch (_) {
            _loadingOverlayBloc.add(
                ShowErrorEvent(message: 'Failed to communicate with server'));
          }

          _loadingOverlayBloc.add(HideLoadingOverlayEvent());
          emit(ReceiveReportResponseState(results: _results));
        }
      },
    );
  }

  // final _recordDurationSubject =
  //     BehaviorSubject.seeded(const Duration(seconds: 0));

  // Stream<Duration> get duration => _recordDurationSubject.stream;

  // StreamSubscription<Duration>? _recordinSubscription;

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
      // _recordinSubscription =
      //     _recorderController.onCurrentDuration.listen((duration) {
      //   _recordDurationSubject.sink.add(duration);
      // });
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

  void dispose() {
    // _recordDurationSubject.close();
    // _recordinSubscription?.cancel();
    _transcriptionResponse.clearData();
    _path = null;
  }

  Future<bool> generateCheckListCSV() async {
    if (_results.any((element) => !element.isQuestion)) {
      try {
        final fileDir = await getTemporaryDirectory();
        final date = DateTime.now().toString();
        final formattedTime =
            DateFormat("yyyy-MM-dd HH:mm:ss").parse(date).toString().split('.');
        String csvData = const ListToCsvConverter()
            .convert(_transcriptionResponse.getChecklistInformation());
        final fileName = 'transcription_report-${formattedTime[0]}.csv';
        final path = '${fileDir.path}/$fileName';
        var file = File(path);
        file = await file.writeAsString(csvData);
        final granted =
            await CRFileSaver.requestWriteExternalStoragePermission();

        if (granted) {
          await CRFileSaver.saveFile(path, destinationFileName: fileName);
          return true;
        }

        return false;
      } catch (e) {
        throw Exception('Error generating CSV file');
      }
    }
    return false;
  }
}

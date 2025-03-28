import 'package:app_search/app/mixins/snackbar_mixin.dart';
import 'package:app_search/extensions/context_extansion.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../blocs/loading_overlay_bloc.dart';
import '../../../blocs/loading_overlay_state.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../mixins/custom_dialogs.dart';
import '../../../mixins/loading_overlay.dart';
import '../../../mixins/logo_appbar.dart';
import '../../../widgets/custom_dialog.dart';
import '../../chat/ui/widgets/messages_list.dart';
import '../interactor/blocs/events/report_problem_page_events.dart';
import '../interactor/blocs/report_problem_bloc.dart';
import '../interactor/blocs/states/report_problem_page_states.dart';
import 'widgets/report_page_messages_list.dart';

class ReportProblemPage extends StatefulWidget {
  ReportProblemPage({super.key});

  @override
  State<ReportProblemPage> createState() => _ReportProblemPageState();
}

class _ReportProblemPageState extends State<ReportProblemPage>
    with LogoAppBar, LoadingOverlay, LogoAppBar, CustomDialogs, SnackBarMixin {
  final _reportProblemBloc = Modular.get<ReportProblemBloc>();

  final _loadingOverlayBloc = Modular.get<LoadingOverlayBloc>();

  bool _isRecording = false;

  @override
  void initState() {
    _reportProblemBloc.getDir();
    _reportProblemBloc.checkPermission();
    super.initState();
  }

  @override
  void dispose() {
    _reportProblemBloc.dispose();
    super.dispose();
  }

  void _generateCsv(BuildContext context) async {
    try {
      final isCsvSaved = await _reportProblemBloc.generateCheckListCSV();
      if (isCsvSaved) {
        if (!mounted) {
          return;
        }
        generateSnackBar(context.localizations.csvSavedSuccess, context);
      }
    } catch (e) {
      dialog(
          context,
          CustomDialog(
            message: context.localizations.csvSavedError,
            buttonMessage: context.localizations.close,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generateLogoAppBar(context, [
        IconButton(
            onPressed: () => _generateCsv(context),
            icon: const Icon(
              Icons.download,
              color: Colors.white,
            ))
      ]),
      body: BlocListener<LoadingOverlayBloc, LoadingOverlayState>(
        bloc: _loadingOverlayBloc,
        listener: (context, state) async {
          if (state is ShowingLoadingOverlayState) {
            showOverlay(context);
          } else if (state is HidingLoadingOverlayState) {
            hideOverlay();
          } else if (state is OnErrorState) {
            hideOverlay();
            await showDialog(
              context: context,
              builder: (context) => CustomDialog(
                message: state.message,
                buttonMessage: context.localizations.close,
              ),
            );
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            BlocBuilder<ReportProblemBloc, ReportProblemPageState>(
              bloc: _reportProblemBloc,
              builder: (context, state) {
                if (state is InitialReportProblemPageState) {
                  return Center(
                    child: Text(
                      context.localizations.recordReportAudioMessage,
                      style: AppTextStyles.mainTextStyle,
                    ),
                  );
                }
                if (state is RecordingAudioState) {
                  return Center(
                    child: AudioWaveforms(
                      size: Size(MediaQuery.of(context).size.width * 0.8, 60),
                      recorderController: _reportProblemBloc.recorderController,
                      waveStyle: WaveStyle(
                        waveColor: Colors.white,
                        backgroundColor: Colors.grey.shade600,
                        showBottom: false,
                        extendWaveform: true,
                        showMiddleLine: false,
                      ),
                    ),
                  );
                }
                if (state is ReceiveReportResponseState) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 0),
                    child: ReportPageMessagesList(
                      state: state,
                    ),
                  );
                } else {
                  return const SpinKitSpinningLines(
                    size: 100,
                    color: AppColors.mainColor,
                  );
                }
              },
            ),
            Positioned(
              bottom: 20,
              child: CircleAvatar(
                backgroundColor:
                    _isRecording ? Colors.red : AppColors.mainColor,
                radius: 30,
                child: IconButton(
                  onPressed: () async {
                    if (_isRecording) {
                      setState(() {
                        _isRecording = false;
                      });
                      final audioFilePath =
                          await _reportProblemBloc.stopRecording();
                      _reportProblemBloc
                          .add(SendAudioEvent(path: audioFilePath ?? ''));
                    } else {
                      setState(() {
                        _isRecording = true;
                      });
                      _reportProblemBloc.startRecording();
                      _reportProblemBloc.add(RecordingAudioEvent());
                    }
                  },
                  icon: _isRecording
                      ? const Icon(
                          Icons.stop_rounded,
                          color: Colors.white,
                          size: 30,
                        )
                      : const Icon(
                          Icons.mic,
                          color: Colors.white,
                          size: 30,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

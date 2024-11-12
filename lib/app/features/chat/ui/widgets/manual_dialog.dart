import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../mixins/custom_dialogs.dart';
import '../../../../mixins/snackbar_mixin.dart';
import '../../../manual/interactor/blocs/manual_bloc.dart';
import '../../../manual/interactor/blocs/manual_event.dart';
import '../../../manual/interactor/blocs/manual_state.dart';

class ManualDialog extends StatefulWidget {
  ManualDialog({super.key});

  @override
  State<ManualDialog> createState() => _ManualDialogState();
}

class _ManualDialogState extends State<ManualDialog>
    with CustomDialogs, SnackBarMixin {
  final _manualBloc = Modular.get<ManualBloc>();
  @override
  void initState() {
    _manualBloc.initSubjects();
    super.initState();
  }

  @override
  void dispose() {
    _manualBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Manual Upload',
              style: AppTextStyles.dialogtextStyle,
            ),
          ),
          const Divider(
            height: 20,
            thickness: 2,
          ),
          const SizedBox(
            height: 10,
          ),
          _buildManualUploadField(),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            height: 20,
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Wrap(
              spacing: 15,
              children: [
                TextButton(
                  onPressed: () => Modular.to.pop(),
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.dialogtextStyle,
                  ),
                ),
                BlocBuilder<ManualBloc, ManualState>(
                    bloc: _manualBloc,
                    builder: (context, state) {
                      if (state is PdfSelectedState) {
                        return TextButton(
                          onPressed: () async {
                            try {
                              _manualBloc.updateManualUploadButton(true);
                              await _manualBloc.uploadPdf().then((_) {
                                _manualBloc.updateManualUploadButton(false);
                              });
                            } on HttpException catch (_) {
                              if (!mounted) {
                                return;
                              }
                              _manualBloc.updateManualUploadButton(false);
                              generateSnackBar(
                                  'Manual upload failed. Try again later.',
                                  context);
                            } catch (e) {
                              if (!mounted) {
                                return;
                              }
                              _manualBloc.updateManualUploadButton(false);
                              generateSnackBar(
                                  'Manual upload failed. Try again later.',
                                  context);
                            }
                          },
                          child: StreamBuilder<bool>(
                              stream: _manualBloc.isSendingManual,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final isSendingManual = snapshot.data!;
                                  if (isSendingManual) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Sending',
                                          style: _manualBloc.pdf != null
                                              ? AppTextStyles
                                                  .dialogOptionsextStyle
                                              : AppTextStyles
                                                  .dialogSecondaryTextStyle,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        SizedBox(
                                          width: 10,
                                          height: 10,
                                          child: Visibility(
                                            visible: snapshot.data ?? false,
                                            child:
                                                const CircularProgressIndicator(
                                              color: AppColors.mainColor,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  } else {
                                    return Text(
                                      'Upload',
                                      style: _manualBloc.pdf != null
                                          ? AppTextStyles.dialogtextStyle
                                          : AppTextStyles
                                              .dialogSecondaryTextStyle,
                                    );
                                  }
                                }
                                return Text(
                                  'Upload',
                                  style: _manualBloc.pdf != null
                                      ? AppTextStyles.dialogtextStyle
                                      : AppTextStyles.dialogSecondaryTextStyle,
                                );
                              }),
                        );
                      } else {}
                      return TextButton(
                        onPressed: null,
                        child: Text(
                          'Upload',
                          style: AppTextStyles.dialogSecondaryTextStyle,
                        ),
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
    //   return dialogWithButtons(
    //   //     title: 'Manual Upload',
    //       // content: _buildManualUploadField(),
    //   //     actions: ['Cancel', 'Upload'],
    //   //     callBack: onTapActions);
  }

  Widget _buildManualUploadField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey)),
      child: BlocBuilder<ManualBloc, ManualState>(
        bloc: _manualBloc,
        builder: (context, state) {
          if (state is PdfSelectedState) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: Text(
                  state.pdfName,
                  overflow: TextOverflow.ellipsis,
                )),
                IconButton(
                  onPressed: () {
                    _manualBloc.add(RemovePdfEvent());
                  },
                  icon: const Icon(
                    Icons.cancel,
                  ),
                  iconSize: 20,
                ),
              ],
            );
          } else {
            return TextButton(
                onPressed: () {
                  _manualBloc.openFileExplorer();
                },
                child: const Text(
                  'Selecione o manual',
                  overflow: TextOverflow.ellipsis,
                ));
          }
        },
      ),
    );
  }

  // void onTapActions(int index) {
  //   switch (index) {
  //     case 0:
  //       Modular.to.pop();
  //       break;
  //     case 1:
  //       Modular.to.pop();
  //       break;
  //     default:
  // }
  // }
}

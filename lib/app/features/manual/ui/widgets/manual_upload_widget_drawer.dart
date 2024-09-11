import 'dart:io';

import 'package:app_search/app/features/manual/interactor/blocs/manual_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../mixins/snackbar_mixin.dart';
import '../../interactor/blocs/manual_bloc.dart';
import '../../interactor/blocs/manual_state.dart';

class ManualUploadWidgetDrawer extends StatefulWidget {
  const ManualUploadWidgetDrawer({super.key});

  @override
  State<ManualUploadWidgetDrawer> createState() =>
      _ManualUploadWidgetDrawerState();
}

class _ManualUploadWidgetDrawerState extends State<ManualUploadWidgetDrawer> {
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
    return SizedBox(
      width: 160,
      // height: 55,
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.file_download_outlined,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _manualBloc.openFileExplorer(),
                  child: BlocBuilder<ManualBloc, ManualState>(
                      bloc: _manualBloc,
                      builder: (context, snapshot) {
                        final state = snapshot;
                        if (state is PdfSelectedState) {
                          return Row(
                            children: [
                              Expanded(
                                child: Text(
                                  state.pdfName,
                                  style: AppTextStyles.uploadManualTextStyle,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Text(
                            'Importar Manual',
                            style: AppTextStyles.drawerOptionsTextStyle,
                            softWrap: true,
                          );
                        }
                      }),
                ),
              ),
            ],
          ),
          BlocBuilder(
            bloc: _manualBloc,
            builder: (context, state) {
              if (state is PdfSelectedState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    StreamBuilder<bool>(
                        stream: _manualBloc.isSendingManual,
                        builder: (context, snapshot) {
                          final isSendingManual = snapshot.data ?? false;
                          if (isSendingManual) {
                            return const Align(
                              alignment: Alignment.centerLeft,
                              child: LinearProgressIndicator(
                                color: AppColors.mainColor,
                              ),
                            );
                          }
                          return Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  try {
                                    _manualBloc.removePdf();
                                  } on HttpException catch (_) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => const Dialog(
                                        backgroundColor: Colors.grey,
                                        child: SizedBox(
                                          width: 80,
                                          height: 50,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                                'Não foi possível excluir o pdf. Tente novamente'),
                                          ),
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => const Dialog(
                                        backgroundColor: Colors.grey,
                                        child: SizedBox(
                                          width: 80,
                                          height: 50,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                                'Erro ao tentar excluir o pdf. Tente novamente'),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Icon(
                                  Icons.disabled_by_default_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  try {
                                    await _manualBloc.uploadPdf().then((_) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => const Dialog(
                                          backgroundColor: Colors.grey,
                                          child: SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Pdf importado com sucesso!',
                                                softWrap: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                      _manualBloc.add(RemovePdfEvent());
                                    });
                                  } on HttpException catch (_) {
                                    if (!mounted) {
                                      return;
                                    }
                                    showDialog(
                                      context: context,
                                      builder: (context) => const Dialog(
                                        backgroundColor: Colors.grey,
                                        child: SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Falha ao importar o pdf. Tente novamente',
                                              softWrap: true,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    if (!mounted) {
                                      return;
                                    }
                                    showDialog(
                                      context: context,
                                      builder: (context) => const Dialog(
                                        backgroundColor: Colors.grey,
                                        child: SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Falha ao importar o pdf. Tente novamente',
                                              softWrap: true,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Icon(
                                  Icons.check_box_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              // StreamBuilder<bool>(
                              //   stream: _manualBloc.isSendingManual,
                              //   builder: (context, snapshot) {
                              //     final isVisible = snapshot.data ?? false;
                              //     return Visibility(
                              //         visible: isVisible,
                              //         child: const CircularProgressIndicator());
                              //   },
                              // )
                            ],
                          );
                        })
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
          )
        ],
      ),
    );
  }
}

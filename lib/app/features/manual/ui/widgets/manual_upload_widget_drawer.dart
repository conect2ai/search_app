import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

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

class _ManualUploadWidgetDrawerState extends State<ManualUploadWidgetDrawer>
    with SnackBarMixin {
  final _manualBloc = Modular.get<ManualBloc>();
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
                width: 5,
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
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            try {
                              _manualBloc.removePdf();
                            } on HttpException catch (_) {
                              generateSnackBar(
                                  'Não foi possível excluir o pdf. Tente novamente',
                                  context);
                            } catch (e) {
                              generateSnackBar(
                                  'Erro ao tentar excluir o pdf. Tente novamente',
                                  context);
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
                          onTap: () {
                            try {
                              _manualBloc.uploadPdf();
                            } on HttpException catch (_) {
                              generateSnackBar(
                                  'Não foi possível importar o pdf. Tente novamente',
                                  context);
                            } catch (e) {
                              generateSnackBar(
                                  'Erro ao tentar importar o pdf. Tente novamente',
                                  context);
                            }
                          },
                          child: const Icon(
                            Icons.check_box_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
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

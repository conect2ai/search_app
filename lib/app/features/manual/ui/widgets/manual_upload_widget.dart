import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../interactor/blocs/manual_bloc.dart';
import '../../interactor/blocs/manual_state.dart';

class ManualUploadWidget extends StatefulWidget {
  const ManualUploadWidget({super.key});

  @override
  State<ManualUploadWidget> createState() => _ManualUploadWidgetState();
}

class _ManualUploadWidgetState extends State<ManualUploadWidget> {
  final _manualBloc = Modular.get<ManualBloc>();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 185,
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white)),
          child: Row(
            children: [
              const Icon(
                Icons.file_download_outlined,
                color: Colors.white,
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
                              IconButton(
                                  onPressed: () => _manualBloc.removePdf(),
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ))
                            ],
                          );
                        } else {
                          return Text(
                            'Importar Manual',
                            style: AppTextStyles.uploadManualTextStyle,
                            softWrap: true,
                          );
                        }
                      }),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          width: 140,
          height: 49,
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.mainColor),
              color: AppColors.mainColor,
              borderRadius: BorderRadius.circular(10)),
          child: BlocBuilder<ManualBloc, ManualState>(
            bloc: _manualBloc,
            builder: (context, state) => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
              ),
              onPressed: () {
                if (state is PdfSelectedState) {
                  _manualBloc
                      .uploadPdf()
                      .then((_) => Modular.to.pushReplacementNamed('/chat/'));
                }
              },
              child: Text(
                'Confirmar',
                style: AppTextStyles.authScreenButtonsTextStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

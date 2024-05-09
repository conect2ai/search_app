import 'package:app_search/app/features/chat/interactor/blocs/manual_upload/manual_upload_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../mixins/custom_dialogs.dart';
import '../../interactor/blocs/manual_upload/manual_upload_bloc.dart';
import '../../interactor/blocs/manual_upload/manual_upload_state.dart';

class ManualUploadDialog extends StatefulWidget {
  const ManualUploadDialog({super.key});

  @override
  State<ManualUploadDialog> createState() => _ManualUploadDialogState();
}

class _ManualUploadDialogState extends State<ManualUploadDialog>
    with CustomDialogs {
  final _manualUploadBloc = Modular.get<ManualUploadBloc>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return dialogWithButtons(
        title: 'Manual Upload',
        content: _buildManualUploadField(),
        actions: ['Cancel', 'Upload'],
        callBack: onTapActions);
  }

  Widget _buildManualUploadField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black)),
      child: BlocBuilder<ManualUploadBloc, ManualUploadState>(
        bloc: _manualUploadBloc,
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
                    _manualUploadBloc.add(RemovePdfEvent());
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
                  _manualUploadBloc.add(SelectPdfEvent());
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

  void onTapActions(int index) {
    switch (index) {
      case 0:
        Modular.to.pop();
        break;
      case 1:
        Modular.to.pop();
        break;
      default:
    }
  }
}

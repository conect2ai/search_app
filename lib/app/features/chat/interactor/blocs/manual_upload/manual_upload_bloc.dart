import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'manual_upload_event.dart';
import 'manual_upload_state.dart';

class ManualUploadBloc extends Bloc<ManualUploadEvent, ManualUploadState> {
  FilePickerResult? _results;
  ManualUploadBloc() : super(NoPdfSelectedState()) {
    on<SelectPdfEvent>((event, emit) {
      _openFileExplorer();
      if (_results != null) {
        emit(PdfSelectedState(pdfName: 'Meu manual', pdfPath: 'Path'));
      }
    });
    on<RemovePdfEvent>((event, emit) {
      emit(NoPdfSelectedState());
    });
  }

  void _openFileExplorer() async {
    _results = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
  }
}

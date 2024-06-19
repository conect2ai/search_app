import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../data/upload_manual_repository.dart';
import 'manual_upload_event.dart';
import 'manual_upload_state.dart';

class ManualUploadBloc extends Bloc<ManualUploadEvent, ManualUploadState> {
  FilePickerResult? _results;
  XFile? _pdf;
  UploadManualRepository _manualRepository;
  ManualUploadBloc(this._manualRepository) : super(NoPdfSelectedState()) {
    on<SelectPdfEvent>((event, emit) {
      if (_results != null) {
        emit(PdfSelectedState(
            pdfName: event.pdfName, pdfPath: event.pdfFilePath));
      }
    });
    on<RemovePdfEvent>((event, emit) {
      _pdf = null;
      emit(NoPdfSelectedState());
    });
  }

  XFile? get pdf => _pdf;

  void openFileExplorer() async {
    _results = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (_results != null) {
      final pdfPlatformFile = _results!.files.first;
      _pdf = pdfPlatformFile.xFile;

      final file = File(_pdf!.path);
      await file.writeAsBytes(await _pdf!.readAsBytes());

      if (_pdf != null) {
        add(SelectPdfEvent(pdfName: _pdf!.name, pdfFilePath: file.path));
      }
    }
  }

  void uploadPdf() async {
    try {
      if (_pdf != null) {
        _manualRepository.uploadManualPdf(pdf!.name, pdf!.path);
      }
    } catch (error) {
      rethrow;
    }
  }
}

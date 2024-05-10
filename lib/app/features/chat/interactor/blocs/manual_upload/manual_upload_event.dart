import 'package:image_picker/image_picker.dart';

abstract class ManualUploadEvent {}

class SelectPdfEvent extends ManualUploadEvent {
  String pdfName;
  XFile? pdfFile;

  SelectPdfEvent({required this.pdfName, required this.pdfFile});
}

class RemovePdfEvent extends ManualUploadEvent {}

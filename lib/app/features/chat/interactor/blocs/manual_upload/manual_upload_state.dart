import 'package:image_picker/image_picker.dart';

abstract class ManualUploadState {}

class NoPdfSelectedState extends ManualUploadState {}

class PdfSelectedState extends ManualUploadState {
  String pdfName;
  XFile? pdfBytes;

  PdfSelectedState({required this.pdfName, required this.pdfBytes});
}

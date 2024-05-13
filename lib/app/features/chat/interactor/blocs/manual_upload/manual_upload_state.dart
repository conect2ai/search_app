abstract class ManualUploadState {}

class NoPdfSelectedState extends ManualUploadState {}

class PdfSelectedState extends ManualUploadState {
  String pdfName;
  String pdfPath;

  PdfSelectedState({required this.pdfName, required this.pdfPath});
}

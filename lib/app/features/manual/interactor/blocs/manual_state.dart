abstract class ManualState {}

class NoPdfSelectedState extends ManualState {}

class PdfSelectedState extends ManualState {
  String pdfName;
  String pdfPath;

  PdfSelectedState({required this.pdfName, required this.pdfPath});
}

abstract class ManualEvent {}

class SelectPdfEvent extends ManualEvent {
  String pdfName;
  String pdfFilePath;

  SelectPdfEvent({required this.pdfName, required this.pdfFilePath});
}

class RemovePdfEvent extends ManualEvent {}

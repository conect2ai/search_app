abstract class ManualUploadEvent {}

class SelectPdfEvent extends ManualUploadEvent {
  String pdfName;
  String pdfFilePath;

  SelectPdfEvent({required this.pdfName, required this.pdfFilePath});
}

class RemovePdfEvent extends ManualUploadEvent {}

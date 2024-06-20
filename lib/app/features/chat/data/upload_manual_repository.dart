abstract interface class UploadManualRepository {
  Future<void> uploadManualPdf(String pdfFileName, String pdfFilePath);
}

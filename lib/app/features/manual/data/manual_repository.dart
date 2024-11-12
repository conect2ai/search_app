abstract interface class ManualRepository {
  Future<void> uploadManualPdf(String pdfFileName, String pdfFilePath);
  Future<bool> checkIfThereIsManual();
}

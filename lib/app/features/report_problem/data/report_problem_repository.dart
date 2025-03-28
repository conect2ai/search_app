abstract interface class ReportProblemRepository {
  Future<Map<dynamic, dynamic>> sendAudioReportForTranscription(
    String audioFilePath,
  );
}

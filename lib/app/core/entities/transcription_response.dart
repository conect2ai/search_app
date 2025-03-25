class TranscriptionResponse {
  final Map<String, Map<String, Object>> _transcriptionData = {};

  static final TranscriptionResponse _transcriptionResponse =
      TranscriptionResponse._internal();

  factory TranscriptionResponse() {
    return _transcriptionResponse;
  }

  TranscriptionResponse._internal();

  void updateTranscriptionResponse(
      String messageId, Map<dynamic, dynamic> transcriptionInfo) {
    _transcriptionData[messageId] = {
      'transcription': transcriptionInfo['transcribed_text'],
      'problemAnalysis': transcriptionInfo['problemAnalysis'],
      'timings': transcriptionInfo['timings']
    };
  }

  List<List<String>> getChecklistInformation() {
    List<List<String>> resultCsv = [];
    final header = <String>[];
    header.add('transcription');
    header.add('identifier');
    header.add('problem');
    header.add('report');
    header.add('prompt_tokens');
    header.add('completion_tokens');
    header.add('total_tokens');
    header.add('total_cost_usd');
    header.add('transcriptionTime');
    header.add('analysisTime');
    header.add('totalTime');
    resultCsv.add(header);
    _transcriptionData.forEach((key, value) {
      List<String> stepInformation = [];
      stepInformation.add('${value['transcription']}');
      final defectAnalysis = value['problemAnalysis'] as Map<String, dynamic>;
      final analysis = defectAnalysis['analysis'] as Map<String, dynamic>;
      stepInformation.add('${analysis['identificador']}');
      stepInformation.add('${analysis['problema']}');
      stepInformation.add('${analysis['relato']}');
      final usage = defectAnalysis['usage'] as Map<String, dynamic>;
      stepInformation.add('${usage['prompt_tokens']}');
      stepInformation.add('${usage['completion_tokens']}');
      stepInformation.add('${usage['total_tokens']}');
      stepInformation.add('${usage['total_cost_usd']}');
      final timings = value['timings'] as Map<String, dynamic>;
      stepInformation.add('${timings['transcriptionTime']}');
      stepInformation.add('${timings['analysisTime']}');
      stepInformation.add('${timings['totalTime']}');
      resultCsv.add(stepInformation);
    });
    return resultCsv;
  }
}

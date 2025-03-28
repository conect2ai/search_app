import '../../../../../core/entities/chat_message.dart';

abstract class ReportProblemPageState {}

class InitialReportProblemPageState extends ReportProblemPageState {}

class ReceiveReportResponseState extends ReportProblemPageState {
  List<ChatMessage> results;

  ReceiveReportResponseState({required this.results});
}

class RecordingAudioState extends ReportProblemPageState {}

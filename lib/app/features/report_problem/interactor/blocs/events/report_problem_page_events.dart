import '../../../../../core/entities/chat_message.dart';

abstract class ReportProblemPageEvent {}

class LoadReportProblemPageEvent extends ReportProblemPageEvent {
  List<ChatMessage> results = [];
}

class RecordingAudioEvent extends ReportProblemPageEvent {}

class SendAudioEvent extends ReportProblemPageEvent {
  String path;
  SendAudioEvent({required this.path});
}

abstract class LoadingOverlayEvent {}

class ShowLoadingOverlayEvent extends LoadingOverlayEvent {}

class HideLoadingOverlayEvent extends LoadingOverlayEvent {}

class ShowErrorEvent extends LoadingOverlayEvent {
  String message;

  ShowErrorEvent({required this.message});
}

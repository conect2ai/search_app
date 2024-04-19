abstract class LoadingOverlayState {}

class ShowingLoadingOverlayState extends LoadingOverlayState {}

class HidingLoadingOverlayState extends LoadingOverlayState {}

class OnErrorState extends LoadingOverlayState {
  String message;

  OnErrorState({required this.message});
}

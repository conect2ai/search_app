import 'package:flutter_bloc/flutter_bloc.dart';

import 'loading_overlay_event.dart';
import 'loading_overlay_state.dart';

class LoadingOverlayBloc
    extends Bloc<LoadingOverlayEvent, LoadingOverlayState> {
  LoadingOverlayBloc() : super(HidingLoadingOverlayState()) {
    on<ShowLoadingOverlayEvent>(
        (event, emit) => emit(ShowingLoadingOverlayState()));
    on<HideLoadingOverlayEvent>(
        (event, emit) => emit(HidingLoadingOverlayState()));
    on<ShowErrorEvent>(
        (event, emit) => emit(OnErrorState(message: event.message)));
  }
}

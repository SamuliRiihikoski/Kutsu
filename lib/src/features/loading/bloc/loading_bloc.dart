import 'package:bloc/bloc.dart';
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:kutsu/singletons/application.dart';
import 'package:kutsu/src/features/datecard/bloc/datecard_bloc.dart';
import 'package:kutsu/src/features/lists/lists.dart';

part 'loading_event.dart';
part 'loading_state.dart';

class LoadingBloc extends Bloc<LoadingEvent, LoadingState> {
  LoadingBloc() : super(LoadingState(isLoading: false, message: "")) {
    on<StartStreaming>(_onStartStreaming);
    on<PauseStreaming>(_onPauseStreaming);
  }

  late StreamSubscription _subscription;

  void _handleLoadingStream(String message) {
    if (message != "") {
      emit(state.copyWith(isLoading: true, message: message));
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onStartStreaming(StartStreaming event, Emitter<LoadingState> emit) {
    _subscription =
        Application().loadingController.stream.listen((_handleLoadingStream));
  }

  void _onPauseStreaming(PauseStreaming event, Emitter<LoadingState> emit) {
    // _subscription.pause();
  }
}

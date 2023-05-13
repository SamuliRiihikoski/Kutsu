part of 'loading_bloc.dart';

abstract class LoadingEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class StartStreaming extends LoadingEvent {
  StartStreaming();
}

class PauseStreaming extends LoadingEvent {
  PauseStreaming();
}

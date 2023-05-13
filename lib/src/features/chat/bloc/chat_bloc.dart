import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kutsu/src/features/chat/chat.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc()
      : super(ChatState(messages: [], id_position: 0, action: ListState.idle)) {
    on<FetchMessages>(_onFetchMessages);
    on<AddMessage>(_onAddMessage);
  }

  Future<void> _onFetchMessages(
      FetchMessages event, Emitter<ChatState> emit) async {}

  Future<void> _onAddMessage(AddMessage event, Emitter<ChatState> emit) async {}
}

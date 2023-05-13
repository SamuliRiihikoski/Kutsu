part of 'chat_bloc.dart';

enum ListState { idle, updated }

class ChatState extends Equatable {
  ChatState(
      {required this.messages, required this.action, required this.id_position})
      : super() {}

  List<Message> messages;
  ListState action;

  int id_position;

  ChatState copyWith(
      {List<Message>? messages, int? id_position, ListState? action}) {
    return ChatState(
        messages: messages ?? this.messages,
        id_position: id_position ?? this.id_position,
        action: action ?? this.action);
  }

  @override
  List<Object> get props => [messages, id_position, action];
}

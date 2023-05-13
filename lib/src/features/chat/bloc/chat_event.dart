part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchMessages extends ChatEvent {}

class AddMessage extends ChatEvent {
  AddMessage({required this.message}) {}

  String message;
}

class RemoveMessage extends ChatEvent {}

part of 'joinlist_bloc.dart';

abstract class JoinListEvent extends Equatable {
  JoinListEvent() {}

  @override
  List<Object> get props => [];
}

class ListItemPressed extends JoinListEvent {}

class ProfileItemPressed extends JoinListEvent {}

class FetchLikesList extends JoinListEvent {}

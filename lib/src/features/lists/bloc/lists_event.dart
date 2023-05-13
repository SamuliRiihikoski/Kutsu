part of 'lists_bloc.dart';

abstract class ListEvent extends Equatable {
  ListEvent() {}

  List<Object> get props => [];
}

class RefreshCalendar extends ListEvent {}

class FetchCalendar extends ListEvent {}

class FetchUserLists extends ListEvent {}

class InitLists extends ListEvent {}

class AddInvitation extends ListEvent {
  AddInvitation({required this.date}) {}
  app.Date date;
}

class RemoveInvitation extends ListEvent {
  RemoveInvitation(
      {required this.date,
      required this.fromCalendar,
      required this.fromCreated,
      required this.fromLiked}) {}
  app.Date date;
  bool fromCalendar;
  bool fromCreated;
  bool fromLiked;
}

class AddIntoLikes extends ListEvent {
  AddIntoLikes({required this.date}) {}
  app.Date date;
}

class RemoveFromLikes extends ListEvent {
  RemoveFromLikes({required this.date}) {}
  app.Date date;
}

class LockDate extends ListEvent {
  LockDate({required this.date, required this.roomID}) {}
  app.Date date;
  String roomID;
}

class ChangeTabIndex extends ListEvent {
  ChangeTabIndex({required this.tabIndex}) {}
  int tabIndex;
}

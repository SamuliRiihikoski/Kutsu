part of 'lists_bloc.dart';

class ListState extends Equatable {
  ListState(
      {required this.invitations,
      required this.created,
      required this.liked,
      required this.alwaysUpdateTrigger,
      required this.calendarEnded,
      required this.cursor,
      required this.currentTabIndex}) {}

  Map<String, String> invitations;
  Map<String, String> created;
  Map<String, String> liked;

  int currentTabIndex;
  bool alwaysUpdateTrigger;
  bool calendarEnded;
  String cursor;

  ListState copyWith(
      {Map<String, String>? invitations,
      Map<String, String>? created,
      Map<String, String>? liked,
      int? currentTabIndex,
      bool? calendarEnded,
      String? cursor}) {
    return ListState(
        invitations: invitations ?? this.invitations,
        created: created ?? this.created,
        liked: liked ?? this.liked,
        currentTabIndex: currentTabIndex ?? this.currentTabIndex,
        alwaysUpdateTrigger: !this.alwaysUpdateTrigger,
        calendarEnded: calendarEnded ?? this.calendarEnded,
        cursor: cursor ?? this.cursor);
  }

  List<Object> get props =>
      [invitations, created, liked, alwaysUpdateTrigger, currentTabIndex];
}

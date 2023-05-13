import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:kutsu/singletons/activeuser.dart';
import 'package:kutsu/singletons/application.dart';
import 'package:kutsu/src/classes/classes.dart' as app;
import 'dart:math';

part 'lists_event.dart';
part 'lists_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc()
      : super(ListState(
            invitations: {},
            created: {},
            liked: {},
            alwaysUpdateTrigger: false,
            calendarEnded: false,
            currentTabIndex: Application().changeTabIndex,
            cursor: "")) {
    on<LockDate>(_onLockDate);
    on<RefreshCalendar>(_onRefreshCalendar);
    on<FetchCalendar>(_onFetchCalendar);
    on<FetchUserLists>(_onFetchUserLists);
    on<InitLists>(_onInitLists);
    on<RemoveInvitation>(_onRemoveInvitation);
    on<AddInvitation>(_onAddInvitation);
    on<AddIntoLikes>(_onAddIntoLikes);
    on<RemoveFromLikes>(_onRemoveFromLikes);
  }

  Future<void> _onInitLists(InitLists event, Emitter<ListState> emitter) async {
    emit(state.copyWith(invitations: {}, created: {}, liked: {}));

    if (Application().newUserLogged == true) {
      Application().addLoadingMessage("Luodaan profiilia");
      await ActiveUser().initUser();
      emit(state.copyWith(currentTabIndex: Application().changeTabIndex));
    } else {
      Application().addLoadingMessage("Haetaan kutsuja");
      await ActiveUser().initUser();
      add(FetchUserLists());
      add(FetchCalendar());
      emit(state.copyWith(currentTabIndex: Application().changeTabIndex));
    }

    Application().stopLoading();
  }

  Future<void> _onRefreshCalendar(
      RefreshCalendar event, Emitter<ListState> emitter) async {
    state.invitations.clear();
    state.calendarEnded = false;
    ActiveUser().documentSnapshot = null;
    add(FetchCalendar());
  }

  Future<void> _onLockDate(LockDate event, Emitter<ListState> emitter) async {
    state.created[event.date.refId] = event.roomID;

    emit(state.copyWith(created: state.created));
  }

  Future<void> _onFetchCalendar(
      FetchCalendar event, Emitter<ListState> emitter) async {
    List<app.Date> list = [];
    int dateCounter = 0;
    bool hasMoreUsers = true;
    QuerySnapshot<Map<String, dynamic>> rr;

    if (state.calendarEnded) return;

    int min_age =
        max(18, ActiveUser().user!.age - ActiveUser().user!.filters!.age);

    int max_age =
        min(70, ActiveUser().user!.age + ActiveUser().user!.filters!.age);

    while (hasMoreUsers && dateCounter < 100) {
      rr = (ActiveUser().documentSnapshot == null)
          ? await FirebaseFirestore.instance
              .collection('users')
              .where("gender", isEqualTo: ActiveUser().user!.filters.gender)
              .where("age", isGreaterThanOrEqualTo: min_age)
              .where("age", isLessThanOrEqualTo: max_age)
              .orderBy('age', descending: false)
              .limit(500)
              .get()
          : await FirebaseFirestore.instance
              .collection('users')
              .where("gender", isEqualTo: ActiveUser().user!.filters.gender)
              .where("age", isGreaterThanOrEqualTo: min_age)
              .where("age", isLessThanOrEqualTo: max_age)
              .orderBy('age', descending: false)
              .startAfter([state.cursor])
              .limit(500)
              .get();

      final users = rr.docs;
      if (users.isNotEmpty) ActiveUser().documentSnapshot = users.last;

      if (users.length < 500) {
        hasMoreUsers = false;
        state.calendarEnded = true;
      }

      for (final user in users) {
        print('user $user');
        if (user.id == FirebaseAuth.instance.currentUser!.uid) continue;

        final data = user.data() as Map<String, dynamic>;
        state.cursor = data['id'];

        if (!ActiveUser().userInDistance(
          data['location']['latitude'],
          data['location']['longitude'],
        )) continue;

        data['created'].forEach((key, value) {
          if (value == "" && !state.liked.keys.contains(key)) {
            state.invitations[key] = "";
            dateCounter++;
          }
        });
      }
    }

    emit(state.copyWith(
        invitations: state.invitations,
        calendarEnded: state.calendarEnded,
        cursor: state.cursor));
  }

  Future<void> _onFetchUserLists(
      FetchUserLists event, Emitter<ListState> emitter) async {
    final userRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    final data = userRef.data() as Map<String, dynamic>;

    Map<String, String> list1 = {};
    Map<String, String> list2 = {};
    data['created'].forEach((key, value) => list1[key] = value.toString());
    data['likes'].forEach((key, value) => list2[key] = value.toString());

    emit(state.copyWith(created: list1, liked: list2));
  }

  bool searchFromLikes(app.Date targetDate) {
    return state.liked.containsKey(targetDate.refId);
  }

  Future<void> _onRemoveInvitation(
      RemoveInvitation event, Emitter<ListState> emitter) async {
    state.invitations.remove(event.date.refId);
    state.created.remove(event.date.refId);
    state.liked.remove(event.date.refId);

    emit(state.copyWith(
        invitations: state.invitations,
        created: state.created,
        liked: state.liked));
  }

  Future<void> _onAddInvitation(
      AddInvitation event, Emitter<ListState> emitter) async {
    state.created[event.date.refId] = "";
    emit(state.copyWith(created: state.created));
  }

  Future<void> _onAddIntoLikes(
      AddIntoLikes event, Emitter<ListState> emitter) async {
    state.invitations.remove(event.date.refId);
    state.liked[event.date.refId] = "";
    emit(state.copyWith(liked: state.liked));
  }

  Future<void> _onRemoveFromLikes(
      RemoveFromLikes event, Emitter<ListState> emitter) async {
    state.liked.remove(event.date.refId);
    state.invitations[event.date.refId] = "";

    emit(state.copyWith(liked: state.liked, created: state.created));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'joinlist_event.dart';
part 'joinlist_state.dart';

class JoinListBloc extends Bloc<JoinListEvent, JoinListState> {
  JoinListBloc() : super(JoinListState(viewState: ViewStatus.list)) {
    on<ListItemPressed>(_onListItemPressed);
    on<ProfileItemPressed>(_onProfileItemPressed);
    on<FetchLikesList>(_onFetchLikeList);
  }

  Future<void> _onListItemPressed(
      ListItemPressed event, Emitter<JoinListState> emit) async {
    emit(state.copyWith(state: ViewStatus.profile));
  }

  Future<void> _onProfileItemPressed(
      ProfileItemPressed event, Emitter<JoinListState> emit) async {
    emit(state.copyWith(state: ViewStatus.list));
  }

  Future<void> _onFetchLikeList(
      FetchLikesList event, Emitter<JoinListState> emit) async {}
}

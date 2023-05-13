part of 'joinlist_bloc.dart';

enum ViewStatus { list, profile }

class JoinListState extends Equatable {
  JoinListState({required this.viewState}) : super() {}

  ViewStatus viewState;

  JoinListState copyWith({ViewStatus? state}) {
    return JoinListState(viewState: state ?? this.viewState);
  }

  @override
  List<Object> get props => [viewState];
}

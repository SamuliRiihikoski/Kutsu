part of 'datecard_bloc.dart';

class DateCardState extends Equatable {
  DateCardState({required this.locked}) : super() {}

  bool locked;

  DateCardState copyWith({bool? locked}) {
    return DateCardState(locked: locked ?? this.locked);
  }

  @override
  List<Object> get props => [locked];
}

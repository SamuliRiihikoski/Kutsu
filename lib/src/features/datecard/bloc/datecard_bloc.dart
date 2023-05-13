import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kutsu/src/classes/classes.dart' as app;
import 'package:kutsu/src/features/loading/loading.dart';

part 'datecard_event.dart';
part 'datecard_state.dart';

class DateCardBloc extends Bloc<DateCardEvent, DateCardState> {
  DateCardBloc() : super(DateCardState(locked: false)) {}
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kutsu/src/features/lists/lists.dart';

class CalendarList extends StatelessWidget {
  CalendarList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListBloc, ListState>(builder: (context, state) {
      if (state.invitations.isEmpty) {
        return const Center(
            child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Hakutuloksilla ei löytynyt kutsuja.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ));
      }

      return ListView.builder(
        key: const PageStorageKey("c"),
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        itemCount: state.invitations.length,
        itemBuilder: (BuildContext context, int index) {
          return DateTile(
            dateID: state.invitations.keys.elementAt(index),
            roomID: "",
            showIcon: false,
            errorCallback: (date) {},
          );
        },
      );
    });
  }
}

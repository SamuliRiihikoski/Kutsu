import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kutsu/providers/providers.dart';

import 'package:kutsu/src/features/lists/lists.dart';

class CreatedList extends StatelessWidget {
  const CreatedList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListBloc, ListState>(
      builder: (context, state) {
        if (state.created.length == 0) {
          return Center(
              child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Et ole vielä luonut omia kutsuja.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ));
        }

        return ListView.builder(
          key: PageStorageKey('x'),
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          itemCount: state.created.length,
          itemBuilder: (BuildContext context, int index) {
            return DateTile(
              dateID: state.created.keys.elementAt(index),
              roomID: state.created.values.elementAt(index),
              showIcon: true,
              errorCallback: (date) {
                context.read<DatesProvider>().removeDate(date, false);
                context.read<ListBloc>().add(RemoveInvitation(
                    date: date,
                    fromCalendar: false,
                    fromCreated: true,
                    fromLiked: false));
              },
            );
          },
        );
      },
    );
  }
}

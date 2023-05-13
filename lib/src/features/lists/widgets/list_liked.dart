import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:kutsu/providers/providers.dart';
import 'package:kutsu/src/classes/classes.dart';
import 'package:go_router/go_router.dart';
import 'package:kutsu/src/features/lists/lists.dart';

class LikedList extends StatelessWidget {
  const LikedList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListBloc, ListState>(
      builder: (context, state) {
        if (state.liked.length == 0) {
          return Center(
              child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Ei tykkäyksiä',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ));
        }

        return ListView.builder(
          key: PageStorageKey('b'),
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          itemCount: state.liked.length,
          itemBuilder: (BuildContext context, int index) {
            return DateTile(
              dateID: state.liked.keys.elementAt(index),
              roomID: state.liked.values.elementAt(index),
              showIcon: true,
              errorCallback: (date) {
                context.read<DatesProvider>().removeLike(date);
                context.read<ListBloc>().add(RemoveInvitation(
                    date: date,
                    fromCalendar: false,
                    fromCreated: false,
                    fromLiked: true));
              },
            );
          },
        );
      },
    );
  }
}

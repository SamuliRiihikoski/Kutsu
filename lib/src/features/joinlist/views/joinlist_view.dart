import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kutsu/providers/users.dart';
import 'package:kutsu/src/features/joinlist/joinlist.dart';
import 'package:kutsu/src/classes/classes.dart' as app;

class JoinListView extends StatelessWidget {
  JoinListView({required this.date, required this.callback, super.key});

  final app.Date date;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UsersProvider().getDateLikesList(date.refId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.length == 0) {
            return const Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  'Et ole ole vielä saanut tykkäyksiä tähän kutsuun',
                  style: TextStyle(fontSize: 18),
                ));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return FutureBuilder(
                future:
                    UsersProvider().getUser(snapshot.data!.elementAt(index)),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GestureDetector(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        leading: const Icon(Icons.account_circle, size: 50),
                        title: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 6),
                            child: Text(snapshot.data!.name)),
                        horizontalTitleGap: 25,
                        minVerticalPadding: 7,
                      ),
                      onTap: () {
                        callback(snapshot.data!.userID);
                        context.read<JoinListBloc>().add(ListItemPressed());
                        //context.goNamed('user', extra: date);
                      },
                    );
                  }
                  return const SizedBox(height: 0, width: 0);
                },
              );
            },
          );
        }
        return const SizedBox(height: 0, width: 0);
      },
    );
  }
}

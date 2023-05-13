import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kutsu/src/classes/classes.dart' as app;
import 'package:kutsu/src/features/datecard/datecard.dart';
import 'package:kutsu/src/features/joinlist/joinlist.dart';
import 'package:kutsu/src/features/joinlist/views/views.dart';
import 'package:kutsu/src/features/users/user.dart';

class JoinListScreen extends StatelessWidget {
  JoinListScreen({required this.date, required this.callback, super.key});

  app.Date date;
  Function callback;
  String? userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => JoinListBloc(),
        child: BlocBuilder<JoinListBloc, JoinListState>(
          builder: (context, state) {
            if (state.viewState == ViewStatus.list) {
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Tykkäykset',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Color.fromARGB(255, 46, 46, 46),
                  ),
                  Expanded(
                    child: JoinListView(
                      date: date,
                      callback: (id) {
                        userId = id;
                      },
                    ),
                  ),
                ],
              );
            } else if (state.viewState == ViewStatus.profile) {
              return Column(
                children: [
                  if (userId != null) ...[
                    UserCard(
                      refId: userId!,
                    ),
                    QuestionView(
                      callback: () {
                        callback(userId);
                      },
                    ),
                  ]
                ],
              );
            }

            return Text('Odottamaton virhe tapahtui.');
          },
        ),
      ),
    );
  }
}

class QuestionView extends StatelessWidget {
  QuestionView({required this.callback, super.key});

  VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 5),
                  child: Text(
                    'Aloita chat huone tämän henkilön kanssa?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ))),
          Container(
            height: 1,
            color: Color.fromARGB(255, 184, 184, 184),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: Text(
                    'EI',
                    style: TextStyle(
                      fontSize: 19,
                    ),
                  ),
                  onTap: () {
                    context.read<JoinListBloc>().add(ProfileItemPressed());
                  },
                ),
                GestureDetector(
                  child: Text(
                    'KYLLÄ',
                    style: TextStyle(
                      fontSize: 19,
                    ),
                  ),
                  onTap: () {
                    callback();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

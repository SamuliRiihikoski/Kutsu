import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:go_router/go_router.dart';
import 'package:kutsu/providers/dates.dart';
import 'package:kutsu/providers/rooms.dart';
import 'package:kutsu/singletons/application.dart';
import 'package:kutsu/src/classes/classes.dart' as app;
import 'package:kutsu/src/features/datecard/bloc/datecard_bloc.dart';
import 'package:kutsu/src/features/lists/bloc/lists_bloc.dart';
import 'package:kutsu/src/features/loading/bloc/loading_bloc.dart';
import '../../../../extensions.dart';

class DateCard extends StatelessWidget {
  const DateCard({required this.date, super.key});

  final app.Date date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      date.label!,
                      style: context.labelLarge!
                          .copyWith(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  color: Color.fromARGB(255, 0, 0, 0),
                )
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Text(date.text!,
                              style:
                                  context.labelLarge!.copyWith(fontSize: 17)),
                        ),
                      ),
                    ),
                  ),
                ),
                if (FirebaseAuth.instance.currentUser!.uid == date.userId ||
                    date.chatroom != "") ...[
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: ClickableIcon(
                      icon: Icons.delete,
                      iconColor: Color.fromARGB(255, 168, 86, 86),
                      onPressed: () async {
                        Application().addLoadingMessage("Poistetaan kutsua");
                        if (FirebaseAuth.instance.currentUser!.uid ==
                            date.userId) {
                          Application().changeTabIndex = 1;
                        } else {
                          Application().changeTabIndex = 2;
                        }

                        if (date.chatroom != "") {
                          await context
                              .read<RoomsProvider>()
                              .deleteRoom(date.chatroom);
                        }

                        context.read<ListBloc>().add(RemoveInvitation(
                            date: date,
                            fromCalendar: true,
                            fromCreated: true,
                            fromLiked: true));
                        await context
                            .read<DatesProvider>()
                            .removeDate(date, true);
                        Application().stopLoading();

                        context.pop();
                      },
                    ),
                  ),
                ] else if (context.read<ListBloc>().searchFromLikes(date)) ...[
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: ClickableIcon(
                      icon: Icons.thumb_up,
                      iconColor: Color.fromARGB(255, 88, 129, 183),
                      onPressed: () async {
                        Application().addLoadingMessage("Poistetaan tykkäys");
                        Application().changeTabIndex = 2;
                        await context.read<DatesProvider>().removeLike(date);
                        context.read<ListBloc>().add(RemoveFromLikes(
                              date: date,
                            ));
                        Application().stopLoading();
                      },
                    ),
                  ),
                ] else ...[
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: ClickableIcon(
                      icon: Icons.thumb_up,
                      iconColor: Color.fromARGB(255, 200, 200, 200),
                      onPressed: () async {
                        Application().addLoadingMessage("Lisätään tykkäys");
                        Application().changeTabIndex = 0;
                        await context.read<DatesProvider>().addLike(date);
                        context.read<ListBloc>().add(AddIntoLikes(date: date));
                        Application().stopLoading();
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ClickableIcon extends StatelessWidget {
  ClickableIcon(
      {required this.icon,
      required this.iconColor,
      required this.onPressed,
      this.label,
      super.key});
  final VoidCallback onPressed;
  final IconData icon;
  final Color iconColor;
  String? label;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListBloc, ListState>(
      builder: (context, state) {
        return GestureDetector(
          child: SizedBox(
            height: 50,
            width: 50,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Column(
                children: [
                  Icon(
                    icon,
                    size: 50,
                    color: iconColor,
                  ),
                  Text(
                    (label) ?? '',
                    style: TextStyle(color: Color.fromARGB(255, 133, 133, 133)),
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            onPressed();
          },
        );
      },
    );
  }
}

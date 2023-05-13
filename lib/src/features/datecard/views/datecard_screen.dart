import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kutsu/providers/providers.dart';
import 'package:kutsu/singletons/application.dart';
import 'package:kutsu/src/features/chat/views/chat_screen.dart';
import 'package:kutsu/src/features/datecard/datecard.dart';
import 'package:kutsu/src/features/joinlist/joinlist.dart';
import 'package:kutsu/src/features/lists/bloc/lists_bloc.dart';
import 'package:kutsu/src/classes/classes.dart' as app;
import 'package:kutsu/src/features/users/user.dart';

class DateCardScreen extends StatefulWidget {
  DateCardScreen({required this.date, super.key});

  app.Date date;

  @override
  State<DateCardScreen> createState() => _DateCardScreenState();
}

class _DateCardScreenState extends State<DateCardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DateCardBloc, DateCardState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
            child: Column(children: [
              Expanded(flex: 1, child: DateCard(date: widget.date)),
              if (widget.date.chatroom != "") ...[
                Expanded(
                  flex: 4,
                  child: ChatScreen(
                      roomID: widget.date.chatroom,
                      roomError: () {
                        print('DELETE THIS CHAT ROOM !!!');
                        context.read<DatesProvider>().removeLike(widget.date);
                        context.read<ListBloc>().add(RemoveInvitation(
                            date: widget.date,
                            fromCalendar: true,
                            fromCreated: true,
                            fromLiked: true));
                      }),
                ),
              ] else if (FirebaseAuth.instance.currentUser!.uid ==
                  widget.date.userId) ...[
                Expanded(
                  flex: 3,
                  child: JoinListScreen(
                    date: widget.date,
                    callback: (friendID) async {
                      Application()
                          .addLoadingMessage('Luodaan keskustelu huone');
                      final roomID = await context
                          .read<RoomsProvider>()
                          .createRoom(widget.date.refId, friendID);

                      context
                          .read<ListBloc>()
                          .add(LockDate(date: widget.date, roomID: roomID));

                      setState(() {
                        widget.date.chatroom = roomID;
                      });

                      Application().stopLoading();
                    },
                  ),
                ),
              ] else ...[
                Expanded(
                    flex: 3,
                    child: UserCard(
                      refId: widget.date.userId!,
                    )),
                Spacer(),
              ],
            ]),
          );
        },
      ),
    );
  }
}

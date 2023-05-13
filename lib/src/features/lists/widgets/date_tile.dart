import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kutsu/src/classes/classes.dart' as app;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kutsu/providers/dates.dart';

class DateTile extends StatelessWidget {
  DateTile(
      {required this.dateID,
      required this.roomID,
      required this.errorCallback,
      required this.showIcon,
      super.key});

  app.Date? date;
  String? dateID;
  String? roomID;
  Function errorCallback;
  bool showIcon;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<DatesProvider>().getDate(dateID!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          app.Date date = snapshot.data!;
          date.chatroom = roomID!;
          (roomID != null) ? date.chatroom = roomID! : null;
          return GestureDetector(
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: (showIcon == true) ? 20 : 10,
                vertical: 5.0,
              ),
              minLeadingWidth: 0,
              horizontalTitleGap: 15,
              leading: (showIcon == false)
                  ? SizedBox(
                      height: 0,
                      width: 0,
                    )
                  : (date.chatroom != "")
                      ? Icon(Icons.message_outlined)
                      : Icon(Icons.person),
              title: Text(
                date.label!,
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text(
                date.text!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18),
              ),
            ),
            onTap: () {
              print('card: roomID:${roomID}');
              context.goNamed('date_card', extra: date);
            },
          );
        } else if (snapshot.hasError) {
          errorCallback(date);
          return Text('Not Found: ${date!.refId}');
        }

        return const ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 0.0,
          ),
          //leading: Icon(Icons.message_outlined),
          title: Text(
            "Haetaan kutsua",
            style: TextStyle(
                fontSize: 20, color: Color.fromARGB(255, 152, 152, 152)),
          ),
          subtitle: Text(
            "",
            style: TextStyle(fontSize: 18),
          ),
        );
      },
    );
  }
}

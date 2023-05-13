import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kutsu/providers/providers.dart';
import 'package:kutsu/src/classes/classes.dart' as app;
import '../../../../extensions.dart';
import 'package:kutsu/src/features/profile/profile_image.dart';

import 'dart:async';

class UserCard extends StatelessWidget {
  UserCard({required this.refId, super.key});

  final String refId;
  late app.User user;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: UsersProvider().getUser(refId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            user = app.User(
                userID: refId,
                name: snapshot.data!.name,
                age: snapshot.data!.age,
                gender: snapshot.data!.gender,
                text: snapshot.data!.text,
                location: app.Location(latitude: 0, longitude: 0),
                filters: app.Filters(
                    age: snapshot.data!.filters.age,
                    distance: snapshot.data!.filters.distance,
                    gender: snapshot.data!.filters.gender));

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '${user.name}, ${user.age}',
                        style: context.labelLarge!.copyWith(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    color: const Color.fromARGB(255, 82, 82, 82),
                    height: 1,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileImage(
                              editable: false,
                              userID: user.userID,
                              size: "small",
                            ),
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  user.text,
                                  style: context.labelLarge!
                                      .copyWith(fontSize: 17),
                                ),
                              ),
                            )),
                          ]),
                    ),
                  )
                ],
              ),
              onTap: () {
                print('hi');
                //context.read<JoinListBloc>().add(ProfileItemPressed());
              },
            );
          }
          return const Text(
            'Loading user profile...',
            style: TextStyle(fontSize: 18),
          );
        });
  }
}

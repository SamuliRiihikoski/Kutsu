import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(children: const [
            //UserCard(label: "Profile", user_id: 1),
          ]),
        ),
        onTap: () {
          context.pop();
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

class GroupDecoration extends StatelessWidget {
  const GroupDecoration({required this.label, required this.child, super.key});

  final String label;
  final List<Widget> child;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
              child: Text(
                this.label,
                style: const TextStyle(
                    fontSize: 20, color: Color.fromARGB(255, 66, 66, 66)),
              ),
            ),
            Container(
              constraints: const BoxConstraints(maxWidth: 500, maxHeight: 1),
              color: Color.fromARGB(255, 174, 174, 174),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
              child: Column(children: this.child),
            )
          ],
        ));
  }
}

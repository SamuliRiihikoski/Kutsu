import 'package:flutter/material.dart';

class LabelWithButton extends StatelessWidget {
  const LabelWithButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: Container(
              color: Colors.red,
            )),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Container(color: Colors.blue),
              Container(color: Color.fromARGB(255, 102, 139, 168))
            ],
          ),
        ),
      ],
    );
  }
}

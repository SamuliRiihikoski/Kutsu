import 'package:flutter/material.dart';

class ListButton extends StatelessWidget {
  const ListButton({required this.label, required this.callback, super.key});

  final String label;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(120, 0, 120, 0),
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 218, 221, 224),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 40,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 20, color: Color.fromARGB(255, 61, 61, 61)),
            ),
          ),
        ),
        onTap: () {
          callback();
        },
      ),
    );
  }
}

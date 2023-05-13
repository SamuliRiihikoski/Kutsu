import 'package:flutter/material.dart';

class RowInfo extends StatelessWidget {
  const RowInfo({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
          const Icon(Icons.arrow_right),
        ],
      ),
    );
  }
}

class ButtonInfo extends StatelessWidget {
  const ButtonInfo({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 231, 209, 209),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Color.fromARGB(255, 133, 47, 47), width: 1),
        ),
        child: Center(
            child: Text(
          label,
          style: const TextStyle(fontSize: 20),
        )),
      ),
    );
  }
}
